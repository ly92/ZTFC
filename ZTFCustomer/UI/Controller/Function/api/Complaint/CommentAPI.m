//
//  CommentAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CommentAPI.h"


@interface CommentAPI ()
{
    NSString *_id;
    NSString *_satisfied;
    NSString *_reason;
}
@end
@implementation CommentAPI

-(instancetype)initWithOrderNO:(NSString *)orderNo satisfied:(NSString *)satisfied reason:(NSString *)reason{
    if (self == [super init]) {
        _id = orderNo;
        _satisfied = satisfied;
        _reason = reason;
    }
    return self;
}
-(NSString *)requestUrl{
    switch (self.commentType) {
        case COMPLAINT:
            return YSSH_COMPLAINT_COMMENT;
            break;
        case REPAIR:
            return YSSH_REPAIR_COMMENT;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"id":_id,
             @"satisfied":_satisfied,
             @"reason":_reason};
}


@end
