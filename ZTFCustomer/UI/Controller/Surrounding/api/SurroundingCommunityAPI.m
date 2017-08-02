//
//  SurroundingCommunityAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SurroundingCommunityAPI.h"
#import "BaseUrlFilter.h"

@interface SurroundingCommunityAPI ()
{
    NSString *_longitude;
    NSString *_latitude;
    NSString *_limit;
    NSString *_skip;
}
@end

@implementation SurroundingCommunityAPI

-(instancetype)initWithLongitude:(NSString *)longitude latitude:(NSString *)latitude limit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        
        _longitude = longitude;
        _latitude = latitude;
        _limit = limit;
        _skip = skip;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    return SURROUNDING_NEARCOMMUNITY;
}

-(id)requestArgument{
    return @{@"longitude":_longitude,
             @"latitude":_latitude,
             @"limit":_limit,
             @"skip":_skip,
             };
}

@end
