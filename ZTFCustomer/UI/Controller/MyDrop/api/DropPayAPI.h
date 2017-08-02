//
//  DropPayAPI.h
//  ZTFCustomer
//
//  Created by mac on 2017/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface DropPayAPI : YTKRequest



/**
 扫码T+0支付

 @param bid 商户ID
 @param amount 支付的金额
 @param password 支付密码（需md5)
 @param pano 商户账号
 @param atid 支付类型id
 @return void
 */
-(instancetype)initWithBid:(NSString *)bid amount:(NSString *)amount password:(NSString *)password pano:(NSString *)pano atid:(NSString *)atid;

@end
