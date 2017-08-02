//
//  UIViewController+Container.h
//  Common
//
//  Created by QFish on 8/7/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Container)
- (void)displayChildViewController:(UIViewController*)childViewController;
- (void)hideChildViewController:(UIViewController*)childViewController;
@end
