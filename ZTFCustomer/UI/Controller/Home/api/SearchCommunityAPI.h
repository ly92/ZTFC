//
//  SearchCommunityAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SearchCommunityAPI : YTKRequest

-(instancetype)initWithKeyword:(NSString *)keyword;

@end
