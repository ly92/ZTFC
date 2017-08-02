//
//  AuthAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AuthAPI.h"

@interface AuthAPI ()
{
    NSString *_autype;
    NSString *_mobile;
    NSString *_bid;
    NSString *_usertype;
    NSString *_granttype;
    NSString *_starttime;
    NSString *_stoptime;
    NSString *_memo;
}
@end

@implementation AuthAPI

-(instancetype)initWithAutype:(NSString *)autype mobile:(NSString *)mobile bid:(NSString *)bid usertype:(NSString *)usertype granttype:(NSString *)granttype starttime:(NSString *)starttime stoptime:(NSString *)stoptime memo:(NSString *)memo{
    if (self == [super init]) {
        _autype = autype;
        _mobile = mobile;
        _bid = bid;
        _usertype = usertype;
        _granttype = granttype;
        _starttime = starttime;
        _stoptime = stoptime;
        _memo = memo;
    }
    return self;
}

-(NSString *)requestUrl{
    return ENTRANCE_AUTH;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    if (![[_usertype trim] isEqualToString:@"1"]) {
        return @{@"autype":_autype,
                 @"mobile":_mobile,
                 @"bid":_bid,
                 @"usertype":_usertype,
                 @"granttype":_granttype,
                 @"starttime":_starttime,
                 @"stoptime":_stoptime,
                 @"memo":_memo};
    }else{
        return @{@"autype":_autype,
                 @"mobile":_mobile,
                 @"bid":_bid,
                 @"usertype":_usertype,
                 @"granttype":_granttype,
                 @"memo":_memo};
    }
}

@end
