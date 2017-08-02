//
//  LoginAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSUInteger, SMS_TYPE) {
    SMS_TYPE_REGISTER = 0, // 注册
    SMS_TYPE_FORGET_PASSWORD = 1, // 找回密码
    SMS_TYPE_SETPAY = 2, // 设置支付密码
    SMS_TYPE_RESETPAY = 3, // 重置支付密码
    SMS_TYPE_BINDING = 4, // 绑定手机号
    
};

@interface LoginAPI : YTKRequest
//普通登录
-(instancetype)initWithNormalWithMobile:(NSString *)mobile password:(NSString *)pwd lat:(NSString *)lat lng:(NSString *)lng;
@end
