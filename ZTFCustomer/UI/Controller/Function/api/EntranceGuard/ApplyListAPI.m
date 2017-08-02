//
//  ApplyListAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyListAPI.h"

@implementation ApplyListAPI

-(NSString *)requestUrl{
    switch (self.entranceGuardType) {
        case APPLY:
            return ENTRANCE_APPLY_HISTORYLIST;
            break;
        case AUTHROZATION:
            return ENTRANCE_APPROVE_LIST;
            break;
        case CHECKGRANTED:
            return ENTRANCE_ISGRANTED;
            break;
        case ALLOWAUTHCOMMUNITY:
            return AUTHORITY_COMMUNITYLIST;
            break;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
