//
//  SelectCommunityAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SelectCommunityAPI.h"

@implementation SelectCommunityAPI

-(NSString *)requestUrl{
    return HOME_COMMUNITYALL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
