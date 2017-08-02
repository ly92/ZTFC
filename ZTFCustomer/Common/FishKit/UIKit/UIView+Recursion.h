//
//  UIView+Recursion.h
//  gaibianjia
//
//  Created by QFish on 6/18/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Recursion)
- (void)fk_walkThroughUsingBlock:(void (^)(id obj))block;
@end
