//
//  UpdatePushAmountsAPI.h
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//更新所有计数器
@interface UpdatePushAmountsAPI : YTKRequest

-(instancetype)initWithMsgDic:(NSMutableDictionary *)msgs;

@end
