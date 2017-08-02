//
//  UnRegisterDeviceAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface UnRegisterDeviceAPI : YTKRequest

-(instancetype)initWithMemberIDType:(NSString *)memberIDType objid:(NSString *)objid;

@end
