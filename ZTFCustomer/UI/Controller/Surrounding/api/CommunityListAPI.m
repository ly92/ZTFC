//
//  CommunityListAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CommunityListAPI.h"

@interface CommunityListAPI ()
{
    NSString *_cityid;
    NSString *_districtid;
}
@end

@implementation CommunityListAPI

-(instancetype)initWithCityid:(NSString *)cityid districtid:(NSString *)districtid{
    if (self == [super init]) {
        _cityid = cityid;
        _districtid = districtid;
    }
    return self;
}


-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    return SURROUNDING_GETLIST;
}

-(id)requestArgument{
    return @{@"cityid":_cityid,
             @"districtid":_districtid};
}


@end
