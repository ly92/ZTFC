//
//  NearCommunityAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface NearCommunityAPI : YTKRequest

-(instancetype)initWithLongitude:(NSString *)lon latitude:(NSString *)latitude;

@end
