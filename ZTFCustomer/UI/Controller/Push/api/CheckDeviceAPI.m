//
//  CheckDeviceAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CheckDeviceAPI.h"

@interface CheckDeviceAPI ()
{
    NSString *_memberIDType;
    NSString *_objid;
    NSString *_pushtoken;
    
}
@end

@implementation CheckDeviceAPI
-(instancetype)initWithMemberIDType:(NSString *)memberIDType objid:(NSString *)objid pushtoken:(NSString *)pushtoken{
    if (self == [super init]) {
        _memberIDType = memberIDType;
        _objid = objid;
        _pushtoken = pushtoken;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return CHECK_DEVICE_VALID_URL;
}

-(id)requestArgument{
    return @{@"MemberIDType":_memberIDType,
             @"objid":_objid,
             @"pushtoken":_pushtoken};
}
@end
