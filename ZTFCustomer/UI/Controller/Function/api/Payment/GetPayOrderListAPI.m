//
//  GetPayOrderListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetPayOrderListAPI.h"

@interface GetPayOrderListAPI ()
{
    NSString *_addressId;
}
@end

@implementation GetPayOrderListAPI

-(instancetype)initWithAddressId:(NSString *)addressId{
    if (self = [super init]) {
        _addressId = addressId;
    }
    return self;
}
-(NSString *)requestUrl{
    return @"payment/getPayOrder";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"addressId":_addressId};
}
@end
