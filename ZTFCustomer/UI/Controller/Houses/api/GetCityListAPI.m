//
//  GetCityListAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetCityListAPI.h"

@interface GetCityListAPI ()
@property (nonatomic, strong)NSMutableArray *cities;
@end

@implementation GetCityListAPI

//@def_singleton( GetCityListAPI )

//-(NSString *)requestUrl{
//    return @"houses/cityLsit";
//}

-(NSString *)requestUrl{
    return PROJECT_SELECT_CITY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


-(NSMutableArray *)cities{
    if (!_cities) {
        _cities = [NSMutableArray array];
    }
    return _cities;
}

-(void)getCityList{
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    GetCityListAPI *getCityListApi = [[GetCityListAPI alloc]init];
    [getCityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                RegionModel *region = [RegionModel mj_objectWithKeyValues:dic];
                [self.cities addObject:region];
            }
            
             PERFORM_BLOCK_SAFELY(self.whenUpdated, nil);
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        
    }];
}



@end
