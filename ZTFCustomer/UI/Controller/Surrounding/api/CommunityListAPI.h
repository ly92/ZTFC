//
//  CommunityListAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CommunityListAPI : YTKRequest

-(instancetype)initWithCityid:(NSString *)cityid districtid:(NSString *)districtid;

@end
