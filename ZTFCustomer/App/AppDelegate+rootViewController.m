//
//  AppDelegate+rootViewController.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate+rootViewController.h"
#import "LoginViewController.h"
#import "UserGuideViewController.h"
#import "HomeViewController.h"
#import "HousesViewController.h"
#import "MessageViewController.h"
#import "SurroundingViewController.h"
#import "PersonalCenterViewController.h"
#import "RDVTabBarItem.h"
#import "SBNavigationController.h"



@implementation AppDelegate (rootViewController)
-(void)setRootViewControllerWithWindow:(UIWindow *)window application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
     [self setupRootViewControllers];
}

#pragma mark-设置主界面
#pragma mark - 界面
-(void)setupRootViewControllers{
    
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"FirstInstall"];
    
    if( [ISNull isNilOfSender:str] )
    {
        //第一次启动
        [[NSUserDefaults standardUserDefaults] setObject:@"firstInstall" forKey:@"FirstInstall"];
        
        // 如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        UserGuideViewController * userGuideViewController = [[UserGuideViewController alloc]init];
        self.window.rootViewController = userGuideViewController;
        
    }else{
        
        if(self.tabController){
            //所有nav显示首页
            for (UIViewController *controller in [self.tabController viewControllers]) {
                if ([controller isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController *)controller;
                    if ([nav viewControllers].count>1) {
                        [nav popToRootViewControllerAnimated:NO];
                    }
                }
            }
            //切换到首页
            [self.tabController setSelectedIndex:0];
        }
        
        UserModel *user = [LocalData shareInstance].getUserAccount;
        if (user) {
            [self setupViewControllers];
        }else{
            [self showLoginCategory];
        }
    }
}

//登陆界面
-(void)showLoginCategory{
    
    UINavigationController * login = [[UINavigationController alloc] initWithRootViewController:[LoginViewController spawn]];
    self.window.rootViewController = login;
    
    //消除气泡
    [[LocalizePush shareLocalizePush] removePushDic];
    [[LocalData shareInstance]removeUserAccount];
    [[HuanxinService shareInstance]logout];
    [LocalData updateAccessToken:nil];
    
}

- (void)setupViewControllers {
    
    HomeViewController *firstViewController = [HomeViewController spawn];
    SBNavigationController *firstNavigationController = [[SBNavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    
    HousesViewController *secondViewController = [HousesViewController spawn];
    SBNavigationController *secondNavigationController = [[SBNavigationController alloc]
                                                          initWithRootViewController:secondViewController];
    
    SurroundingViewController *fourthViewController = [SurroundingViewController spawn];
    SBNavigationController *fourthNavigationController = [[SBNavigationController alloc]
                                                          initWithRootViewController:fourthViewController];
    
    PersonalCenterViewController *fifthViewController = [PersonalCenterViewController spawn];
    SBNavigationController *fifthNavigationController = [[SBNavigationController alloc]
                                                         initWithRootViewController:fifthViewController];
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           fourthNavigationController,fifthNavigationController ]];
    
    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_tab_bg"]];
    tabBarController.delegate = self;
    
    self.tabController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
    
    [self.window setRootViewController:self.tabController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSArray *tabBarItemTitles = @[@"首页", @"楼盘",@"周边",@"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        //标题
        [item setSelectedTitleAttributes: @{
                                            NSFontAttributeName: [UIFont systemFontOfSize:11],
                                            NSForegroundColorAttributeName: TAB_SELECTTEXT_COLOR,
                                            }];
        
        [item setUnselectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:11],
                                              NSForegroundColorAttributeName: TAB_TEXT_COLOR,
                                              }];
        
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        
        //icon
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_icon_%ld_pre",
                                                      index+1]];
        
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_icon_%ld",
                                                        index+1]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        
        index++;
    }
}

@end
