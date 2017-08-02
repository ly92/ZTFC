//
//  GetDropAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
//获取铁豆余额

typedef NS_ENUM(NSInteger,GetDropType) {
    GetTotalDropType,//获取铁豆余额
    ExistPasswordType//判断是否有支付密码存在
};

@interface GetDropAPI : YTKRequest

@property (nonatomic, assign) GetDropType dropType;

@end
