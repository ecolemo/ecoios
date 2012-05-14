//
//  EIStretchableImageView.m
//  lightnow-ios
//
//  Created by Pak Youngrok on 12. 3. 5..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIStretchableImageView.h"

@implementation EIStretchableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib {
    self.image = [self.image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
}

@end
