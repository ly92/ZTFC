//
//  OperateBookAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "OperateBookAPI.h"

@interface OperateBookAPI ()
{
    NSString *_bookId;
    NSString *_projectId;
}
@end

@implementation OperateBookAPI

-(instancetype)initWithBookId:(NSString *)bookId projectId:(NSString *)projectId{
    if (self = [super init]) {
        _bookId = bookId;
        _projectId = projectId;
    }
    return  self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    switch (self.operateBookType) {
        case cancelBookType:
            return CANCEL_APPOINTMENT;
            break;
        case completeBookType:
            return COMPLETE_APPOINTMENT;
            break;
            
        default:
            break;
    }
    return nil;
}

-(id)requestArgument{
    return @{@"project_id":_projectId,
             @"appointment_id":_bookId};
}

@end
