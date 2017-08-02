//
//  GetRechargeListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetRechargeListAPI.h"

@implementation GetRechargeListAPI
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    return @"drop/getRechargeList";
}
@end
