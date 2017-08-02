//
//  FetchPushAmountsAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FetchPushAmountsAPI.h"

@implementation FetchPushAmountsAPI


-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return FETCHPUSHAMOUNTS;
}
@end
