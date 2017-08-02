//
//  UIView+FKAutoLayout.m
//  gaibianjia
//
//  Created by QFish on 9/16/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "UIView+FKAutoLayout.h"

@implementation UIView (FKAutoLayout)

- (NSArray *)autoFillSuperView
{
    return [self autoFillSuperViewWithInsets:UIEdgeInsetsZero];
}

- (NSArray *)autoFillSuperViewWithInsets:(UIEdgeInsets)insets
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * c1 = FKAutoLayoutMake(self, Leading, Equal, self.superview, Leading, insets.left);
    NSLayoutConstraint * c2 = FKAutoLayoutMake(self, Trailing, Equal, self.superview, Trailing, insets.right);
    NSLayoutConstraint * c3 = FKAutoLayoutMake(self, Top, Equal, self.superview, Top, insets.top);
    NSLayoutConstraint * c4 = FKAutoLayoutMake(self, Bottom, Equal, self.superview, Bottom, insets.bottom);
    
    NSArray * array = @[c1, c2, c3, c4];
    
    [self.superview addConstraints:array];
    
    return array;
}

@end
