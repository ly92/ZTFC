//
//  UpdatePushAmountsAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UpdatePushAmountsAPI.h"


@interface UpdatePushAmountsAPI ()
{
    NSMutableDictionary *_msgs;
}
@end

@implementation UpdatePushAmountsAPI

-(instancetype)initWithMsgDic:(NSMutableDictionary *)msgs{
    if (self == [super init]) {
        _msgs = msgs;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return CLEARPUSHAMOUNTS;
}

-(id)requestArgument{

    return @{@"msgs":[_msgs mj_JSONString]
             };
}

@end
