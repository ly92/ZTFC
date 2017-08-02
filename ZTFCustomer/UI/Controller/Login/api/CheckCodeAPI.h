//
//  CheckCodeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSInteger,CHECKCODETYPE) {
    CHECKCODE_REGISTERTYPE, //注册
    CHECKCODE_CHECKID  //验证身份
};

@interface CheckCodeAPI : YTKRequest

@property (nonatomic, assign) CHECKCODETYPE checkCodeType;
-(instancetype)initWithCheckCode:(NSString *)checkcode mobile:(NSString *)mobile;

@end
