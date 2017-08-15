//
//  PropertyListAPI.h
//  ztfCustomer
//
//  Created by mac on 16/7/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSInteger,EMPLOYEETYPE) {
    EMPLOYEELISTTYPE,//顾问列表
    EMPLOYEEMESSAGELISTTYPE//顾问消息列表
};

//获取楼栋管家列表和顾问消息列表
@interface PropertyListAPI : YTKRequest

@property (nonatomic, assign) EMPLOYEETYPE employeeType;
//顾问消息列表
-(instancetype)initWithkeyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip;

//获取楼栋管家列表
-(instancetype)initWithCommunityId:(NSString *)communityId ProjectId:(NSString *)projectId keyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip;


@end
