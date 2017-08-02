//
//  MerchantMsgDetailAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MerchantMsgDetailAPI.h"

@interface MerchantMsgDetailAPI ()
{
    NSString *_msgId;
}
@end

@implementation MerchantMsgDetailAPI

-(instancetype)initWithMsgId:(NSString *)msgId{
    if (self == [super init]) {
        _msgId = msgId;
    }
    return self;
}

-(NSString *)requestUrl{
    return MSGCENTER_MSG_DETAIL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"msgID":_msgId};
}

@end
