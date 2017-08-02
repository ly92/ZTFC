//
//  QueryPayInfAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "QueryPayInfAPI.h"

@interface QueryPayInfAPI ()
{
    NSString *_tnum;
}
@end

@implementation QueryPayInfAPI

-(instancetype)initWithTnum:(NSString *)tnum{
    if (self == [super init]) {
        _tnum = tnum;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.queryInfoType) {
        case QUERYPAYINFO:
            return PAY_GETPARAM;
            break;
        case QUERYPAYINFORESULT:
            return TRANSACTION_DETAIL_URL;
            break;
        default:
            break;
    }
    
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"tnum":_tnum};
}

@end
