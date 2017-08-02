//
//  UIViewController+TransparentUINavigationbar.h
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TransparentUINavigationbar)
/**
 *  Transparent current ViewController's UINavigationbar
 *  Call in `viewDidLoad` function
 *  @param transparent
 */
- (void)setNavigationBarTransparent:(BOOL)transparent;

/**
 *  Transparent all ViewController's UINavigationbar
 *  Call in `appDidFinishLanched:` function
 *  @param transparent
 */
+ (void)setNavigationBarTransparent:(BOOL)transparent;

@end
