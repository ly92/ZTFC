//
//  NSObject+FKNotification.m
//  Fadein
//
//  Created by QFish on 1/22/15.
//  Copyright (c) 2015 Arceus. All rights reserved.
//

#import "NSObject+FKNotification.h"

@implementation NSObject (FKNotification)

- (void)fk_postNotification:(NSString *)notification
{
    [self fk_postNotification:notification object:nil];
}

- (void)fk_postNotification:(NSString *)notification object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object];
}

- (id <NSObject>)fk_observeNotifcation:(NSString *)name usingBlock:(void (^)(NSNotification *note))block
{
    return [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

- (void)fk_removeObserver:(id<NSObject>)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
