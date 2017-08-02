//
//  NSObject+FKNotification.h
//  Fadein
//
//  Created by QFish on 1/22/15.
//  Copyright (c) 2015 Arceus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FKNotification)
- (void)fk_postNotification:(NSString *)notification;
- (void)fk_postNotification:(NSString *)notification object:(id)object;
- (id <NSObject>)fk_observeNotifcation:(NSString *)name usingBlock:(void (^)(NSNotification *note))block;
- (void)fk_removeObserver:(id <NSObject>)observer;
@end
