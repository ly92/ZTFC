//
//  CheckForKakaPayAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//查询是否支持在线支付
@interface CheckForKakaPayAPI : YTKRequest

-(instancetype)initWithAppId:(NSString *)appid;

@end
