//
//  FunctionAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSInteger,FUNCTIONTYPE) {
    HOME_FUNCTION, //首页功能栏
    MORE_FUNCTION  //更多功能栏
};

@interface FunctionAPI : YTKRequest

@property (nonatomic, assign) FUNCTIONTYPE functionType;


-(instancetype)initWithLimit:(NSString *)limit;

@end
