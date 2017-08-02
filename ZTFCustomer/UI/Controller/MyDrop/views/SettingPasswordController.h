//
//  SettingPasswordController.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPasswordController : UIViewController
@property (nonatomic, assign) SETTING_PASSWORD_TYPE settingType;    // 设置密码的类型（旧的，新的，二次确认）
@property (nonatomic, assign) PASSWORD_TYPE passwordType;   // 密码的类型（修改、忘记）
@property (nonatomic, strong) NSString * resetPassword;     // 二次确认密码的时候，上一次输入的密码。检验两次密码是否一致
@property (nonatomic, strong) UIViewController * popViewController; // pop到哪个界面

@property (nonatomic, copy) NSString *messageCode;//第一次设置密码的时候和忘记密码的时候需要验证码作为参数

@end
