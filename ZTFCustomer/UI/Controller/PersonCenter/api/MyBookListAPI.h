//
//  MyBookListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

//预约看房列表（某楼盘的历史预约，全部楼盘的历史预约）

typedef NS_ENUM(NSInteger, AppointmentListType) {
    ProjectAppointmentList,//某楼盘历史预约
    PersonAppointmentList//全部楼盘的历史预约
};

@interface MyBookListAPI : YTKRequest

@property (nonatomic, assign) AppointmentListType appointmentListType;

-(instancetype)initWithCommunityid:(NSString *)communityid limit:(NSString *)limit skip:(NSString *)skip;

-(instancetype)initWithlimit:(NSString *)limit skip:(NSString *)skip;

@end
