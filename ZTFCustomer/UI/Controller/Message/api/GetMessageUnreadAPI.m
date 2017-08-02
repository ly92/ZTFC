//
//  GetMessageUnreadAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetMessageUnreadAPI.h"

@implementation GetMessageUnreadAPI
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return MSGCENTER_UNREADSTATISTICS_URL;
}
@end
