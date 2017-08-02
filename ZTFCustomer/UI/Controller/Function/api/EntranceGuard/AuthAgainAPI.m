//
//  AuthAgainAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AuthAgainAPI.h"

@interface AuthAgainAPI ()
{
    NSString *_autype;
    NSString *_toid;
    NSString *_bid;
    NSString *_usertype;
    NSString *_granttype;
    NSString *_starttime;
    NSString *_stoptime;
    NSString *_memo;
}
@end

@implementation AuthAgainAPI
-(instancetype)initWithAutype:(NSString *)autype toid:(NSString *)toid bid:(NSString *)bid usertype:(NSString *)usertype granttype:(NSString *)granttype starttime:(NSString *)starttime stoptime:(NSString *)stoptime memo:(NSString *)memo{
    if (self == [super init]) {
        _autype = autype;
        _toid = toid;
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
    return ENTRANCE_AUTH_AGAIN;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    if (![[_usertype trim] isEqualToString:@"1"]) {
        return @{@"autype":_autype,
                 @"toid":_toid,
                 @"bid":_bid,
                 @"usertype":_usertype,
                 @"granttype":_granttype,
                 @"starttime":_starttime,
                 @"stoptime":_stoptime,
                 @"memo":_memo};
    }else{
        return @{@"autype":_autype,
                 @"toid":_toid,
                 @"bid":_bid,
                 @"usertype":_usertype,
                 @"granttype":_granttype,
                 @"memo":_memo};
    }
}

@end
