//
//  ChatUserManager.h
//  EstateBiz
//
//  Created by Ender on 4/27/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChatUser.h"

@interface ChatUserManager : NSObject

+(ChatUserManager *)shareInstance;

-(void)saveChatUser:(ChatUser *)user;
-(void)saveChatUserByIm:(NSString *)im;
-(ChatUser *)fetchChatUserByIm:(NSString *)im;

@end
