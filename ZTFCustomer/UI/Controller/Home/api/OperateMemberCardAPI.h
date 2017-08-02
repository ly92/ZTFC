//
//  OperateMemberCardAPI.h
//  ZTFCustomer
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
//收藏、取消收藏会员卡
typedef NS_ENUM(NSInteger,operateMemberCardType) {
    collectMemberCardType,//收藏会员卡
    cancnelCollectMemberCardType//取消收藏
};
@interface OperateMemberCardAPI : YTKRequest

@property (nonatomic, assign) operateMemberCardType operateMemberCardType;
-(instancetype)initWithCardId:(NSString *)cardId cardType:(NSString *)cardType;

@end
