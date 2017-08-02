//
//  ApplyAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyAPI.h"

@interface ApplyAPI ()
{
    NSString *_account;
    NSString *_memo;
}
@end


@implementation ApplyAPI

-(instancetype)initWithAccount:(NSString *)account memo:(NSString *)memo{
    if (self == [super init]) {
        _account = account;
        _memo = memo;
    }
    return self;
}

-(NSString *)requestUrl{
    return ENTRANCE_APPLY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"account":_account,
             @"memo":_memo};
}

@end
