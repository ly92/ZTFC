//
//  HouseDynamicDetailApi.h
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HouseDynamicDetailApi : YTKRequest
-(instancetype)initWithProjectProgressId:(NSString *)project_progress_id;
@end
