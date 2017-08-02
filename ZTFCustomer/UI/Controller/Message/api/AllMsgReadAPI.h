//
//  AllMsgReadAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//全部已读
@interface AllMsgReadAPI : YTKRequest

-(instancetype)initWithMainType:(NSString *)mainType;

@end
