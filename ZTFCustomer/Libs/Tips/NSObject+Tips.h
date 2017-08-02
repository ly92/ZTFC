//
//  NSObject+Tips.h
//  Foomoo
//
//  Created by QFish on 6/6/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - UIView

@interface UIView (Tips)

- (void)presentMessageTips:(NSString *)message;
- (void)presentSuccessTips:(NSString *)message;
- (void)cLPresentSuccessTips:(NSString *)message;
- (void)presentFailureTips:(NSString *)message;
- (void)presentLoadingTips:(NSString *)message;

- (void)dismissTips;

@end

#pragma mark - UIViewController

@interface UIViewController (Tips)

- (void)presentMessageTips:(NSString *)message;
- (void)presentSuccessTips:(NSString *)message;
- (void)cLPresentSuccessTips:(NSString *)message;
- (void)presentFailureTips:(NSString *)message;
- (void)presentLoadingTips:(NSString *)message;

- (void)dismissTips;

@end
