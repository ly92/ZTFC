//
//  CardTransactionDetailAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardTransactionDetailAPI.h"

@interface CardTransactionDetailAPI()
{
    NSString *_tid;
}
@end

@implementation CardTransactionDetailAPI
- (instancetype)initWithTid:(NSString *)tid{
    if (self = [super init]){
        _tid = tid;
    }
    return self;
}
-(NSString *)requestUrl{
    return TRANSACTION_TDETAIL_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"tid" : _tid
             };
}

@end
