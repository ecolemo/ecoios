#import "EIAPIClient.h"
#import "EIWebUtils.h"
#import "SBJson.h"
@implementation EIURLConnectionDelegate

- (id)initWithSuccessHandler: (void (^)(NSDictionary* result))handler andErrorHandler:(EIErrorHandler)error {
    data = [NSMutableData new];
    successHandler = Block_copy(handler);
    errorHandler = Block_copy(error);
    return self;
}

- (void)dealloc {
    [data release];
    // TODO 버그 위치 release시에 block 안에 block ui 호출시 죽음
    //Block_release(successHandler);
    //Block_release(errorHandler);
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    assert(connection);
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = [((NSHTTPURLResponse*)response) statusCode];
        
        if (statusCode != 200) {
            NSLog(@"response status code: %d", statusCode);
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Server Error" forKey:NSLocalizedDescriptionKey];
            [details setValue:[NSString stringWithFormat:@"%d", statusCode]  forKey:@"Code"];
            errorHandler([[[NSError alloc] initWithDomain:@"http error" code:statusCode userInfo:details] autorelease]);
//            [connection cancel];
        }
    } else {
        NSLog(@"error - http protocol don't use"); 
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"http protocol don't use" forKey:NSLocalizedDescriptionKey];
        [details setValue:[NSString stringWithFormat:@"%d", -1]  forKey:@"Code"];
        errorHandler([[[NSError alloc] initWithDomain:@"http error" code:-1 userInfo:details] autorelease]);
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receievedData {
    [data appendData:receievedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (statusCode != 200) {
        NSLog(@"response error: %d\n%@", statusCode, result);
        return;
    }
    
    //NSLog(@"%@", result);
    SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
    NSError* error = nil;
    NSDictionary* resultDict = [jsonParser objectWithString:result error:&error];
    if (error) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        // TODO load from localized property file
        [details setValue:@"Server Error" forKey:NSLocalizedDescriptionKey];
        [details setValue:error forKey:@"SBJSON_ERROR"];
        [details setValue:result forKey:@"RESPONSE_STRING"];
        NSError* errorForParse = [[NSError alloc] initWithDomain:@"org.ecolemo"
                                                            code:1 userInfo:details];
        errorHandler(errorForParse);
        [errorForParse release];
    } else if ([resultDict objectForKey:@"error"]) {
        NSLog(@"%@", result);
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:[resultDict objectForKey:@"error"]];
        [userInfo setValue:[userInfo objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
        error = [[NSError alloc] initWithDomain:@"Server Exception" code:1 userInfo:userInfo];
        
        errorHandler(error);
        [error release];
    } else {
        successHandler(resultDict);
    }
    [jsonParser release];
    [result release];

}

@end

@implementation EIAPIClient

+ (NSString *)generateBoundaryString {
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (id)initWithBaseURL:(NSString*)prefixStr andCredential:(NSString*)credentialStr {
    baseURL = [prefixStr retain];
    credential = [credentialStr retain];
    return self;
}

- (void)dealloc {
    [baseURL release];
    [credential release];
    [super dealloc];
}


//- (void)sendSyncRequest:(NSMutableURLRequest*)request onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler {
//    [request addValue:credential forHTTPHeaderField:@"Authorization"];
//    NSString* bodyStr = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
//    NSLog(@"sync %@ %@ %@", [request HTTPMethod], [request URL], bodyStr);
//    [bodyStr release];
//    
//    // main thread 가 아닐 경우 ui 콜 루틴 신경 쓸 것
//    NSURLResponse* response = nil;
//    NSError* error = nil;
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        errorHandler(error);
//        return;
//    }
//    assert(response);
//    [EIURLConnectionDelegate parseData:data andHandler:handler andErrorHandler:errorHandler];
//}

- (void)sendRequest:(NSMutableURLRequest*)request onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler {
    [EIWebUtils setCookieValue:credential name:@"login" domain:request.URL.host storage:[NSHTTPCookieStorage sharedHTTPCookieStorage]];
    [request addValue:credential forHTTPHeaderField:@"Authorization"];
    NSString* bodyStr = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    NSLog(@"%@ %@ %@", [request HTTPMethod], [request URL], bodyStr);
    [bodyStr release];
    
    // TODO move notificatino to WMURLConnectionDelegate
    EIURLConnectionDelegate* delegate = [[EIURLConnectionDelegate alloc] initWithSuccessHandler:^(NSDictionary* result) {
        handler(result);
    } andErrorHandler:^(NSError* error) {
        errorHandler(error);
        
    }];
    [NSURLConnection connectionWithRequest:request delegate:delegate];
    [delegate release];
    
}

- (void)get:(NSString*)path onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler{    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, path]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"GET"];
    [self sendRequest: request onSuccess:handler onError:errorHandler];
}

- (void)post:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, path]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//  TODO request key 인증 적용 하기
//    [RequestEncryption encryptRequest:request];
    [self sendRequest: request onSuccess:handler onError:errorHandler];
}

- (void)post:(NSString*)path andInputStream:(NSInputStream*)stream andBodyLength:(unsigned long long)length andBoundary:(NSString*)boundary  onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, path]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBodyStream:stream];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%llu", length] forHTTPHeaderField:@"Content-Length"];

    [self sendRequest: request onSuccess:successHandler onError:errorHandler];
}

- (void)put:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, path]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONNECTION_TIMEOUT];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self sendRequest: request onSuccess:handler onError:errorHandler];
}

// TODO check if body needed when delete
- (void)delete:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, path]]];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self sendRequest: request onSuccess:handler onError:errorHandler];
}



//- (void)syncPost:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler {
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", baseURL, path]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONNECTION_TIMEOUT];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    [self sendSyncRequest:request onSuccess:successHandler onError:errorHandler];
//}

@end

void (^EIErrorAlert)(NSError*) = ^(NSError* error) {
    NSLog(@"%@\n%@", error, [error userInfo]);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
    [alert autorelease];
};

NSString* urlencode(NSString* str) {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );    
}