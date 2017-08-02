//
//  LoginAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "LoginAPI.h"

@interface LoginAPI ()
{
    NSString *_userName;
    NSString *_pwd;
    NSString *_lat;
    NSString *_lng;
}
@end

@implementation LoginAPI

-(instancetype)initWithNormalWithMobile:(NSString *)mobile password:(NSString *)pwd lat:(NSString *)lat lng:(NSString *)lng{
    if (self == [super init]) {
        _userName = mobile;
        _pwd = pwd;
        _lng = lng;
        _lat = lat;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return LOGIN_NORMAL_ICE;
}
-(id)requestArgument{
    NSString *pushtoken = [JPUSHService registrationID];
    if (pushtoken.length == 0) {
        
        pushtoken = @"";
#ifdef DEBUG
//        pushtoken = @"13165ffa4e07798f438";
#endif
        
    }
    
    return @{@"userName":_userName,
             @"pwd":_pwd,
             @"lat":_lat,
             @"lng":_lng,
             @"pushtoken" : pushtoken};
}

@end
