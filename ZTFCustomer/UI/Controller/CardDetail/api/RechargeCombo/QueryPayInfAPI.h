//
//  QueryPayInfAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,QUERYINFOTYPE) {
    QUERYPAYINFO, //申请充值
    QUERYPAYINFORESULT,  //获取充值套餐详情
    
};

//查询在线支付信息
@interface QueryPayInfAPI : YTKRequest

@property (nonatomic, assign) QUERYINFOTYPE queryInfoType;


-(instancetype)initWithTnum:(NSString *)tnum;

@end
