//
//  HotSearchAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface HotSearchAPI : YTKRequest

-(instancetype)initWithLimits:(NSString *)limits;

@end
