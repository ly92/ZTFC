//
//  CheckDeviceAPI.h
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CheckDeviceAPI : YTKRequest

-(instancetype)initWithMemberIDType:(NSString *)memberIDType objid:(NSString *)objid pushtoken:(NSString *)pushtoken;

@end
