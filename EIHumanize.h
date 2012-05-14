//
//  EIHumanizeKorean.h
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 24..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString* humanizeDateString(NSString* dateString);
NSString* humanizeGender(NSString* genderFlag);
NSString* humanize(NSString* type, NSObject* value);
id defaultValue(id object, id defaultValue);

@interface EIHumanizeKorean : NSObject

@end
