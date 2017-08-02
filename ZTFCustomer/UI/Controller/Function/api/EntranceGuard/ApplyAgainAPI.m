//
//  ApplyAgainAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyAgainAPI.h"

@interface ApplyAgainAPI ()
{
    NSString *_cid;
    NSString *_memo;
}
@end

@implementation ApplyAgainAPI

-(instancetype)initWithCid:(NSString *)cid memo:(NSString *)memo{
    if (self == [super init]) {
        _cid = cid;
        _memo = memo;
    }
    return self;
}

-(NSString *)requestUrl{
    return ENTRANCE_APPLY_AGAIN;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"cid":_cid,
             @"memo":_memo};
}

@end
