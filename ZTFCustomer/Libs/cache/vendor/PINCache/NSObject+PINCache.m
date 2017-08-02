//
//  NSObject+PINCache.m
//  marathon
//
//  Created by PURPLEPENG on 8/19/15.
//  Copyright (c) 2015 PURPLEPENG. All rights reserved.
//

#import "NSObject+PINCache.h"
#import "PINCache.h"

@implementation NSObject (PINCache)

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key
{
    [[PINCache sharedCache].diskCache setObject:object forKey:key];
}

- (id <NSCoding>)objectForKey:(NSString *)key
{
    return [[PINCache sharedCache].diskCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [[PINCache sharedCache] removeObjectForKey:key];
}

@end
