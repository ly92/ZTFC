//
//  ResetPayPwdAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//设置支付密码
@interface ResetPayPwdAPI : YTKRequest

@property (nonatomic, assign) PASSWORD_TYPE passwordType;
-(instancetype)initWithPassword:(NSString *)password code:(NSString *)code;

@end
