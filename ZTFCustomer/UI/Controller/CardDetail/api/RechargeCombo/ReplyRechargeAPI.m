
//
//  ReplyRechargeAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ReplyRechargeAPI.h"

@interface ReplyRechargeAPI ()
{
    NSString *_recharegeId;
}
@end

@implementation ReplyRechargeAPI

-(instancetype)initWithRechargeId:(NSString *)rechargeId{
    if (self = [super init]) {
        _recharegeId = rechargeId;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.rechargeType) {
        case REPAYRECHARGE:
            return RECHARGE_REPLAYCOMBO;
            break;
        case GETRECHARGEDETAIL:
            return RECHARGE_GETCOMBOINFO;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"rechargeid":_recharegeId
             };
}

@end
