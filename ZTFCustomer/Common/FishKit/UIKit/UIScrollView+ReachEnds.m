//
//  UIScrollView+ReachEnds.m
//  Common
//
//  Created by QFish on 8/23/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import "UIScrollView+ReachEnds.h"

@implementation UIScrollView (ReachEnds)

- (void)scrollToHorizonalEndAnimated:(BOOL)animated
{
    if ( self.frame.size.width < self.contentSize.width ) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0) animated:animated];
    }
}

- (void)scrollToVerticalEndAnimated:(BOOL)animated
{
    if ( self.frame.size.height < self.contentSize.height ) {
        [self setContentOffset:CGPointMake(self.contentSize.height - self.frame.size.height, 0) animated:animated];
    }
}

@end
