//
//  DropPayAPI.m
//  ZTFCustomer
//
//  Created by mac on 2017/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DropPayAPI.h"

@interface DropPayAPI ()
{
    NSString *_bid;
    NSString *_amount;
    NSString *_password;
    NSString *_pano;
    NSString *_atid;
}
@end

@implementation DropPayAPI
-(instancetype)initWithBid:(NSString *)bid amount:(NSString *)amount password:(NSString *)password pano:(NSString *)pano atid:(NSString *)atid{
    if (self = [super init]) {
        _bid = bid;
        _amount = amount;
        _password = [password md5String];
        _pano = pano;
        _atid = atid;
    }
    return self;
}

-(NSString *)requestUrl{
    return MYDROP_SCAN_PAY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{
             @"bid":_bid,
             @"amount":_amount,
             @"password":_password,
             @"pano":_pano,
             @"atid":_atid
             };
}

@end
