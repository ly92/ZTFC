//
//  AppDelegate+Share.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate+Share.h"

@implementation AppDelegate (Share)
-(void)addShareSDKWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self shareInit];
}
-(void)shareInit{
    
    //向微信注册分享
    [WXApi registerApp:WECHAT_SHARE_KEY];
    
    // 设置分享菜单－社交平台文本字体
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    //设置编辑界面标题颜色
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    
    
    [ShareSDK registerApp:SHARE_SDK_KEY
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:SINA_SHARE
                                           appSecret:SINA_SHARE_SECRET
                                         redirectUri:@"http://www.kakatool.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 //微信
                 [appInfo SSDKSetupWeChatByAppId:WECHAT_SHARE_KEY
                                       appSecret:WECHAT_SECRET_KEY];
                 break;
             case SSDKPlatformTypeQQ:
                 //QQ
                 [appInfo SSDKSetupQQByAppId:QQ_SHARE_KEY
                                      appKey:QQ_SHARE_SECRET
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

@end
