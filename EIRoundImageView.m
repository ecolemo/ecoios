//
//  EFRoundImageView.m
//  KamicoloiOS
//
//  Created by 영록 on 11. 8. 8..
//  Copyright 2011 ecolemo. All rights reserved.
//

#import "EIRoundImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EIRoundImageView

-(void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;    
}
@end
