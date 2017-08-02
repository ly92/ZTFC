//
//  FindPswAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FindPswAPI.h"

@interface FindPswAPI ()
{
    NSString *_mobile;
    NSString *_checkCode;
    NSString *_newPassword;
}
@end

@implementation FindPswAPI

-(instancetype)initWithMobile:(NSString *)mobile checkCode:(NSString *)checkCode newPassword:(NSString *)newPassword{
    if (self == [super init]) {
        _mobile = mobile;
        _checkCode = checkCode;
        _newPassword = newPassword;
    }
    return self;
}

-(NSString *)requestUrl{
    return FINDPWD_RESETPWD;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"Mobile":_mobile,
             @"CheckCode":_checkCode,
             @"NewPassword":_newPassword};
}

@end
