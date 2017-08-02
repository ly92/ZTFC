//
//  WeatherAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "WeatherAPI.h"

@interface WeatherAPI ()
{
    NSString *_bid;
}
@end

@implementation WeatherAPI
- (instancetype)initWithBid:(NSString *)bid{
    if (self = [super init]){
        _bid = bid;
    }
    return self;
}

-(NSString *)requestUrl{
    return WEATHER_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid};
}


@end
