//
//  EFHttpUtils.m
//  lightnow-client-ios
//
//  Created by Pak Youngrok on 12. 2. 3..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIWebUtils.h"

@implementation EIWebUtils

+ (void)setCookieValue:(NSString*)value name:(NSString*)name domain:(NSString*)domain storage: (NSHTTPCookieStorage *)storage{
    if (value == nil) return;
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];    
    [storage setCookie:[NSHTTPCookie cookieWithProperties:cookieProperties]];
}

+ (NSMutableDictionary *)queryDictionaryForRequest:(NSURLRequest *)request {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if (request.URL.query) {
        for (NSString* param in [request.URL.query componentsSeparatedByString:@"&"]) {
            NSArray* parts = [param componentsSeparatedByString:@"="];
            if ([parts count] < 2) continue;
            [query setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
        }
    }
    return query;
}

+ (NSObject*)JSONFromWebView:(UIWebView *)aWebView forName:(NSString*)name {
    NSError* error;
    NSString* text = [aWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"JSON.stringify(%@)", name]];
    return [NSJSONSerialization JSONObjectWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
}


@end

@implementation EIMultipartBody

- (void)beginWithRequest:(NSMutableURLRequest*)request {
    body = [[NSMutableData alloc] init];
    mutableRequest = request;
    boundary = @"-----------------0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]; 
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendData:(NSData*)data forName:(NSString*)name andFilename:(NSString*)filename {
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
}

- (void)appendSeparator {
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendValue:(NSString*)value forName:(NSString*)name {
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void)end {
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [mutableRequest setHTTPBody:body];
}

@end
