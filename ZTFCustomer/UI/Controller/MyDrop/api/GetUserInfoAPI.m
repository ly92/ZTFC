//
//  GetUserInfoAPI.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetUserInfoAPI.h"

@interface GetUserInfoAPI ()
{
    NSString *_mobile;
}
@end

@implementation GetUserInfoAPI

-(instancetype)initWithMobile:(NSString *)mobile{
    
    if (self = [super init]) {
        _mobile = mobile;
    }
    return self;
}

-(NSString *)requestUrl{
    return MYDROP_GETUSERINFO;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"mobile":_mobile};
}

@end
