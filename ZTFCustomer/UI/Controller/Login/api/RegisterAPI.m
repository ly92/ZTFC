//
//  RegisterAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "RegisterAPI.h"

@interface RegisterAPI ()
{
    NSString *_realname;
    NSString *_mobile;
    NSString *_gender;
    NSString *_password;
    NSString *_birthday;
}
@end

@implementation RegisterAPI

-(instancetype)initWithRealname:(NSString *)realname mobile:(NSString *)mobile gender:(NSString *)gender psw:(NSString *)psw birthday:(NSString *)birthday{
    if (self == [super init]) {
        _realname = realname;
        _mobile = mobile;
        _gender = gender;
        _password = psw;
        _birthday = birthday;
    }
    return self;
}

-(NSString *)requestUrl{
    return REGISTER_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"realname":_realname,
             @"Mobile":_mobile,
             @"gender":_gender,
             @"Psw":_password,
             @"birthday":_birthday
             };
}

@end
