//
//  ScanGetCouponAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSInteger,SCANGETCOUPONTYPE) {
    COUPONINFO, //优惠券信息
    GETCOUPON  //领取优惠券
  
};

@interface ScanGetCouponAPI : YTKRequest

@property (nonatomic, assign) SCANGETCOUPONTYPE couponType;


//扫描领取优惠券
-(instancetype)initWithCouponid:(NSString *)couponid;

@end
