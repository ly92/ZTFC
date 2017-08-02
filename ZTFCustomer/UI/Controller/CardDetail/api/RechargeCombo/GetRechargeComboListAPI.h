//
//  GetRechargeComboListAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetRechargeComboListAPI : YTKRequest

-(instancetype)initWithBid:(NSString *)bid skip:(NSString *)skip limit:(NSString *)limit;

@end
