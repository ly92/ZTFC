//
//  FishKitMacros.h
//  Foomoo
//
//  Created by QFish on 4/28/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#ifndef	IN
#define IN
#endif

#ifndef	OUT
#define OUT
#endif

#ifndef	INOUT
#define INOUT
#endif

#pragma mark -

#undef  singleton
#define singleton( __class ) \
    property (nonatomic, readonly) __class * sharedInstance; \
    - (__class *)sharedInstance; \
    + (__class *)sharedInstance;

#undef  def_singleton
#define def_singleton( __class ) \
    dynamic sharedInstance; \
    - (__class *)sharedInstance \
    { \
      return [__class sharedInstance]; \
    } \
    + (__class *)sharedInstance \
    { \
      static dispatch_once_t once; \
      static __strong id __singleton__ = nil; \
      dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
      return __singleton__; \
    }

#pragma mark - BLOCK

#undef  PERFORM_BLOCK_SAFELY
#define PERFORM_BLOCK_SAFELY( b, ... ) if ( (b) ) { (b)(__VA_ARGS__); }

#undef  dispatch_main_sync_safe
#define dispatch_main_sync_safe(block) if ([NSThread isMainThread]) { block(); \
} else { dispatch_sync(dispatch_get_main_queue(), block); }

#undef  dispatch_main_async_safe
#define dispatch_main_async_safe(block) if ([NSThread isMainThread]) { block(); \
} else { dispatch_async(dispatch_get_main_queue(), block); }