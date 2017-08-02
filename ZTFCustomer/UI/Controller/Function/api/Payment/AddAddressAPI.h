//
//  AddAddressAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface AddAddressAPI : YTKRequest

-(instancetype)initWithCommunityid:(NSString *)communityid buildid:(NSString *)buildid roomid:(NSString *)roomid buildName:(NSString *)buildName roomName:(NSString *)roomName;

@end
