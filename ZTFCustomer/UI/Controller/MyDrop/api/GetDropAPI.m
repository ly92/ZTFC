//
//  GetDropAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetDropAPI.h"

@implementation GetDropAPI
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    switch (self.dropType) {
        case GetTotalDropType:
            return MYDROP_GETLEFTMONEY;
            break;
        case ExistPasswordType:
            return MYDROP_EXISTPASSWORD;
            break;
        default:
            break;
    }
    return nil;
}

@end
