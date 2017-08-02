//
//  WebViewController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController


@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (assign,nonatomic) BOOL isShop;//判断当前浏览页面是否为商户列表

//+ (void)openURL:(NSString *)url in:(UIViewController *)vc title:(NSString *)title;

+(NSString *)pingUrlWithUrl:(NSString *)url pushCmd:(NSString *)pushCmd;

@end
