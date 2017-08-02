//
//  UIButton+NibStyle.m
//  mplus
//
//  Created by QFish on 10/16/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import "UIButton+NibStyle.h"
#import "FishKit.h"

@implementation UIButton (NibStyle)

@dynamic nibTextColor;
@dynamic nibNormalTextColor;
@dynamic nibSelectedTextColor;
@dynamic nibHighlightedTextColor;
@dynamic nibDisabledTextColor;

- (void)setNibTintColor:(NSString *)tintColor
{
    [self setTintColor:[UIColor colorWithHexString:tintColor]];
}

- (void)setNibTextColor:(NSString *)nibTextColor
{
	[self setNibNormalTextColor:nibTextColor];
}

- (void)setNibNormalTextColor:(NSString *)nibNormalTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibNormalTextColor] forState:UIControlStateNormal];
}

- (void)setNibSelectedTextColor:(NSString *)nibSelectedTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibSelectedTextColor] forState:UIControlStateSelected];
}

- (void)setNibHighlightedTextColor:(NSString *)nibHighlightedTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibHighlightedTextColor] forState:UIControlStateHighlighted];
}

- (void)setNibDisabledTextColor:(NSString *)nibDisabledTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibDisabledTextColor] forState:UIControlStateDisabled];
}

@end
