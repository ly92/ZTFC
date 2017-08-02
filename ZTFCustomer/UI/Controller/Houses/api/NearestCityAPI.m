//
//  NearestCityAPI.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NearestCityAPI.h"

@interface NearestCityAPI ()

{
    NSString *_lng;
    NSString *_lat;
    NSString *_radius;
}

@end

@implementation NearestCityAPI

-(instancetype)initWithLng:(NSString *)lng lat:(NSString *)lat radius:(NSString *)radius{
    if (self == [super init]) {
        _lng = lng;
        _lat = lat;
        _radius = radius;
    }
    return self;
}
-(NSString *)requestUrl{
    return PROJECT_NEARESTCITY;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"lng":_lng,
             @"lat":_lat,
             @"radius":_radius};
}

@end
