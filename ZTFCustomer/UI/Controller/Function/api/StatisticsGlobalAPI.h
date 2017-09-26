//
//  StatisticsGlobalAPI.h
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface StatisticsGlobalAPI : YTKRequest
-(instancetype)initWithtypeId:(NSString *)type_id communityId:(NSString *)community_id;

@end
