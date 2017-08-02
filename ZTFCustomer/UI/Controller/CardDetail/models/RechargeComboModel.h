//
//  RechargeComboModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiXinModel;
@class AlipayModel;

@interface RechargeComboModel : NSObject

@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *rechargeid;
@property (nonatomic, copy) NSString *sellcount;
@property (nonatomic, copy) NSString *status;

@end


@interface PayListModel : NSObject

@property (nonatomic, copy) NSString *accounttype;
@property (nonatomic, copy) NSString *destaccount;
@property (nonatomic, copy) NSString *destno;
@property (nonatomic, copy) NSString *desttype;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pano;

@end


@interface RechargeCouponListModel : NSObject

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *biz_coupon_sn_id;
@property (nonatomic, copy) NSString *end_date;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *title;

@end

@interface PayOrderResultModel : NSObject

@property (nonatomic, copy) NSString *callback;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *tnum;
@property (nonatomic, strong) WeiXinModel *weixin;
@property (nonatomic, strong) AlipayModel *alipay;


@end

@interface WeiXinModel : NSObject
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *callback;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *packageValue;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *paytype;
@property (nonatomic, copy) NSString *prepayId;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *tno;

@end


@interface AlipayModel : NSObject

@property (nonatomic, copy) NSString *callback;
@property (nonatomic, copy) NSString *orderInfo;
@property (nonatomic, copy) NSString *paytype;
@property (nonatomic, copy) NSString *tno;

@end