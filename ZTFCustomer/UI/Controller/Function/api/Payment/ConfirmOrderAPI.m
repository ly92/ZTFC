//
//  ConfirmOrderAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ConfirmOrderAPI.h"

@interface ConfirmOrderAPI ()
{
    NSString *_communityId;
    NSString *_buildId;
    NSString *_roomId;
    NSString *_build;
    NSString *_room;
    NSString *_orders;
    NSString *_totalMoney;
}
@end

@implementation ConfirmOrderAPI

-(instancetype)initWithAddress:(PaymentAddressModel *)paymentAddress orders:(NSString *)orders totalMoney:(NSString *)totalMoney{
    if (self = [super init]) {
        _communityId = paymentAddress.communityId;
        _buildId = paymentAddress.buildId;
        _roomId = paymentAddress.roomId;
        _build = paymentAddress.build;
        _room = paymentAddress.room;
        _orders = orders;
        _totalMoney = totalMoney;
    }
    return self;
}
-(NSString *)requestUrl{
    return @"payment/confirmOrder";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"communityId":_communityId,
             @"buildId":_buildId,
             @"roomId":_roomId,
             @"build":_build,
             @"room":_room,
             @"orders":_orders,
             @"totalMoney":_totalMoney};
}


@end
