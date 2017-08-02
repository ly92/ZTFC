//
//  ResetPayPwdAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ResetPayPwdAPI.h"


@interface ResetPayPwdAPI ()
{
    NSString *_password;
    NSString *_code;
}
@end
@implementation ResetPayPwdAPI

-(instancetype)initWithPassword:(NSString *)password code:(NSString *)code{
    if (self == [super init]) {
        _password = password;
        _code = code;
    }
    return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    switch (self.passwordType) {
        case PASSWORD_TYPE_RESET:
            return MYDROP_SETPASSWORD;
            break;
        case PASSWORD_TYPE_SET:
            return MYDROP_SETPASSWORD;
            break;

            
        default:
            break;
    }
}
-(id)requestArgument{
    return @{@"password":_password,
             @"code" : _code};
}
@end
