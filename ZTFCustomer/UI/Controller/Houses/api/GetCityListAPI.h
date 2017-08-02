//
//  GetCityListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef void (^STIStreamModelBlock)(id error);

@interface GetCityListAPI : YTKRequest
//@singleton( GetCityListAPI )

@property (nonatomic, copy) STIStreamModelBlock whenUpdated;

//-(void)getCityList;
//-(RegionModel *)cityWithName:(NSString *)name;



@end
