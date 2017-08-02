//
//  GetCodeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
typedef NS_ENUM(NSInteger,GETCODETYPE) {
    REGISTERTYPE, //注册
    FINDPSWTYPE,  //找回密码
    CHECKID  //验证身份
   
};


@interface GetCodeAPI : YTKRequest

@property (nonatomic, assign) GETCODETYPE codeType;;


-(instancetype)initWithMoblie:(NSString *)mobile;

@end
