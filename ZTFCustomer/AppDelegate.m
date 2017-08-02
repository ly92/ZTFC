//
//  AppDelegate.m
//  ztfCustomer
//
//  Created by wangshanshan on 16/6/28.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarItem.h"
#import "SBNavigationController.h"

#import "AJNotificationView.h"//通知
//#import "RealReachability.h" //网站状态
#import "NEHTTPEye.h" //网络调试
#import "EMSDK.h" //环信聊天
#import "HuanxinService.h" //聊天处理

#import "HomeViewController.h"
#import "HousesViewController.h"
#import "MessageViewController.h"
#import "SurroundingViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
#import "HandlePush.h"

#import "OpenCouponView.h"
#import "OpenMoneyView.h"
#import "VoucherDetailViewController.h"
#import "NoticeViewController.h"
#import "BaiduLocation.h"
#import "UserGuideViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Reachability.h"

#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+Share.h"
#import "AppDelegate+rootViewController.h"


@interface AppDelegate ()<UIAlertViewDelegate,RDVTabBarControllerDelegate,WXApiDelegate,JPUSHRegisterDelegate>
@property(nonatomic,retain) OpenCouponView *openCouponView;
@property(nonatomic,retain) OpenMoneyView *openMoneyView;

//推送消息c19
@property (nonatomic, retain) NSDictionary *userInfoC19;
//推送消息c20
@property (nonatomic, retain) NSDictionary *userInfoC20;

@end

@implementation AppDelegate

+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark-生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置状态栏字体颜色
    if (GT_IOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //极光统计
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = @"b91c0c9cec4399493b77bbb1";
    [JANALYTICSService setupWithConfig:config];
    [JANALYTICSService setDebug:YES];
    [JANALYTICSService crashLogON];
    
    //极光推送注册
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
      // c00e467843b63c9bd54b355c
    
    [JPUSHService setupWithOption:launchOptions appKey:@"b91c0c9cec4399493b77bbb1" channel:@"AppStore" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
    }];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 注册推送通知
    if (GT_IOS8) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
        // 推送信息
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }

    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushDict)
    {
            [self opratePushMSG: pushDict];
    }
    //默认样式
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    //设置默认弹出时间为1秒
//    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    [self setupRootViewController];
    [self setRootViewControllerWithWindow:self.window application:application didFinishLaunchingWithOptions:launchOptions];
    
    //启动app的时候，登出状态为NO
    [STICache.global setObject:@"NO" forKey:@"LOGOUT"];
    
    //百度地图注册
    [[BaiduLocation sharedLocation] setupWithKey:AMAP_KEY delegate:self];
   
    //微信注册支付
    [WXApi registerApp:WECHAT_PAY_KEY];
    //网络调试
//    [self httpDebug];
    
    //环信注册
    [self configHuanxinApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //sharesdk分享注册
    [self addShareSDKWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    if (!IS_APPSTORE){
        //检查更新
        [self checkUpgrade];
    }
    //监测网络状态
    [self moniterNetwork];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
     [UIApplication sharedApplication].applicationIconBadgeNumber=[[LocalizePush shareLocalizePush] getUnReadBadgleCount];
    
//        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkUpgrade];
    [self checkDevice];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
//    [UIAlertView bk_showAlertViewWithTitle:@"慧生活" message:@"警告：内存不足" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        
//    }];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
    
}

-(void)setupRootViewController{
    [self setRootViewControllerWithWindow:self.window application:nil didFinishLaunchingWithOptions:nil];
}
-(void)showLogin{
    [self showLoginCategory];
}

#pragma mark - 环信聊天


//注册环信（包括推送）
-(void)configHuanxinApplication:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    
    NSString *apnsCertName = nil;
    NSString *appKey = nil;
    //#ifdef DEBUG
//    apnsCertName = @"chatdemoui_dev";
    appKey =@"www-kakatool-com#ztfcustomer";
    //#else
    //    apnsCertName = @"chatdemoui";
    //    appKey =@"www-kakatool-com#ztfcustomer";
    //#endif
    
    [[HuanxinService shareInstance] configHuanxinApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appKey apnsCertName:apnsCertName];
    
}

