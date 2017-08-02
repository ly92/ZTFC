//
//  UIScrollView+ReachEnds.h
//  Common
//
//  Created by QFish on 8/23/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ReachEnds)
- (void)scrollToHorizonalEndAnimated:(BOOL)animated;
- (void)scrollToVerticalEndAnimated:(BOOL)animated;
@end
