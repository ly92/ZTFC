//
//  RegisterDeviceAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface RegisterDeviceAPI : YTKRequest

-(instancetype)initWithMemberIDType:(NSString *)memberIDType objid:(NSString *)objid pushtoken:(NSString *)pushtoken;

@end
