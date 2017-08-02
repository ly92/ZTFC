//
//  AppLocation.m
//  gaibianjia
//
//  Created by PURPLEPENG on 9/21/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "AppLocation.h"
#import "BaiduLocation.h"
#import "MMBProgressHUD.h"
//#import "CityListModel.h"

#pragma mark -

NSString *const GetLocationSucceedNotification = @"GetLocationSucceedNotification";
NSString *const GetReverseCodeSucceedNotification = @"GetReverseCodeSucceedNotification";
NSString *const DidChangeCurrentLocationNotification = @"DidChangeCurrentLocationNotification";

#pragma mark -

@interface AppLocation ()
@property(nonatomic,strong)NSMutableArray *cityies;

@end

@implementation AppLocation

@def_singleton( AppLocation )


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        UserModel *user = [[LocalData shareInstance]getUserAccount];
        
        self.selectCity = [STICache.global objectForKey:[NSString stringWithFormat:@"crcclocation_selectcity_%@",user.mobile]];
        
        @weakify(self);
        [self locateThen:^(RegionModel *city) {
            @strongify(self);
            self.currentCity = city;
            if (self.selectCity == nil) {
                self.selectCity = city;
            }
        }];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(location) name:GetLocationSucceedNotification object:nil];
    }
    
    return self;
}

- (Location *)location
{
    Location * location = [Location new];
    
    if ( [BaiduLocation sharedLocation].location.coordinate.latitude == 0 )
    {
        location.lat = @(39.897445);
//        location.lat = @(40.072180771961655);
    }
    else
    {
        location.lat = @([BaiduLocation sharedLocation].location.coordinate.latitude);
    }
    
    if ( [BaiduLocation sharedLocation].location.coordinate.longitude == 0 )
    {
        location.lon = @(116.331398);
//        location.lon = @(116.35394234317074);
    }
    else
    {
        location.lon = @([BaiduLocation sharedLocation].location.coordinate.longitude);
    }
    
    return location;
}


- (void)locateThen:(void (^)(RegionModel * city))locateThen
{
    BaiduLocation * locationService = [BaiduLocation sharedLocation];
    
    @weakify(locationService);
    locationService.whenGetLocation = ^(CLLocation * location, NSError * e){
        @strongify(locationService);
        
        if ( location )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:GetLocationSucceedNotification object:nil];
            [locationService reverseGeocodingLocation:location then:^(id placemark, NSError *e) {
                if ( placemark )
                {
                    // 百度返回 BMKReverseGeoCodeResult
                    BMKReverseGeoCodeResult * result = (BMKReverseGeoCodeResult *)placemark;
                    
                    __block RegionModel * city = [[RegionModel alloc] init];
                    
                    NSString *cityname = result.addressDetail.city;
                    
                    //获取城市列表
                    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
                    GetCityListAPI *getCityListApi = [[GetCityListAPI alloc]init];
                    
                    [getCityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissTips];
                        [self.cityies removeAllObjects];
                        NSDictionary *result1 = (NSDictionary *)request.responseJSONObject;
                        
                        if (![ISNull isNilOfSender:result1] && [result1[@"result"] intValue] == 0) {
                            NSDictionary *content = result1[@"content"];
                            if (![ISNull isNilOfSender:content]) {
                                NSArray *list = content[@"regions"];
                                for (NSDictionary *dic in list) {
                                    RegionModel *region = [RegionModel mj_objectWithKeyValues:dic];
                                    [self.cityies addObject:region];
                                }
                                
                               
                                for (RegionModel *regionModel in self.cityies) {
                                    if ([cityname containsString:regionModel.name] || [regionModel.name containsString:cityname]) {
                                        city = regionModel;
                                    }
                                }
                                
                                if (city.id == nil) {
                                    city.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                                    city.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
                                }
                                
                                //city.name = [NSString stringWithFormat:@"%@",result.addressDetail.city];
                                self.currentCity = city;
//                                self.selectCity = city;
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:GetReverseCodeSucceedNotification object:nil];
                                PERFORM_BLOCK_SAFELY(locateThen, city);
                            }
                        }else{
                            [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
                             PERFORM_BLOCK_SAFELY(locateThen, nil);
                        }
                        
                    } failure:^(__kindof YTKBaseRequest *request) {
                        [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
                         PERFORM_BLOCK_SAFELY(locateThen, nil);
                    }];
                    
                    
            }
                else
                {

                    [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
                    PERFORM_BLOCK_SAFELY(locateThen, nil);
                }
            }];
        }
        else
        {

            [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
            PERFORM_BLOCK_SAFELY(locateThen, nil);
        }
    };
    
    [locationService startLocation];
}

-(NSMutableArray *)cityies {
    if (!_cityies) {
        _cityies = [NSMutableArray array];
    }
    return _cityies;
}


- (RegionModel *)cityWithName:(NSString *)cityname
{
    __block RegionModel * city = nil;
   // RegionModel * city = nil;
    
    //if ( cityname )
   // {
        
        [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
        GetCityListAPI *getCityListApi = [[GetCityListAPI alloc]init];
        
        [getCityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissTips];
            [self.cityies removeAllObjects];
            NSDictionary *result1 = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result1] && [result1[@"result"] intValue] == 0) {
                NSDictionary *content = result1[@"content"];
                if (![ISNull isNilOfSender:content]) {
                    NSArray *list = content[@"regions"];
                    for (NSDictionary *dic in list) {
                        RegionModel *region = [RegionModel mj_objectWithKeyValues:dic];
                        [self.cityies addObject:region];
                    }
                    
                    
                    for (RegionModel *regionModel in self.cityies) {
                        if ([cityname containsString:regionModel.name] || [regionModel.name containsString:cityname]) {
                            city = regionModel;
                        }
                    }
                    
                    if (city == nil) {
                        if (self.cityies.count > 0) {
                            city = self.cityies[0];
                        }else{
                            
                            city.name = cityname;
                        }
                    }
                    
                    //city.name = [NSString stringWithFormat:@"%@",result.addressDetail.city];
                    //self.currentCity = city;
                    //self.selectCity = city;
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:GetReverseCodeSucceedNotification object:nil];
                    //PERFORM_BLOCK_SAFELY(locateThen, city);
                }
            }else{
                [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
        }];
   // }
//else{
        
    //}
    
    return city;
}

- (void)setSelectCity:(RegionModel *)selectCity
{
    if ( _selectCity == selectCity )
    {
        return;
    }
    
    _selectCity = selectCity;
    
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    
    [STICache.global setObject:selectCity forKey:[NSString stringWithFormat:@"crcclocation_selectcity_%@",user.mobile]];
}


- (RegionModel *)currentCity
{
    if ( _currentCity == nil )
    {
        [self locateThen:nil];
    }
    return _currentCity;
}

+ (BOOL)canLocate
{
    return [[BaiduLocation sharedLocation] canLocate];
}


@end
