//
//  LoadNoticeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,NoticeType) {
    BannerType = 1,//banner广告
    ActitvityType = 2 //活动
};

@interface LoadNoticeAPI : YTKRequest

@property (nonatomic, assign) NoticeType noticeType;
-(instancetype)initWithOwnerId:(NSString *)ownerid;

@end
