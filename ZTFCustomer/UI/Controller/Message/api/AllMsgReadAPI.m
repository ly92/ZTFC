//
//  AllMsgReadAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AllMsgReadAPI.h"

@interface AllMsgReadAPI ()
{
    NSString *_mainType;
}
@end

@implementation AllMsgReadAPI

-(instancetype)initWithMainType:(NSString *)mainType{
    if (self == [super init]) {
        _mainType = mainType;
    }
    return self;
}

-(NSString *)requestUrl{
    return MSGCENTER_SETREAD_ALL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"maintype":_mainType};
}

@end
