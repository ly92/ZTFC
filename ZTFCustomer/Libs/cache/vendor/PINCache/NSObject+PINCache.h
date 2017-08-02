//
//  NSObject+PINCache.h
//  marathon
//
//  Created by PURPLEPENG on 8/19/15.
//  Copyright (c) 2015 PURPLEPENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PINCache)

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;
- (id <NSCoding>)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end
