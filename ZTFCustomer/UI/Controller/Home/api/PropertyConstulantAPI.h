//
//  PropertyConstulantAPI.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,PROPERTYCONSTULANTINFO) {
    ISBINDPROPERTY,//首页楼栋管家信息
    CHATUSERINFO//楼栋管家列表
};

//获取首页顾问信息
@interface PropertyConstulantAPI : YTKRequest

@property (nonatomic, assign) PROPERTYCONSTULANTINFO propertyType;

-(instancetype)initWithSalemanIM:(NSString *)salemanIM;


-(instancetype)initWithProjectId:(NSString *)projectId communityId:(NSString *)communityId key:(NSString *)key skip:(NSString *)skip limit:(NSString *)limit;


@end
