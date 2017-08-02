//
//  MemberCardAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,MemberCardType) {
    memberCardType = 0,//会员卡列表
    recommandCardType = 1//推荐卡列表
};

@interface MemberCardAPI : YTKRequest


@property (nonatomic, assign) MemberCardType memberCardType;

@end
