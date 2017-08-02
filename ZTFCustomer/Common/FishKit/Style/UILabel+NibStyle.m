//
//  UILabel+NibStyle.m
//  mplus
//
//  Created by QFish on 10/16/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import "UILabel+NibStyle.h"
#import "FishKit.h"

@implementation UILabel (NibStyle)

@dynamic nibTextColor;
@dynamic nibAdjusts;
@dynamic nibColor;

- (void)setNibTextColor:(NSString *)nibTextColor
{
    self.textColor = [UIColor colorWithHexString:nibTextColor];;
}

- (void)setNibColor:(NSString *)nibColor
{
	[self setNibTextColor:nibColor];
}

- (void)setNibAdjusts:(NSNumber *)nibAdjusts
{
	self.adjustsFontSizeToFitWidth = nibAdjusts.intValue;
}

@end
