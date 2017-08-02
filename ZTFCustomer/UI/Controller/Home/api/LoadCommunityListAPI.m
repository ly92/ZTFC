//
//  LoadCommunityListAPI.m
//  ZTFCustomer
//
//  Created by wangshanshan on 16/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoadCommunityListAPI.h"

@implementation LoadCommunityListAPI

-(NSString *)requestUrl{
    return HOME_COMMUNITY_LIST;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
@end
