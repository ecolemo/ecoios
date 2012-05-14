//
//  EITextViewEditController.m
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EITextViewEditController.h"
#import <QuartzCore/QuartzCore.h>
@interface EITextViewEditController ()

@end

@implementation EITextViewEditController
@synthesize valueField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.valueField.layer.cornerRadius = 5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)setCompletionHandler:(void (^)(NSString* value))handler {
    completionHandler = Block_copy(handler);
}

- (NSString *)editedValue {
    return valueField.text;
}
@end
