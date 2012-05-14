//
//  EITextEditController.h
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EIValueEditViewController.h"

@interface EITextFieldController : EIValueEditViewController {
    UITextField* valueField;
}

@property (nonatomic, retain) IBOutlet UITextField* valueField;

@end
