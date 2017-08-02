//
//  ServiceLocation.m
//  quchicha
//
//  Created by liuyadi on 15/10/14.
//  Copyright © 2015年 Geek Zoo Studio. All rights reserved.
//

#import "ServiceLocation.h"
#import "ServiceLocationConvertor.h"

NSString * const ServiceLocationGetLocationSucceedNotification = @"ServiceLocationGetLocationSucceedNotification";
NSString * const ServiceLocationGetLocationFailNotification = @"ServiceLocationGetLocationFailNotification";
NSString * const ServiceLocationReverseLocationSucceedNotification = @"ServiceLocationReverseLocationSucceedNotification";
NSString * const ServiceLocationReverseLocationFailNotification = @"ServiceLocationReverseLocationFailNotification";

@interface ServiceLocation()

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder * geoCoder;

@end

@implementation ServiceLocation

static ServiceLocation * sharedLoaction = nil;

+ (ServiceLocation *)sharedLocation
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedLoaction = [[self alloc] init];
    });
    
    return sharedLoaction;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // 精度设置
        
        self.location = [STICache.global objectForKey:@"ServiceLocation.location"];
        
        self.isContinuous = NO;
    }
    return self;
}

- (void)startLocation
{
    if ( [CLLocationManager locationServicesEnabled] )
    {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        if ( self.whenGetLocation )
        {
            self.whenGetLocation(nil, nil);
        }
    }
    
    if( [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] )
    {
        [self.locationManager requestWhenInUseAuthorization]; //使用中授权
    }
}

- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (void)reverseGeocodingLocation:(CLLocation *)location then:(void (^)(id placemark, NSError * e))then
{
    if ( !self.geoCoder )
    {
        // 系统自带的 把经纬度 转换为 地址，
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if ( !error && placemarks.count )
        {
            CLPlacemark * placemark = [placemarks lastObject];
            if ( placemark )
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ServiceLocationReverseLocationSucceedNotification object:nil];
                if ( then )
                {
                    then(placemark, nil);
                }
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ServiceLocationReverseLocationFailNotification object:nil];
            if ( then )
            {
                then(nil, error);
            }
        }
    }];
}

# pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    switch ( [error code] )
    {
        case kCLErrorDenied:
        {
//            NSString * errorString = @"定位服务未开启";
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceLocationGetLocationFailNotification object:nil];
    
    if ( self.whenGetLocation )
    {
        self.whenGetLocation(nil, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if ( !self.isContinuous )
    {
        [manager stopUpdatingLocation];
    }
    
    CLLocation * currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    
    switch (self.locationMode)
    {
        case ServiceLocationSystemModeWGS84:
        {
            break;
        }
        case ServiceLocationSystemModeGCJ02:
        {
            coordinate = ConvertLocationFromWGS84ToGCJ02(coordinate);
            break;
        }
        case ServiceLocationSystemModeBD09LL:
        {
            coordinate = ConvertLocationFromWGS84ToGCJ02(coordinate);
            coordinate = ConvertLocationFromGCJ02ToBD09LL(coordinate);
            break;
        }
    }
    
    self.location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [STICache.global setObject:self.location forKey:@"ServiceLocation.location"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceLocationGetLocationSucceedNotification object:nil];
    
    if ( self.whenGetLocation )
    {
        self.whenGetLocation(currentLocation, nil);
    }
}

- (BOOL)canLocate;
{
    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied )
    {
        return NO;
    }
    return YES;
}

@end
