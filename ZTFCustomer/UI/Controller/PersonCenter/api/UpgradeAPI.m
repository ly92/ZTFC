//
//  UpgradeAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UpgradeAPI.h"

@implementation UpgradeAPI

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return CHECK_UPGRADE_URL_ICE;
}

@end
