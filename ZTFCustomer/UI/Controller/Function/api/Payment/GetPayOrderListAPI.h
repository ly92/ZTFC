//
//  GetPayOrderListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetPayOrderListAPI : YTKRequest

-(instancetype)initWithAddressId:(NSString *)addressId;

@end