#pragma mark-openurl

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        
//        return [ShareSDK handleOpenURL:url wxDelegate:self];
        return NO;

    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
        return YES;
    }
    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
//        return [ShareSDK SSDk]
//        return [ShareSDK handleOpenURL:url
//                     sourceApplication:sourceApplication
//                            annotation:annotation
//                            wxDelegate:self];
    }
    
    return YES;
    
}

//iOS 9以上的回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
        return YES;
    }
    
    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
//        return [ShareSDK handleOpenURL:url sourceApplication:@"" annotation:@"" wxDelegate:self];
    }
    
    return YES;
}

/**
 微信回调
 */
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        
        switch (resp.errCode) {
            case WXSuccess:
                //支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_BACK" object:nil];
                break;
            default:
                [self.window.rootViewController presentFailureTips:@"支付失败"];
                //                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                
                break;
        }
    }
}

/**
 支付宝支付时程序在后台被kill时在此处理支付结果
 @param resultDic 支付结果
 */
- (void)aliPayResult:(NSDictionary *)resultDic{
    if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
        //支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALI_PAY_BACK" object:nil];
    }else{
        [self.window.rootViewController presentFailureTips:@"支付失败"];
    }
}

#pragma mark - 推送

//注册设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token= [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
    [LocalData updateDeviceToken:token];
    
    [self registerDevice];
    
    //jpush注册
    [JPUSHService registerDeviceToken:deviceToken];
    
    //环信绑定
    [[HuanxinService shareInstance] binDeviceToken:deviceToken];
    
}

//注册设备失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code == 3010) {
        //NSLog(@"Push notifications are not supported in the iOS Simulator.");
        
#ifdef DEBUG
        [LocalData updateDeviceToken:@"iOSSIMULATOR"];
        
        [self registerDevice];
#endif
//         [JPUSHService registerDeviceToken:@"iOSSIMULATOR"];
        
    }else{
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
    }
}

//远程推送
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    
//    //    NSString *paramStr = [userInfo objectForKey:@"m"];
//    //    if (paramStr) {
//    //        NSArray *param = [paramStr componentsSeparatedByString:@"|"];
//    //        if (param&&param.count>0) {
//    //
//    //            NSString *cmd = [param objectAtIndex:0];
//    //
//    //            //如果是c19和c20则保存推送信息，等通知
//    //            if (cmd) {
//    //                if ([cmd isEqualToString:@"c19"]){
//    //
//    //                    self.userInfoC19 = userInfo;
//    //
//    //                }else if([cmd isEqualToString:@"c20"]){
//    //                    self.userInfoC20 = userInfo;
//    //                }else {
//    [self opratePushMSG: userInfo];
//    //                }
//    //
//    //            }
//    //        }
//    //    }
//    
//    NSLog(@"didReceiveRemoteNotification");
//}

//本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
}


-(void)opratePushMSG:(NSDictionary *)dic
{
    [HandlePush handelPushMessage:dic];
}

//注册设备
-(void)registerDevice{
    if ([[LocalData shareInstance] isLogin]) {
        
        [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
        UserModel *user=[LocalData shareInstance].getUserAccount;
        
        NSString *token = [LocalData getDeviceToken];
        
        if (user&&token&&token.length>5) {
            NSString *cid = user.cid;
            
            RegisterDeviceAPI *registerDeviceApi = [[RegisterDeviceAPI alloc]initWithMemberIDType:@"cid" objid:cid pushtoken:token];
            
            [registerDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                
            } failure:^(__kindof YTKBaseRequest *request) {
                
            }];
            
        }
    }
    
}


