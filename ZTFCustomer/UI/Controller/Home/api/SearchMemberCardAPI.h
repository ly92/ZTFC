//
//  SearchMemberCardAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SearchMemberCardAPI : YTKRequest

//搜索会员卡
-(instancetype)initWithskeys:(NSString *)skeys lastId:(NSString *)lastId pagesize:(NSString *)pagesize;

@end
