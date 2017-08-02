//
//  ProjectOptionsAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ProjectOptionsAPI.h"

@implementation ProjectOptionsAPI

-(NSString *)requestUrl{
    return PROJECT_GETOPTION;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
