//
//  ApplyApproveAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyApproveAPI.h"

@interface ApplyApproveAPI ()
{
    NSString *_applyid;
    NSString *_approve;
    NSString *_autype;
    NSString *_usertype;
    NSString *_granttype;
    NSString *_bid;
    NSString *_starttime;
    NSString *_stoptime;
    NSString *_memo;
}
@end


@implementation ApplyApproveAPI
-(instancetype)initWithApplyid:(NSString *)applyid approve:(NSString *)approve autype:(NSString *)autype usertype:(NSString *)usertype granttype:(NSString *)granttype bid:(NSString *)bid starttime:(NSString *)starttime stoptime:(NSString *)stoptime memo:(NSString *)memo{
    if (self == [super init]) {
        _applyid = applyid;
        _approve = approve;
        _autype = autype;
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
    return ENTRANCE_APPLY_APPROVE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    if (![[_usertype trim] isEqualToString:@"1"]) {
        return @{@"applyid":_applyid,
                 @"approve":_approve,
                 @"autype":_autype,
                 @"granttype":_granttype,
                 @"starttime":_starttime,
                 @"stoptime":_stoptime,
                 @"memo":_memo,
                 @"bid":_bid,
                 @"usertype":_usertype
                 };
    }else{
        return  @{@"applyid":_applyid,
                  @"approve":_approve,
                  @"autype":_autype,
                  @"granttype":_granttype,
                  @"memo":_memo,
                  @"bid":_bid,
                  @"usertype":_usertype
                  };

    }
}

@end
