//
//  OperatePropertyConstulantAPI.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "OperatePropertyConstulantAPI.h"

@interface OperatePropertyConstulantAPI ()
{
    NSString *_saleid;
    NSString *_projectId;
    NSString *_communityId;
}
@end

@implementation OperatePropertyConstulantAPI
-(instancetype)initWithSaleid:(NSString *)saleid ProjectId:(NSString *)projectId communityId:(NSString *)communityId{
    if (self == [super init]) {
        _saleid = saleid;
        _projectId = projectId;
        _communityId = communityId;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.operateType) {
        case CANCEL:
            return HOME_ENPLOYEE_UNBIND;
            break;
        case BINDING:
            return HOME_EMPLOYEE_BIND;
            break;
        case EMPLOYEEDETAIL:
            return HOME_EMPLOYEE_DETAIL;
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
    return @{@"community_id" : _communityId,
             @"project_id":_projectId,
             @"employee_id":_saleid
             };
}

@end
