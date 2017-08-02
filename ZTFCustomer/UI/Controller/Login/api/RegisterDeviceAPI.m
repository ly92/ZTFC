//
//  RegisterDeviceAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "RegisterDeviceAPI.h"

@interface RegisterDeviceAPI ()
{
    NSString *_memberIDType;
    NSString *_objid;
    NSString *_pushtoken;
    
}
@end

@implementation RegisterDeviceAPI

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
    return REGISTER_DEVICE_URL;
}

-(id)requestArgument{
    return @{@"MemberIDType":_memberIDType,
             @"objid":_objid,
             @"pushtoken":_pushtoken};
}

@end
