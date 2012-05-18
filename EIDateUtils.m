//
//  EIDateUtils.m
//  chattingvil-ios
//
//  Created by Pak Youngrok on 12. 5. 8..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIDateUtils.h"

@implementation EIDateUtils

+ (NSInteger)ageFromUTCString:(NSString*)utcString {
    NSInteger birthYear = [[[utcString componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
    NSInteger currentYear = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
    
    return currentYear - birthYear;
}

+ (NSString*)UTCDateFormat:(NSDate*)date {
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return [format stringFromDate:date];
}

@end
