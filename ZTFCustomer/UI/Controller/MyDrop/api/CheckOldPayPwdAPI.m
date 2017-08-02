//
//  CheckOldPayPwdAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CheckOldPayPwdAPI.h"

@interface CheckOldPayPwdAPI ()
{
    NSString *_oldPayPwd;
}
@end
@implementation CheckOldPayPwdAPI
-(instancetype)initWithOldPayPwd:(NSString *)oldPayPwd{
    if (self == [super init]) {
        _oldPayPwd = oldPayPwd;
    }
    return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    return @"drop/checkOldPayPwd";
}
-(id)requestArgument{
    return @{@"oldPayPwd":_oldPayPwd};
}
@end
