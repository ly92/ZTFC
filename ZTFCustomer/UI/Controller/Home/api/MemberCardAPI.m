//
//  MemberCardAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardAPI.h"

@implementation MemberCardAPI


-(NSString *)requestUrl{
    switch (self.memberCardType) {
        case memberCardType:
             return HOME_CARDLIST;
            break;
        case recommandCardType:
            return HOME_RECOMMANDCARD_LIST;
            break;
            
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


@end
