//
//  HouseDetailAPI.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,OPERATEHOUSE) {
    HOUSEDETAIL,//楼盘详情
    COLLECTHOUSE,//收藏楼盘
    CANCELCOLLECTHOUSE,//取消收藏
    HOUSETYPEDETAIL//户型详情
};

//id号
@interface HouseDetailAPI : YTKRequest

@property (nonatomic, assign) OPERATEHOUSE operateHouse;

-(instancetype)initWithHoustId:(NSString *)houseId;

@end
