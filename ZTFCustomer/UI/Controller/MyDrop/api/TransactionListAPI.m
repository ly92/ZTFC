//
//  TransactionListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TransactionListAPI.h"

@interface TransactionListAPI ()
{
    NSString *_limit;
    NSString *_skip;
}
@end

@implementation TransactionListAPI


-(instancetype)initWithLimit:(NSString *)limit skip:(NSString *)skip{
    if (self == [super init]) {
        _limit = limit;
        _skip = skip;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    
    switch (self.transcationType) {
        case InclomeType:
            return MYDROP_GETINCOMELIST;
            break;
        case ExpendType:
            return MYDROP_GETPAYLIST;
            break;
            
        default:
            break;
    }
    
    return nil;
}
-(id)requestArgument{
    return @{@"skip":_skip,
             @"limit":_limit};
}
@end
