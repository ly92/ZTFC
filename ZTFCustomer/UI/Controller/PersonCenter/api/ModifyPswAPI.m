//
//  ModifyPswAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyPswAPI.h"

@interface ModifyPswAPI ()
{
    NSString *_oldPsw;
    NSString *_newPsw;
}
@end

@implementation ModifyPswAPI

-(instancetype)initWithPldPsw:(NSString *)oldPsw newPsw:(NSString *)newPsw{
    if (self == [super init]) {
        
        _oldPsw = oldPsw;
        _newPsw = newPsw;
        
    }
    return self;
}

-(NSString *)requestUrl{
    return WETOWN_USER_CHANGEPSW;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"OldPsw":_oldPsw,
             @"NewPsw":_newPsw
             };
}

@end
