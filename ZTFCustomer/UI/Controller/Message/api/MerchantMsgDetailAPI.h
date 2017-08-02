//
//  MerchantMsgDetailAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface MerchantMsgDetailAPI : YTKRequest

-(instancetype)initWithMsgId:(NSString *)msgId;

@end
