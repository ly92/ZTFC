//
//  CollectListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectListAPI.h"

@interface CollectListAPI ()
{
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation CollectListAPI

-(instancetype)initWithSlip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _skip = skip;
        _limit = limit;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.collectListType) {
        case ProjectCollectListType:
            return PERSON_PROJECTCOLLECT_LIST;
            break;
        case HouseTypeCollectListType:
            return PERSON_HOUSETYPECOLLECT_LIST;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"skip":_skip,
             @"limit":_limit
             };
}

@end
