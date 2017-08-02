//
//  NearestCityAPI.h
//  ZTFCustomer
//
//  Created by mac on 2016/12/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface NearestCityAPI : YTKRequest

-(instancetype)initWithLng:(NSString *)lng lat:(NSString *)lat radius:(NSString *)radius;

@end
