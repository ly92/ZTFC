//
//  ModifyMobileAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ModifyMobileAPI : YTKRequest

//修改手机号
-(instancetype)initWithNewMobile:(NSString *)newMobile verifyCode:(NSString *)verifyCode;

@end
