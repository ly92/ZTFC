//
//  NearCommunityAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "NearCommunityAPI.h"

@interface NearCommunityAPI ()

{
    NSString *_longitude;
    NSString *_latitude;
}

@end

@implementation NearCommunityAPI

-(instancetype)initWithLongitude:(NSString *)longitude latitude:(NSString *)latitude{
    if (self == [super init]) {
        _longitude = longitude;
        _latitude = latitude;
    }
    return self;
}


-(NSString *)requestUrl{
    return COMMUNITY_NEAR;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"longitude":_longitude,
             @"latitude":_latitude
             };
}

@end
