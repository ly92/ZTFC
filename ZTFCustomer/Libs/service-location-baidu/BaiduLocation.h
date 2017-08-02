//
//  BaiduLocation.h
//  quchicha
//
//  Created by liuyadi on 15/10/20.
//  Copyright © 2015年 Geek Zoo Studio. All rights reserved.
//

#import "ServiceLocation.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface BaiduLocation : ServiceLocation

- (void)setupWithKey:(NSString *)key delegate:(id)delegate;

@end
