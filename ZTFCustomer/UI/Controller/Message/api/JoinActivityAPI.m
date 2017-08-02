//
//  JoinActivityAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/6.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "JoinActivityAPI.h"

@interface JoinActivityAPI ()
{
    NSString *_id;
    NSString *_isJoin;
}
@end

@implementation JoinActivityAPI

-(instancetype)initWithId:(NSString *)id isJoin:(NSString *)isJoin{
    
    if (self == [super init]){
        _id = id;
        _isJoin = isJoin;
    }
    return self;
}

-(NSString *)requestUrl{
    return CARDMSG_EVENT_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"id":_id,
             @"is_join":_isJoin};
}

@end
