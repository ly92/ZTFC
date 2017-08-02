//
//  GetRepairSubtypeAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetRepairSubtypeAPI.h"

@interface GetRepairSubtypeAPI ()
{
    NSString *_maintype;
}
@end

@implementation GetRepairSubtypeAPI

-(instancetype)initWithMaintype:(NSString *)maintype{
    if (self == [super init]) {
        _maintype = maintype;
    }
    return self;
}
-(NSString *)requestUrl{
    return YSSH_REPAIR_SUBTYPE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"maintype":_maintype};
}
@end
