//
//  FunctionAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FunctionAPI.h"

@interface FunctionAPI ()
{
    NSString *_limit;
}
@end

@implementation FunctionAPI

-(instancetype)initWithLimit:(NSString *)limit{
    if (self == [super init]) {
        _limit = limit;
    }
    return self;
}


-(NSString *)requestUrl{
    switch (self.functionType) {
        case HOME_FUNCTION:
        {
            return HOME_FUNCTIONLIST;
        }
            break;
            
        case MORE_FUNCTION:
        {
            return MORE_FUNCTIONLIST;
        }
            break;
            
        default:
            break;
    }
}


-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    switch (self.functionType) {
        case HOME_FUNCTION:
        {
             return @{@"limit":_limit};
        }
            break;
            
        case MORE_FUNCTION:
        {
            return nil;
        }
            break;

        default:
            break;
    }
    
}

@end
