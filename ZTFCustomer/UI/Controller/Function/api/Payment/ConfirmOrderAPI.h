//
//  ConfirmOrderAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ConfirmOrderAPI : YTKRequest

-(instancetype)initWithAddress:(PaymentAddressModel *)paymentAddress orders:(NSString *)orders totalMoney:(NSString *)totalMoney;

@end
