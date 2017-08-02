//
//  CreateOrderAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CreateOrderAPI.h"

@interface CreateOrderAPI ()
{
    NSString *_value;
    NSString *_bid;
    NSString *_money;
    NSString *_content;
    NSString *_extype;
    NSString *_callback;
}
@end

@implementation CreateOrderAPI
-(instancetype)initWithValue:(NSString *)value{
    if (self == [super init]) {
        _value = value;
    }
    return self;
}
-(instancetype)initWithBid:(NSString *)bid money:(NSString *)money callBack:(NSString *)callback content:(NSString *)test extype:(NSString *)extype{
    if (self == [super init]) {
        _bid = bid;
        _callback = callback;
        _content = test;
        _money = money;
        _extype = extype;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    return @"v1/kakapay/createTransaction";
}
-(id)requestArgument{
//    return @{@"value":_value};
    
    return @{@"bid":_bid,
             @"money":_money,
             @"callback":_callback,
             @"content":_content,
             @"extype":_extype};
}

@end
