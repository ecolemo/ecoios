//
//  EFHttpUtils.h
//  lightnow-client-ios
//
//  Created by Pak Youngrok on 12. 2. 3..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EIWebUtils : NSObject

+ (void)setCookieValue:(NSString*)value name:(NSString*)name domain:(NSString*)domain storage: (NSHTTPCookieStorage *)storage;
+ (NSMutableDictionary *)queryDictionaryForRequest:(NSURLRequest *)request;
+ (NSObject*)JSONFromWebView:(UIWebView *)aWebView forName:(NSString*)name;
@end

@interface EIMultipartBody : NSObject {
@private
    NSMutableData* body;
    NSMutableURLRequest* mutableRequest;
    NSString* boundary;
}
- (void)beginWithRequest:(NSMutableURLRequest*)request;
- (void)appendData:(NSData*)data forName:(NSString*)name andFilename:(NSString*)filename;
- (void)appendValue:(NSString*)value forName:(NSString*)name;
- (void)appendSeparator;
- (void)end;

@end