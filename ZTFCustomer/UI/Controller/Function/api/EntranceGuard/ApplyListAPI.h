//
//  ApplyListAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
typedef NS_ENUM(NSInteger,ENTRANCEGURDTYPE) {
    APPLY, //首页功能栏
    AUTHROZATION,  //更多功能栏
    CHECKGRANTED, //检查是否有授权权限
    ALLOWAUTHCOMMUNITY //获取可授权小区列表
};
@interface ApplyListAPI : YTKRequest


@property (nonatomic, assign) ENTRANCEGURDTYPE entranceGuardType;;


@end
