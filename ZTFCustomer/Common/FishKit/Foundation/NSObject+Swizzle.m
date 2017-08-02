//
//  NSObject+Swizzle.m
//  Common
//
//  Created by QFish on 8/24/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (void *)swizz:(Class)clazz selector:(SEL)sel1 with:(SEL)sel2
{
    Method method;
    IMP implement;
    IMP implement2;
    
    method = class_getInstanceMethod( clazz, sel1 );
    implement = (void *)method_getImplementation( method );
    implement2 = class_getMethodImplementation( clazz, sel2 );
    method_setImplementation( method, implement2 );
    
    return implement;
}

@end
