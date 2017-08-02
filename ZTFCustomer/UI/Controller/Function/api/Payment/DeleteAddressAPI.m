//
//  DeleteAddressAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DeleteAddressAPI.h"

@interface DeleteAddressAPI ()
{
    NSString *_addressId;
}
@end

@implementation DeleteAddressAPI


-(instancetype)initWithAddressId:(NSString *)addressId{
    if (self = [super init]) {
        _addressId = addressId;
    }
    return self;
}

-(NSString *)requestUrl{
    return @"payment/deleteAddress";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"addressid":_addressId};
}
@end
