//
//  UIViewController+Traversing.h
//  iMeetX
//
//  Created by QFish on 9/19/14.
//  Copyright (c) 2014 QFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Traversing)
@property (nonatomic, readonly) UIViewController * previousViewController;
@property (nonatomic, readonly) UIViewController * nextViewController;
@end
