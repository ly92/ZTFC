//
//  InvitationCodeLoginAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "InvitationCodeLoginAPI.h"

@interface InvitationCodeLoginAPI ()
{
    NSString *_code;
}
@end

@implementation InvitationCodeLoginAPI

-(instancetype)initWithCode:(NSString *)code{
    if (self == [super init]) {
        _code = code;
    }
    return self;
}

-(NSString *)requestUrl{
    return LOGIN_INVITECODE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"Code":_code};
}

@end
