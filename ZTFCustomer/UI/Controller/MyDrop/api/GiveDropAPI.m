//
//  GiveDropAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GiveDropAPI.h"

@interface GiveDropAPI ()
{
    NSString *_tel;
    NSString *_money;
    NSString *_password;
}
@end

@implementation GiveDropAPI


-(instancetype)initWithTel:(NSString *)tel money:(NSString *)money password:(NSString *)password{
    if (self = [super init]) {
        _tel = tel;
        _money = money;
        _password = password;
    }
    return self;
}

-(NSString *)requestUrl{
    return MYDROP_GOVEMONEY;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"tel":_tel,
             @"money":_money,
             @"password":_password
             };
}

@end
