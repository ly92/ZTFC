//
//  AppLocation.h
//  gaibianjia
//
//  Created by PURPLEPENG on 9/21/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentModel.h"

#pragma mark -

FOUNDATION_EXTERN NSString *const GetLocationSucceedNotification;
FOUNDATION_EXTERN NSString *const GetReverseCodeSucceedNotification;
FOUNDATION_EXTERN NSString *const DidChangeCurrentLocationNotification;

#pragma mark -

@interface AppLocation : NSObject

@property (nonatomic, strong, readonly) Location * location;

@property (nonatomic, strong) RegionModel *currentCity;
@property (nonatomic, strong) RegionModel *selectCity;

@singleton( AppLocation )

//-(void)locateWithCities:(NSArray *)cities then:(void (^)(RegionModel * city))locateThen;
- (void)locateThen:(void (^)(RegionModel * city))locateThen;
+ (BOOL)canLocate;

@end
