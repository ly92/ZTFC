//
//  STICache.h
//  fomo
//
//  Created by QFish on 3/20/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STICache : NSObject

+ (instancetype)global;

+ (void)switchCacheWithName:(NSString *)key;

+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

@end
