//
//  MyBookListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyBookListAPI.h"

@interface MyBookListAPI ()
{
    NSString *_communityid;
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation MyBookListAPI

-(instancetype)initWithCommunityid:(NSString *)communityid limit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _communityid = communityid;
        _skip = skip;
        _limit = limit;
    }
    return self;
}
-(instancetype)initWithlimit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _skip = skip;
        _limit = limit;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.appointmentListType) {
        case ProjectAppointmentList:
            return PROJECT_APPOINTMENT_LIST;
            break;
        case PersonAppointmentList:
            return PERSON_APPOINTMENT_LIST;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    switch (self.appointmentListType) {
        case ProjectAppointmentList:
            return @{@"project_id":_communityid,
                     @"skip":_skip,
                     @"limit":_limit};
            break;
        case PersonAppointmentList:
            return @{
                     @"skip":_skip,
                     @"limit":_limit};
            break;
        default:
            break;
    }
}
@end
