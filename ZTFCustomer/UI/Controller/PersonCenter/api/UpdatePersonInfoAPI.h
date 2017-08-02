//
//  UpdatePersonInfoAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//更新个人信息
@interface UpdatePersonInfoAPI : YTKRequest

-(instancetype)initWithUserinfo:(NSString *)userinfo;

@end
