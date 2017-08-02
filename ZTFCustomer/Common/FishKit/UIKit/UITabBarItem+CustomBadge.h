//
//  UITabBarItem+CustomBadge.h
//
//  Created by QFish on 6/29/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1. Set custom badge view first
 ```
	UIView * badge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
	badge.clipsToBounds = YES;
	badge.layer.cornerRadius = 3;
	badge.backgroundColor = [AppTheme mainColor];
	self.tabBarItem.customBadge = badge;
 ```
 2. Set custom badge value
 ```
	self.tabBarItem.customBadgeValue = @"" or nil;
 ```
 */

@interface UITabBarItem (CustomBadge)

@property (nonatomic, strong) UIView * customBadge;
@property (nonatomic, strong) NSString * customBadgeValue;

@end
