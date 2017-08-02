//
//  HouseTypeCollectAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>


typedef NS_ENUM(NSInteger,HousetypeCollectType) {
    housetypeCollectType,//户型收藏
    housetypeCancelCollectType//户型取消收藏
};

@interface HouseTypeCollectAPI : YTKRequest

@property (nonatomic, assign) HousetypeCollectType housetypeCollectType;

-(instancetype)initWithProjectId:(NSString *)projectId housetypeId:(NSString *)housetypeId;

@end
