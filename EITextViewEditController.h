//
//  EITextViewEditController.h
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIValueEditViewController.h"
@interface EITextViewEditController :  EIValueEditViewController {
    UITextView* valueField;
}

@property (nonatomic, retain) IBOutlet UITextView* valueField;

@end
