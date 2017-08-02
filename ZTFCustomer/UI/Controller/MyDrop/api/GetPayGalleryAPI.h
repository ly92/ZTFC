//
//  GetPayGalleryAPI.h
//  ZTFCustomer
//
//  Created by mac on 2017/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

//获取支付通道和商户信息
@interface GetPayGalleryAPI : YTKRequest

-(instancetype)initWithBid:(NSString *)bid;

@end
