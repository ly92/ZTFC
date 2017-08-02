//
//  STICache.m
//  fomo
//
//  Created by QFish on 3/20/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "STICache.h"
#import "PINCache.h"

@interface STICache ()
@property (nonatomic, readonly) STICache * sharedCache;
@property (nonatomic, strong) PINCache * cache;
@property (nonatomic, strong) NSString * rootPath;
- (STICache *)sharedCache;
+ (STICache *)sharedCache;
@end

@implementation STICache

@dynamic sharedCache;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return self;
}

- (STICache *)sharedCache
{
    return [STICache sharedCache];
}

+ (STICache *)sharedCache
{
    static dispatch_once_t once;
    static __strong id __singleton__ = nil;
    dispatch_once( &once, ^{ __singleton__ = [[STICache alloc] init]; } );
    return __singleton__;
}

+ (NSString *)cacheName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (instancetype)global
{
    static dispatch_once_t once;
    static __strong STICache * global = nil;
    dispatch_once( &once, ^{
        global = [[STICache alloc] init];
        global.cache = [[PINCache alloc] initWithName:[self cacheName] rootPath:global.rootPath];
    } );
    return global;
}

- (void)switchCacheWithName:(NSString *)name
{
    if ( !name ) {
        name = @"default";
    }
    
    self.cache = [[PINCache alloc] initWithName:name rootPath:self.rootPath];
}

#pragma mark -

- (void)setObject:(id <NSCoding, NSObject>)object forKey:(NSString *)key
{
    if ( !object )
        return;
    
    NSParameterAssert( [object respondsToSelector:@selector(initWithCoder:)] && [object respondsToSelector:@selector(encodeWithCoder:)] );
    
    [self.cache.diskCache setObject:(id<NSCoding>)object forKey:key];
}

- (id <NSCoding>)objectForKey:(NSString *)key
{
    return [self.cache.diskCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [self.cache.diskCache removeObjectForKey:key];
}

#pragma mark -

+ (void)switchCacheWithName:(NSString *)name
{
    [[self sharedCache] switchCacheWithName:name];
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
    // TODO("needs check null?")
//    if ([key containsString:@"null"])
//    {
//        
//    }
    [[self sharedCache] setObject:object forKey:key];
}

+ (id)objectForKey:(NSString *)key
{
    // TODO("needs check null?")
//    if ([key containsString:@"null"])
//    {
//        
//    }
    return [[self sharedCache] objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    return [[self sharedCache] removeObjectForKey:key];
}

@end
