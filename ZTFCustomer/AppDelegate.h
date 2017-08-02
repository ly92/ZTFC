//
//  AppDelegate.h
//  ztfCustomer
//
//  Created by wangshanshan on 16/6/28.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate*) sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic) RDVTabBarController *tabController;

-(void)registerDevice;


-(void)setBadgeValue:(int)bageValue foeIndex:(NSInteger)index;


//推送信息提示
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer;
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response;

//弹出开门送优惠券
-(void)popOpenDoorCoupon:(NSString *)msg SnID:(NSString *)snid Cmd:(NSString *)cmd;

//根据用户登录状况设置界面
-(void)setupRootViewController;

-(void)showLogin;

@end

