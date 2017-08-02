//
//  RepairListAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "RepairListAPI.h"

@implementation RepairListAPI
-(NSString *)requestUrl{
    return YSSH_REPAIR_LISTUNCOMMENT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
@end
