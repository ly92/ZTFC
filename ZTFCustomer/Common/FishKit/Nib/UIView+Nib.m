//
//  UIView+Nib.m
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "UIView+Nib.h"
#import "UIView+FKAutoLayout.h"

@implementation UIView (Nib)

+ (UINib *)nib
{
    return [self nibWithName:NSStringFromClass([self class])];
}

+ (UINib *)nibWithName:(NSString *)name
{
    return [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadFromNib
{
    return [self loadFromNib:NSStringFromClass([self class])];
}

+ (instancetype)loadFromNib:(NSString *)nibName
{
    return [[[self nibWithName:nibName] instantiateWithOwner:nil options:nil] firstObject];
}

- (void)loadFromNib
{
    UIView * shadow = [[[[self class] nib] instantiateWithOwner:self options:nil] firstObject];
    
    [self addSubview:shadow];
    
    [shadow autoFillSuperView];
}

- (void)customize
{
    
}

@end
