//
//  CancelAuthAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CancelAuthAPI.h"

@interface CancelAuthAPI ()
{
    NSString *_ID;
}
@end

@implementation CancelAuthAPI

-(instancetype)initWithId:(NSString *)ID{
    if (self == [super init]) {
        _ID = ID;
    }
    return self;
}

-(NSString *)requestUrl{
    return ENTRANCE_AUTH_CANCEL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


-(id)requestArgument{
    return @{@"id":_ID};
}

@end
