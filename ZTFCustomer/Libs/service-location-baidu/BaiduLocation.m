//
//  BaiduLocation.m
//  quchicha
//
//  Created by liuyadi on 15/10/20.
//  Copyright © 2015年 Geek Zoo Studio. All rights reserved.
//

#import "BaiduLocation.h"
#import "MMBProgressHUD.h"

@interface BaiduLocation()<BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch * geoSearch;
@property (nonatomic, strong) BMKMapManager * mapManager;
@property (nonatomic, copy) void (^then)(id, NSError * e);

@end

@implementation BaiduLocation

- (void)setupWithKey:(NSString *)key delegate:(id)delegate
{
    self.mapManager = [[BMKMapManager alloc] init];
    [self.mapManager start:key generalDelegate:delegate];
}

- (void)dealloc
{
    self.geoSearch.delegate = nil;
}

- (void)reverseGeocodingLocation:(CLLocation *)location then:(void (^)(id, NSError * e))then
{
    if ( !self.geoSearch )
    {
        self.geoSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoSearch.delegate = self;
    }
    
    BMKReverseGeoCodeOption * reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
    [self.geoSearch reverseGeoCode:reverseGeocodeSearchOption];
    
    self.then = then;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    [MMBProgressHUD hideHUDForView:[AppDelegate sharedAppDelegate].window.rootViewController.view animated:YES];
    
    NSError * e;
    
    if ( BMK_SEARCH_NO_ERROR != error )
    {
        e = [NSError errorWithDomain:@"ServiceLocation.baidu" code:error userInfo:nil];
    }
    
    if ( self.then )
    {
        self.then(result, e);
    }
}

@end
