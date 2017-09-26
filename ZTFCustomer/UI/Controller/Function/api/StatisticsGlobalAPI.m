//
//  StatisticsGlobalAPI.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "StatisticsGlobalAPI.h"

@interface StatisticsGlobalAPI (){
    NSString *_type_id;
    NSString *_community_id;
}

@end

@implementation StatisticsGlobalAPI
- (instancetype)initWithtypeId:(NSString *)type_id communityId:(NSString *)community_id{
    if (self = [super init]){
        _type_id = type_id;
        _community_id = community_id;
    }
    return self;
}
-(NSString *)requestUrl{
    return STATISTICS_GLOBAL_API;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    if ([[_community_id trim] isEqualToString:@""]){
        return @{@"type_id":_type_id};
    }else{
        return @{@"type_id":_type_id,
                 @"community_id" : _community_id
                 };
    }
    
}


@end

