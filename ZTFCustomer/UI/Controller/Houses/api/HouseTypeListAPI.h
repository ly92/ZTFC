//
//  HouseTypeListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
//户型列表
@interface HouseTypeListAPI : YTKRequest

-(instancetype)initWithProjectId:(NSString *)projectId skip:(NSString *)skip limit:(NSString *)limit;

@end
