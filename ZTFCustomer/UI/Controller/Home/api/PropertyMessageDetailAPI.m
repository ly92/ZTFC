//
//  PropertyMessageDetailAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PropertyMessageDetailAPI.h"

@interface PropertyMessageDetailAPI ()

{
    NSString *_messageId;
}
@end

@implementation PropertyMessageDetailAPI

-(instancetype)initWithMessageId:(NSString *)messageId{
    if (self == [super init]) {
        _messageId = messageId;
    }
    return self;
}
-(NSString *)requestUrl{
    return HOME_EMPLOYEE_MESSAGE_DETAIL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"message_id":_messageId};
}
@end
