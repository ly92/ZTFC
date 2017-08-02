//
//  HuanxinService.h
//  EstateBiz
//
//  Created by Ender on 4/25/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSDK.h"


#define kHuanxinConversationChanged @"HuanxinConversationChanged"

@interface HuanxinService : NSObject<EMClientDelegate,EMChatManagerDelegate>

+(HuanxinService *)shareInstance;

-(void)configHuanxinApplication:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                         appkey:(NSString *)appkey
                   apnsCertName:(NSString *)apnsCertName;

- (void)binDeviceToken:(NSData *)deviceToken;
-(void)login;
-(void)logout;

@end
