//
//  HouseListAPI.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseListAPI.h"

@interface HouseListAPI ()
{
    NSString *_procvinceId;
    NSString *_cityId;
    NSString *_districtId;
    NSString *_priceid;
    NSString *_houseTypeId;
    NSString *_areaId;
    NSString *_key;
    NSString *_limit;
    NSString *_skip;
}
@end

@implementation HouseListAPI

-(instancetype)initWithProvinceId:(NSString *)provinceId cityId:(NSString *)cityId districtId:(NSString *)districtId priceId:(NSString *)priceId houseTypeId:(NSString *)houseTypeId areaId:(NSString *)areaId keyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _procvinceId = provinceId;
        _cityId = cityId;
        _districtId = districtId;
        _priceid = priceId;
        _houseTypeId = houseTypeId;
        _areaId = areaId;
        _key = keyword;
        _limit = limit;
        _skip = skip;
    }
    return self;
}


-(NSString *)requestUrl{
    return PROJECT_LIST;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"province_id":_procvinceId,
             @"city_id":_cityId,
             @"district_id":_districtId,
             @"price_id":_priceid,
             @"house_type_id":_houseTypeId,
             @"area_id":_areaId,
             @"key":_key,
             @"limit":_limit,
             @"skip":_skip
             };
}
@end
