//
//  CollectListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef NS_ENUM(NSInteger,CollectListType) {
    ProjectCollectListType,//楼盘收藏
    HouseTypeCollectListType//户型收藏
};

@interface CollectListAPI : YTKRequest

@property (nonatomic, assign) CollectListType collectListType;

-(instancetype)initWithSlip:(NSString *)skip limit:(NSString *)limit;


@end
