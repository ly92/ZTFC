//
//  ComplaintListAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ComplaintListAPI.h"

@implementation ComplaintListAPI
-(NSString *)requestUrl{
    return YSSH_COMPLAINT_LISTUNCOMMENT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
