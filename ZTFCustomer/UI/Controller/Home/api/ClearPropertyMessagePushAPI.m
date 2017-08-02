//
//  ClearPropertyMessagePushAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ClearPropertyMessagePushAPI.h"

@interface ClearPropertyMessagePushAPI ()
{
    NSString *_messageId;
    NSString *_count;
}
@end

@implementation ClearPropertyMessagePushAPI

-(instancetype)initWithMessageId:(NSString *)messageId count:(NSString *)count{
    if (self == [super init]) {
        _messageId = messageId;
        _count = count;
    }
    return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return HOME_CLEAREMPLOYEE_MESSAGE_PUSH;
}
-(id)requestArgument{
    return @{@"message_id":_messageId,
             @"count":_count};
}

@end
