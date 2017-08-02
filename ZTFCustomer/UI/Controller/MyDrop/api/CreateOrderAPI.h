//
//  CreateOrderAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CreateOrderAPI : YTKRequest

//获取订单号
-(instancetype)initWithBid:(NSString *)bid money:(NSString *)money callBack:(NSString *)callback content:(NSString *)test extype:(NSString *)extype;

-(instancetype)initWithValue:(NSString *)value;

@end
