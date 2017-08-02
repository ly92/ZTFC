//
//  UpdatePersonInfoAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UpdatePersonInfoAPI.h"


@interface UpdatePersonInfoAPI ()
{
    NSString *_userinfo;
}
@end

@implementation UpdatePersonInfoAPI

-(instancetype)initWithUserinfo:(NSString *)userinfo{
    if (self == [super init]) {
        _userinfo = userinfo;
    }
    return self;
}

-(NSString *)requestUrl{
    return WETOWN_USER_UPDATE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"userinfo":_userinfo};
}

@end
