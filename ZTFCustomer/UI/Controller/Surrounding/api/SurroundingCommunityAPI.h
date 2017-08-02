//
//  SurroundingCommunityAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

/**
 *周边（根据经纬度加载得到的小区和商户列表)
 */
@interface SurroundingCommunityAPI : YTKRequest


-(instancetype)initWithLongitude:(NSString *)longitude latitude:(NSString *)latitude limit:(NSString *)limit skip:(NSString *)skip;

@end
