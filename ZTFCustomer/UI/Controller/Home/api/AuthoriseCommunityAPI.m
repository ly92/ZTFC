//
//  AuthoriseCommunityAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AuthoriseCommunityAPI.h"

@implementation AuthoriseCommunityAPI

-(NSString *)requestUrl{
    return HOME_COMMUNITYLIST;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
