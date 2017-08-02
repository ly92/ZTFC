//
//  ReplyRechargeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,GERRECHARGETYPE) {
    REPAYRECHARGE, //申请充值
    GETRECHARGEDETAIL,  //获取充值套餐详情
   
};

@interface ReplyRechargeAPI : YTKRequest


@property (nonatomic, assign) GERRECHARGETYPE rechargeType;

//申请充值
-(instancetype)initWithRechargeId:(NSString *)rechargeId;

@end
