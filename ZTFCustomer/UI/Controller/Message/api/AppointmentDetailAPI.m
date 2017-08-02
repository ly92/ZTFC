//
//  AppointmentDetailAPI.m
//  EstateBiz
//
//  Created by mac on 2017/2/9.
//  Copyright © 2017年 Magicsoft. All rights reserved.
//

#import "AppointmentDetailAPI.h"

@interface AppointmentDetailAPI ()
{
    NSString *_aid;
}
@end

@implementation AppointmentDetailAPI


-(instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        _aid = aid;
    }
    return self;
}

-(NSString *)requestUrl{
    return MSGCENTER_BOOK_DETAIL;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"aid" : _aid
             };
}

@end
