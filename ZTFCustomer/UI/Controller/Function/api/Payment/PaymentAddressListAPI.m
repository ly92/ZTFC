//
//  PaymentAddressListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PaymentAddressListAPI.h"

@implementation PaymentAddressListAPI

-(NSString *)requestUrl{
    return @"payment/addressList";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
