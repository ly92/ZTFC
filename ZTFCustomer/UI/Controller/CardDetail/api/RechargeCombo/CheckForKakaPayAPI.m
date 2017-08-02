//
//  CheckForKakaPayAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CheckForKakaPayAPI.h"

@interface CheckForKakaPayAPI ()
{
    NSString *_appId;
}
@end

@implementation CheckForKakaPayAPI

-(instancetype)initWithAppId:(NSString *)appid{
    if (self == [super init]) {
        _appId = appid;
    }
    return self;
}
-(NSString *)requestUrl{
    return PAY_CHECK_KAKAPAY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"appid":_appId};
}

@end
