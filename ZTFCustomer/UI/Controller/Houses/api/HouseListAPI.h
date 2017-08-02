//
//  HouseListAPI.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


//小区，楼盘名称，价格，户型，面积,条数，页数
@interface HouseListAPI : YTKRequest


-(instancetype)initWithProvinceId:(NSString *)provinceId cityId:(NSString *)cityId districtId:(NSString *)districtId priceId:(NSString *)priceId houseTypeId:(NSString *)houseTypeId areaId:(NSString *)areaId keyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip;

@end
