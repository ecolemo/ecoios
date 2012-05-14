//
//  EIValueSelectViewController.h
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EIValueEditViewController.h"

@interface EIValueSelectViewController : EIValueEditViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString* footerText;
    NSString* selectedValue;
    NSArray* values;
    NSArray* labels;
    
    NSInteger selectedIndex;
}

@property (nonatomic, retain) NSString* footerText;
@property (nonatomic, retain) NSString* selectedValue;
@property (nonatomic, retain) NSArray* values;
@property (nonatomic, retain) NSArray* labels;

@end
