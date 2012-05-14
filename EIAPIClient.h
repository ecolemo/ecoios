//
//  APIClient.h
//  KamicoloiOS
//
//  Created by 영록 on 11. 5. 30..
//  Copyright 2011 ecolemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define urlencode(s)    [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CONNECTION_TIMEOUT 7
typedef void (^EIErrorHandler)(NSError* error);
typedef void (^EIResponseHandler)(NSDictionary*);

@interface EIURLConnectionDelegate : NSObject {
    NSMutableData* data;
    void (^successHandler)(NSDictionary*);
    EIErrorHandler errorHandler;
    NSInteger statusCode;
}

+ (void)parseData : (NSData*)data andHandler:(void (^)(NSDictionary* result))handler andErrorHandler:(EIErrorHandler)errorHandler; 
- (id)initWithSuccessHandler: (void (^)(NSDictionary* result))handler andErrorHandler:(EIErrorHandler)error;

@end

@interface EIAPIClient : NSObject {
    NSString* baseURL;
    NSString* credential;
}

+ (NSString *)generateBoundaryString;

- (id)initWithBaseURL:(NSString*)prefixStr andCredential:(NSString*)credentialStr;

- (void)sendRequest:(NSMutableURLRequest*)request onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler;

- (void)get:(NSString*)path onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;
- (void)post:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;
- (void)post:(NSString*)path andInputStream:(NSInputStream*)stream andBodyLength:(unsigned long long)length andBoundary:(NSString*)boundary  onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;
- (void)put:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;
- (void)delete:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;

/// sync
- (void)sendSyncRequest:(NSMutableURLRequest*)request onSuccess:(void (^)(NSDictionary* result))handler onError:(EIErrorHandler)errorHandler;
- (void)syncPost:(NSString*)path andBody:(NSString*)body onSuccess:(void (^)(NSDictionary* result))successHandler onError:(EIErrorHandler)errorHandler;
@end

NSString* formatURL(NSString* format, NSObject* first, ...);

void (^EIErrorAlert)(NSError*);
