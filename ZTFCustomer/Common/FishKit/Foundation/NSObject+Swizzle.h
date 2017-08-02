//
//  NSObject+Swizzle.h
//  Common
//
//  Created by QFish on 8/24/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
+ (void *)swizz:(Class)clazz selector:(SEL)sel1 with:(SEL)sel2;
@end
