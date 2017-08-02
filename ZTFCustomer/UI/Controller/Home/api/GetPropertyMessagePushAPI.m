//
//  GetPropertyMessagePushAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetPropertyMessagePushAPI.h"

@implementation GetPropertyMessagePushAPI

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return HOME_GETEMPLOYEE_MESSAGE_PUSH;
}
@end
