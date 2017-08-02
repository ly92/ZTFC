//
//  HouseBookAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HouseBookAPI.h"

@interface HouseBookAPI ()
{
    NSString *_appointmenttime;
    NSString *_communityid;
    NSString *_memo;
    NSString *_employeeId;
}
@end

@implementation HouseBookAPI

-(instancetype)initWithEmployyId:(NSString *)employeeId PojectId:(NSString *)projectid appointmenttime:(NSString *)appointmenttime memo:(NSString *)memo{
    if (self == [super init]) {
        _employeeId = employeeId;
        _communityid = projectid;
        _appointmenttime = appointmenttime;
        _memo = memo;
    }
    return self;
}
-(NSString *)requestUrl{
    return PROJECT_APPOINTMENT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{@"employee_id":_employeeId,
             @"project_id":_communityid,
             @"datetime":_appointmenttime,
             @"content":_memo
             };
    
}



@end
