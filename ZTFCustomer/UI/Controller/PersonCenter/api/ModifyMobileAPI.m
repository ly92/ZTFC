//
//  ModifyMobileAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyMobileAPI.h"

@interface ModifyMobileAPI ()
{
    NSString *_newMobile;
    NSString *_verifyCode;
}
@end

@implementation ModifyMobileAPI

-(instancetype)initWithNewMobile:(NSString *)newMobile verifyCode:(NSString *)verifyCode{
    if (self == [super init]) {
        _newMobile = newMobile;
        _verifyCode = verifyCode;
    }
    return self;
}


-(NSString *)requestUrl{
    return UWETOWN_USER_UPDATEMOBILE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"NewMobile":_newMobile,
             @"Smscheckcode":_verifyCode};
}

@end
