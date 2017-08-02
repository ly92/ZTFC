//
//  FeedBackDetailAPI.m
//  EstateBiz
//
//  Created by mac on 2017/2/9.
//  Copyright © 2017年 Magicsoft. All rights reserved.
//

#import "FeedBackDetailAPI.h"

@interface FeedBackDetailAPI()
{
    NSString *_id;
}
@end
@implementation FeedBackDetailAPI

-(instancetype)initWithId:(NSString *)aid{
    if (self = [super init]) {
        _id = aid;
    }
    return self;
}
-(NSString *)requestUrl{
    return MSGCENTER_FEEDBACK_DETAIL;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"id" : _id
             };
}

@end
