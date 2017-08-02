//
//  UnRegisterDeviceAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UnRegisterDeviceAPI.h"

@interface UnRegisterDeviceAPI ()
{
    NSString *_memberIDType;
    NSString *_objid;
    
}
@end

@implementation UnRegisterDeviceAPI

-(instancetype)initWithMemberIDType:(NSString *)memberIDType objid:(NSString *)objid{
    if (self == [super init]) {
        _memberIDType = memberIDType;
        _objid = objid;
    }
    return self;
}


-(NSString *)requestUrl{
    return UNREGISTER_DEVICE_URL;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"MemberIDType":_memberIDType,
             @"objid":_objid
             };

}


@end
