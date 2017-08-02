//
//  MessageAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MessageAPI.h"

@interface MessageAPI ()
{
    NSString *_mainType;
    NSString *_lastId;
    NSString *_limit;
}
@end

@implementation MessageAPI

-(instancetype)initWithMainType:(NSString *)mainType lastId:(NSString *)lastId limit:(NSString *)limit{
    if (self == [super init]) {
        _mainType = mainType;
        _lastId = lastId;
        _limit = limit;
    }
    return self;
}


-(NSString *)requestUrl{
    return MSGCENTER_GETLIST_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"MainType":_mainType,
             @"LastID":_lastId,
             @"Limit":_limit};
}

@end
