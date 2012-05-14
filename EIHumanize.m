//
//  EIHumanizeKorean.m
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 24..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIHumanize.h"

NSString* humanizeDateString(NSString* dateString) {
    NSDateFormatter* format = [NSDateFormatter new];
    format.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [format setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate* date = [format dateFromString:dateString];
    
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    
    if (interval < 60) return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%2.0fs", @"humanize", nil), interval];
    else if (interval < 3600) return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%2.0fm", @"humanize", nil), interval / 60];
    else if (interval < 86400) return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%2.0fh", @"humanize", nil), interval / 3600]; 
    else if (interval < 86400 * 30) return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%2.0fd", @"humanize", nil), interval / 86400]; 
    else return NSLocalizedStringFromTable(@"long ago", @"humanize", nil);
}

NSString* humanizeGender(NSString* genderFlag) {
    return NSLocalizedStringFromTable(genderFlag, @"humanize", @"gender");
}

NSString* humanize(NSString* type, NSObject* value) {
    if ([type isEqualToString:@"gender"]) {
        return humanizeGender((NSString*) value);
    }
    return [NSString stringWithFormat:@"%@", value];
}

id defaultValue(id object, id defaultValue) {
    if (object) return object;
    return defaultValue;
}

@implementation EIHumanizeKorean

@end
