//
//  MessageAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface MessageAPI : YTKRequest


-(instancetype)initWithMainType:(NSString *)mainType lastId:(NSString *)lastId limit:(NSString *)limit;

@end
