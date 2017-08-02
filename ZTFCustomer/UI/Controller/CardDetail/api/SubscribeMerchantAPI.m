//
//  SubscribeMerchantAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SubscribeMerchantAPI.h"

@interface SubscribeMerchantAPI ()
{
    NSString *_bid;
    NSString *_booktime;
    NSString *_content;
}
@end

@implementation SubscribeMerchantAPI

-(instancetype)initWithBid:(NSString *)bid BookTime:(NSString *)booktime Content:(NSString *)content{
    if (self == [super init]) {
        
        _bid = bid;
        _booktime = booktime;
        _content = content;
        
    }
    return self;
}

-(NSString *)requestUrl{
    return APPOINTMENT_ADD_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid" : _bid,
             @"booktime" : _booktime,
             @"content" : _content
             };
}

@end
