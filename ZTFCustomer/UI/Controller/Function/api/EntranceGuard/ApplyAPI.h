//
//  ApplyAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ApplyAPI : YTKRequest

-(instancetype)initWithAccount:(NSString *)account memo:(NSString *)memo;

@end
