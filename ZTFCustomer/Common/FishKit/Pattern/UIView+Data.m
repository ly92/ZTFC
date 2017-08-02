//
//  UIView+Data.m
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "UIView+Data.h"
#import <objc/runtime.h>

static const char kUIViewDataKey;

@implementation UIView (Data)

@dynamic data;

- (void)setData:(id)data
{
    [self dataWillChange];
    
    objc_setAssociatedObject(self, &kUIViewDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dataDidChange];
}

- (id)data
{
    return objc_getAssociatedObject(self, &kUIViewDataKey);
}

- (void)dataDidChange
{
    // to implement
}

- (void)dataWillChange
{
    // to implement
}

@end
