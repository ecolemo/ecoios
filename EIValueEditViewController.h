//
//  EIValueEditViewController.h
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EIEditResultHandler)(NSString* result);

@interface EIValueEditViewController : UIViewController {
    UILabel* label;
    UILabel* footerLabel;
    
    EIEditResultHandler completionHandler;
}

@property (nonatomic, retain) IBOutlet UILabel* label;
@property (nonatomic, retain) IBOutlet UILabel* footerLabel;

- (NSString*)editedValue;
- (void)setCompletionHandler:(EIEditResultHandler)handler;

@end
