//
//  PropertyListAPI.m
//  ztfCustomer
//
//  Created by mac on 16/7/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyListAPI.h"

@interface PropertyListAPI ()
{
    NSString *_keyword;
    NSString *_limit;
    NSString *_skip;
    
    NSString *_projectId;
    NSString *_communityId;
}
@end

@implementation PropertyListAPI

-(instancetype)initWithkeyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _keyword = keyword;
        _limit = limit;
        _skip = skip;
    }
    return self;
}

-(instancetype)initWithCommunityId:(NSString *)communityId ProjectId:(NSString *)projectId keyword:(NSString *)keyword limit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _communityId = communityId;
        _projectId = projectId;
        _skip = skip;
        _limit = limit;
        _keyword = keyword;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.employeeType) {
        case EMPLOYEELISTTYPE:
             return HOME_EMPLOYEE_LIST;
            break;
        case EMPLOYEEMESSAGELISTTYPE:
            return HOME_EMPLOYEE_MESSAGE_LIST;
            break;
        default:
            break;
    }
    return nil;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    switch (self.employeeType) {
        case EMPLOYEELISTTYPE:
            return @{@"community_id":_communityId,
                     @"project_id":_projectId,
                     @"key":_keyword,
                     @"limit":_limit,
                     @"skip":_skip
                     };
            break;
        case EMPLOYEEMESSAGELISTTYPE:
            return @{
                     @"key":_keyword,
                     @"limit":_limit,
                     @"skip":_skip
                     };
            break;
        default:
            break;
    }
    return nil;
    
}


@end
