//
//  UIDevice+MacAddress.h
//  CardToon
//
//  Created by Austin on 7/18/13.
//  Copyright (c) 2013 com.coortouch.ender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MacAddress)

- (NSString *) macAddress:(NSString *)delimiter;
- (NSString *)uniqueDeviceIdentifier;
@end