//检查设备唯一性
-(void)checkDevice{
    
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user=[LocalData shareInstance].getUserAccount;
        
        NSString *token = [LocalData getDeviceToken];
        
        if (user&&token&&token.length>5) {
            NSString *cid = user.cid;
            
            [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
            CheckDeviceAPI *checkDeviceApi = [[CheckDeviceAPI alloc]initWithMemberIDType:@"cid" objid:cid pushtoken:token];
            
            
            [checkDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    
                    int code = [[result objectForKey:@"r"] intValue];
                    //账号在另外一台手机上面登陆
                    if (code==1) {
                        
                        SBNavigationController * login = [[SBNavigationController alloc] initWithRootViewController:[LoginViewController spawn]];
                        self.window.rootViewController = login;
                        
                        [[LocalData shareInstance] removeUserAccount];
                        [LocalData updateAccessToken:nil];
                        [LocalData updateDeviceToken:nil];
                        
                        [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.8];
                        
                        
                    }
                    else
                    {
                        //检测其用户信息是否被更改过
                        [self checkUserInfo];
                    }
                    
                    
                    
                }else{
                    
                    if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                        [[AppDelegate sharedAppDelegate]showLogin];
                    }
                    
                    [self.window.rootViewController presentFailureTips:result[@"reason"]];
                }
                
                
            } failure:^(__kindof YTKBaseRequest *request) {
                if (request.responseStatusCode == 0) {
                    [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
                }else{
                [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                }
            }];
            
        }
    }
    
    
    
}

-(void)showMessage{
    [self.window.rootViewController presentFailureTips:@"你的账号在另一台机器上登录，请重新登录"];
}

