//
//  UIDevice+Reachability.h
//  CardToon
//
//  Created by Austin on 7/18/13.
//  Copyright (c) 2013 com.coortouch.ender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Reachability)

+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSData *) dataFromAddress: (struct sockaddr_in) address;
+ (NSString *) addressFromData:(NSData *) addressData;
+ (NSString *) portFromData:(NSData *) addressData;


- (NSString *) hostname;
- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (NSString *) localIPAddress;
- (NSString *) localWiFiIPAddress;
+ (NSArray *) localWiFiIPAddresses;
- (NSString *) whatismyipdotcom;

- (BOOL) hostAvailable: (NSString *) theHost;
- (BOOL) networkAvailable;
- (BOOL) activeWLAN;
- (BOOL) activeWWAN;
- (BOOL) performWiFiCheck;

//- (BOOL) forceWWAN; // via Apple
//- (void) shutdownWWAN; // via Apple

- (BOOL) scheduleReachabilityWatcher: (id) watcher;
- (void) unscheduleReachabilityWatcher;
@end
