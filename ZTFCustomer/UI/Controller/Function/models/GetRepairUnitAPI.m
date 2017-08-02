//
//  GetRepairUnitAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetRepairUnitAPI.h"

@interface GetRepairUnitAPI ()
{
    NSString *_communityid;
}
@end

@implementation GetRepairUnitAPI

-(instancetype)initWithCommunityid:(NSString *)communityid{
    if (self = [super init]) {
        _communityid = communityid;
    }
    return self;
}
-(NSString *)requestUrl{
    return YSSH_REPAIR_UNIT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"bid":_communityid};
}
@end
