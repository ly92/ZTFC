//
//  UIViewController+TransparentUINavigationbar.m
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "UIViewController+TransparentUINavigationbar.h"

@implementation UIViewController (TransparentUINavigationbar)

- (void)setNavigationBarTransparent:(BOOL)transparent
{
    if ( transparent )
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.view.backgroundColor = self.navigationController.navigationBar.tintColor;
    }
}

+ (void)setNavigationBarTransparent:(BOOL)transparent
{
    if ( transparent )
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                           forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].shadowImage = [UIImage new];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:nil
                                           forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].shadowImage = nil;
    }
}

@end
