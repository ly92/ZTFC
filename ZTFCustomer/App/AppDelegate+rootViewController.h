//
//  AppDelegate+rootViewController.h
//  ZTFCustomer
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (rootViewController)<RDVTabBarControllerDelegate>

-(void)setRootViewControllerWithWindow:(UIWindow *)window application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//根据用户登录状况设置界面
-(void)setupRootViewControllers;

-(void)showLoginCategory;

@end