-(void)checkUserInfo
{
    if ([[LocalData shareInstance]isLogin] == NO) {
        return;
    }
    
    NSMutableDictionary *userInfo = [LocalData fetchNormalUserInfo];
    if (userInfo) {
        NSString *psw = [userInfo objectForKey:@"password"];
        NSString *name = [userInfo objectForKey:@"account"];
        
        //获取当前位置
        Location *location = [AppLocation sharedInstance].location;
        NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
        NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
        
        //登录
        [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
        LoginAPI *loginApi = [[LoginAPI alloc]initWithNormalWithMobile:name password:psw lat:lat lng:lon];
        [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                
                UserModel *user = [UserModel mj_objectWithKeyValues:content[@"userinfo"]];
                
                if (user) {
                    
                    //更新user到本地
                    [[LocalData shareInstance] updateUserAccount:user];
                    //更新access_token到本地
                    [LocalData updateAccessToken:user.access_token];
                    //更新用户名、密码
                    [LocalData updateNormalUserInfo:name Psw:psw];
                    
                    //从后台进入前台，刷新首页数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTERFOREGROUND" object:nil];
                    
                }
                
            }else{
                [self.window.rootViewController presentFailureTips:result[@"message"]];
                
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            if (request.responseStatusCode == 0) {
                [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
            [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
            
        }];
        
    }
}
#pragma mark - 弹出开门送优惠券
-(void)popOpenDoorCoupon:(NSString *)msg SnID:(NSString *)snid Cmd:(NSString *)cmd
{
    if ([cmd isEqualToString:@"c19"]){
        if (!_openCouponView) {
            _openCouponView = [[OpenCouponView alloc] initWithParentController:self.tabController];
            
        }
        _openCouponView.snid = snid;
        //测试
        //                [_openCouponView show:@"恭喜您获得开门奖励，来自【魔幻软件】的\"优惠券名\" 99993张。"];
        //测试
        
        [_openCouponView show:msg];
        
    }else if ([cmd isEqualToString:@"c20"]){
        if (!_openMoneyView) {
            
            _openMoneyView = [[OpenMoneyView alloc] initWithParentController:self.tabController];
            
        }
        _openMoneyView.snid = snid;
        //                        [_openMoneyView show:@"恭喜您参加\"扫码送大米\"活动获得【千丝发艺】开门奖励3.94元。"];
        [_openMoneyView show:msg];
        
    }
    
}

//接收到通知再显示保存的推送（money 和 coupon ）
- (void)showMoneyOrCoupon{
    
    if (self.userInfoC20){
        [self opratePushMSG:self.userInfoC20];
    }
    
    if (self.userInfoC19){
        [self opratePushMSG:self.userInfoC19];
    }
}



#pragma mark-通知
-(void)registerNoti{
    //小区公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommunityNotice:) name:@"Community_Notice" object:nil];
    
    //小区公告点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelCommunityNoticeClicked:) name:@"Community_Notice_Clicked" object:nil];
    
    //开门送红包点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelOpenCouponClicked:) name:@"Open_Coupon_Clicked" object:nil];
    
    //开门奖励的view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMoneyOrCoupon) name:@"showMoneyView" object:nil];
    
}
//小区公告处理
-(void)handleCommunityNotice:(NSNotification *)noti
{
    
    NSDictionary *dic=(NSDictionary *)noti.userInfo;
    NSString *msg=dic[@"msg"];
    NSString *bid=dic[@"bid"];
    
    if (msg) {
        NSString *moreMsg = [NSString stringWithFormat:@"%@[点击查看]",msg];
        
        [self showNoticeMsg:moreMsg WithInterval:3.0 Block:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Community_Notice_Clicked" object:bid];
        }];
        
    }
}

//公告信息点击处理
-(void)handelCommunityNoticeClicked:(NSNotification *)noti
{
    
    NSString *communityid = (NSString *)noti.object;
    
    BOOL shouldChange=NO;
    if (communityid) {
         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        Community *selectedCommunity = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        if (selectedCommunity) {
            
            if ([communityid isEqualToString:selectedCommunity.bid]==NO) {
                shouldChange=YES;
            }
        }
        else{
            shouldChange=YES;
        }
        
        if (shouldChange) {
            
            
            [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
            SearchCommunityAPI *searchCommunityApi = [[SearchCommunityAPI alloc]initWithKeyword:communityid];
            [searchCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    [self.window.rootViewController dismissTips];
                    id remoteCommunity = [result objectForKey:@"community"];
                    if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *firstCommunity = (NSDictionary *)remoteCommunity;
                        
                        Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                        [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
//                        [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOADSELEDTCUMMUNITY" object:nil];
                        
                    }
                    else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                        
                        NSArray *remotCommunity = (NSArray *)remoteCommunity;
                        
                        if ([remotCommunity count]>0) {
                            NSDictionary *firstCommunity = [remotCommunity objectAtIndex:0];
                            Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                             UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
                            
//                            [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOADSELEDTCUMMUNITY" object:nil];
                            
                        }
                    }
                    if (self.tabController) {
                        
                        if (self.tabController.selectedViewController) {
                            
                            //隐藏导航栏
                            if (!self.tabController.tabBarHidden) {
                                
                                [self.tabController setTabBarHidden:YES];
                                
                            }
                            
                            if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                                
                                SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                                
                                NoticeViewController *noticeController =[NoticeViewController spawn];
                                
                                [navController pushViewController:noticeController animated:YES];
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }else{
                    [self.window.rootViewController presentFailureTips:result[@"reason"]];
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                if (request.responseStatusCode == 0) {
                    [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
                }else{
                [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                }
            }];
            
        }
        else{
            
            if (self.tabController) {
                
                if (self.tabController.selectedViewController) {
                    
                    //隐藏导航栏
                    if (!self.tabController.tabBarHidden) {
                        
                        [self.tabController setTabBarHidden:YES];
                        
                    }
                    
                    if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                        
                        SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                        
                        NoticeViewController *noticeController =[NoticeViewController spawn];
                        
                        [navController pushViewController:noticeController animated:YES];
                        
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
}
//开门送优惠券处理
-(void)handelOpenCouponClicked:(NSNotification *)noti
{
    NSString *snid = (NSString *)noti.object;
    
    [self.window.rootViewController presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    
    CouponOverdueAPI *couponOverdueApi = [[CouponOverdueAPI alloc]initWithSnid:snid];
    
    [couponOverdueApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self.window.rootViewController dismissTips];
            NSDictionary *info = [result objectForKey:@"info"];
            if ([ISNull isNilOfSender:info]) {
                [self.window.rootViewController presentFailureTips:@"优惠券无效"];
                return ;
            }
            CouponModel *couponModel = [CouponModel mj_objectWithKeyValues:info];
            
            if (self.tabController) {
                
                if (self.tabController.selectedViewController) {
                    
                    //隐藏导航栏
                    if (!self.tabController.tabBarHidden) {
                        [self.tabController setTabBarHidden:YES];
                    }
                    if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                        
                        SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                        
                        
                        VoucherDetailViewController *voucherDetail = [[VoucherDetailViewController alloc]initWithVOUCHER:couponModel];
                        voucherDetail.reloadTable = ^(){
                            
                        };
                        
                        [navController pushViewController:voucherDetail animated:YES];
                    }
                }
            }
            
            
        }else{
            [self.window.rootViewController presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}
#pragma mark - 网络监测
-(void)moniterNetwork
{
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
//    GLobalRealReachability.hostForPing = @"www.baidu.com";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkChanged:)
//                                                 name:kRealReachabilityChangedNotification
//                                               object:nil];
    [reach startNotifier];
    
}

-(void)networkChanged:(NSNotification *)notification
{
    Reachability *reachability = (Reachability *)notification.object;
    NetworkStatus status = [reachability currentReachabilityStatus];
//    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
//    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
//    NotReachable = 0,
//    ReachableViaWiFi = 2,
//    ReachableViaWWAN = 1
    
    if (status == NotReachable)
    {
        NSLog(@"Network unreachable!");
         [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络连接"];
    }
    
    if (status == ReachableViaWiFi)
    {
        NSLog( @"Network wifi! Free!");
    }
    
    if (status == ReachableViaWWAN)
    {
        NSLog( @"Network WWAN! In charge!");
    }
    
//    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
//    
//    if (status == RealStatusViaWWAN)
//    {
//        if (accessType == WWANType2G)
//        {
//            NSLog(@"RealReachabilityStatus2G");
//        }
//        else if (accessType == WWANType3G)
//        {
//            NSLog( @"RealReachabilityStatus3G");
//        }
//        else if (accessType == WWANType4G)
//        {
//            NSLog( @"RealReachabilityStatus4G");
//        }
//        else
//        {
//            NSLog( @"Unknown RealReachability WWAN Status, might be iOS6");
//        }
//    }
    
}
#pragma mark - 网络调试
-(void)httpDebug
{
#ifdef DEBUG
    [NEHTTPEye setEnabled:YES];
#endif
    
    
}


#pragma mark - 全局提示信息

-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:timer
                                response:^{
                                    // NSLog(@"Response block");
                                }];
}

-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:timer offset:0.0f delay:0.0f detailDisclosure:NO
                                response:response];
}


#pragma mark- 未读消息

//设置tabbar下标
-(void)setBadgeValue:(int)bageValue foeIndex:(NSInteger)index{
    if ([[self.tabController viewControllers] count]>3) {
        
        UIViewController *badgeController =[[self.tabController viewControllers] objectAtIndex:index];
        if (badgeController) {
            if (bageValue>0) {
                [badgeController rdv_tabBarItem].badgeValue =[NSString stringWithFormat:@"%i",(int)bageValue];
            }
            else{
                [badgeController rdv_tabBarItem].badgeValue =@"";
            }
            
        }
    }
}

#pragma mark-检查更新

-(void)checkUpgrade
{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    UpgradeAPI *upgradeApi = [[UpgradeAPI alloc]init];
    [upgradeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSDictionary *content = dic[@"content"];
        if (![ISNull isNilOfSender:content] && [[dic objectForKey:@"code"] intValue] == 0){
            NSString *url = content[@"ios"];
            //            NSString *url = [dic objectForKey:@"url"];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            NSArray *arr = [version componentsSeparatedByString:@"."];
            NSString *newVersion = [arr componentsJoinedByString:@""];
            CGFloat localVersion = [newVersion floatValue];
            
            CGFloat netVersion = [[content objectForKey:@"version"] floatValue];
            
            
            if (netVersion > localVersion){
                if ([ISNull isNilOfSender:url]){
                    //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://beta.bugly.qq.com/5wcc"]];
                }else{
                    
                    [UIAlertView bk_showAlertViewWithTitle:@"是否升级" message:content[@"version_memo"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                    }];
                    
                }
            }
        }else{
            [self.window.rootViewController presentFailureTips:dic[@"message"]];
        }

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseStatusCode == 0) {
            [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];

}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


@end
