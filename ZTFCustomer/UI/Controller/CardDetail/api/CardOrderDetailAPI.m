//
//  CardOrderDetailAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardOrderDetailAPI.h"

@interface CardOrderDetailAPI ()
{
    NSString *_orderId;
}
@end

@implementation CardOrderDetailAPI
//

- (instancetype)initWithOrderId:(NSString *)orderId{
    if (self = [super init]){
        _orderId = orderId;
    }
    return self;
}

-(NSString *)requestUrl{
    return BIZORDER_ORDERDETAIL_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"id" : _orderId
             };
}

@end
