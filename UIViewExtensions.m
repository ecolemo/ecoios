//
//  UIViewExtensions.m
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 2. 22..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "UIViewExtensions.h"

@implementation UIView (NibLoad)

+ (id)loadObjectFromNib:(NSString*)nibName {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nib objectAtIndex:0];
}
@end
