//
//  HouseDynamicDetailApi.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HouseDynamicDetailApi.h"

@interface HouseDynamicDetailApi (){
    NSString *_project_progress_id;
}

@end

@implementation HouseDynamicDetailApi
-(instancetype)initWithProjectProgressId:(NSString *)project_progress_id{
    if (self == [super init]) {
        _project_progress_id = project_progress_id;
    }
    return self;
}
-(NSString *)requestUrl{
    return PROJECT_HOUSEDYNAMIC_DETAIL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{@"project_progress_id":_project_progress_id};
    
}


@end
