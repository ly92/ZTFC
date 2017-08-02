//
//  JoinActivityAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/6.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface JoinActivityAPI : YTKRequest

-(instancetype)initWithId:(NSString *)id isJoin:(NSString *)isJoin;

@end
