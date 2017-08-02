//
//  SurroundingListAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//周边（搜索得到的列表)
@interface SurroundingListAPI : YTKRequest


-(instancetype)initWithBid:(NSString *)bid radius:(NSString *)radius limit:(NSString *)limit skip:(NSString *)skip industryid:(NSString *)industryid;


@end
