//
//  HouseDynamicListApi.h
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HouseDynamicListApi : YTKRequest
-(instancetype)initWithProjectId:(NSString *)projectId skip:(NSString *)skip limit:(NSString *)limit;
@end
