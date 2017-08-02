//
//  UIViewController+Data.m
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "UIViewController+Data.h"
#import <objc/runtime.h>

static const char kUIViewControllerDataKey;

@implementation UIViewController (Data)

@dynamic data;

- (void)setData:(id)data
{
    [self dataWillChange];
    
    objc_setAssociatedObject(self, &kUIViewControllerDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dataDidChange];
}

- (id)data
{
    return objc_getAssociatedObject(self, &kUIViewControllerDataKey);
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
