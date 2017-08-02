//
//  SearchSurroundingAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SearchSurroundingAPI : YTKRequest

-(instancetype)initSurroundingWithKeyword:(NSString *)keyword bid:(NSString *)bid radius:(NSString *)radius limit:(NSString *)limit skip:(NSString *)skip industryid:(NSString *)industryid;


@end
