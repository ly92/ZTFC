//
//  AddAddressAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AddAddressAPI.h"

@interface AddAddressAPI ()
{
    NSString *_communityid;
    NSString *_buildid;
    NSString *_roomid;
    NSString *_buildName;
    NSString *_roomName;
}
@end

@implementation AddAddressAPI

-(instancetype)initWithCommunityid:(NSString *)communityid buildid:(NSString *)buildid roomid:(NSString *)roomid buildName:(NSString *)buildName roomName:(NSString *)roomName{
    if (self == [super init]) {
        _communityid = communityid;
        _buildid = buildid;
        _roomid = roomid;
        _buildName = buildName;
        _roomName = roomName;
    }
    return self;
}
-(NSString *)requestUrl{
    return @"payment/addAddress";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"communityid":_communityid,
             @"buildid":_buildid,
             @"roomid":_roomid,
             @"buildName":_buildName,
             @"roomName":_roomName};
}
@end
