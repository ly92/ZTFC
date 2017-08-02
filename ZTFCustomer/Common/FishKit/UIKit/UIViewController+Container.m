//
//  UIViewController+Container.m
//  Common
//
//  Created by QFish on 8/7/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import "UIViewController+Container.h"

@implementation UIViewController (Container)

- (void)displayChildViewController:(UIViewController*)childViewController
{
	[childViewController willMoveToParentViewController:self];
	childViewController.view.frame = self.view.bounds;
	[self.view addSubview:childViewController.view];
	[self addChildViewController:childViewController];
	[childViewController didMoveToParentViewController:self];
}

- (void)hideChildViewController:(UIViewController*)childViewController
{
	[childViewController willMoveToParentViewController:nil];
	[childViewController.view removeFromSuperview];
	[childViewController removeFromParentViewController];
	[childViewController didMoveToParentViewController:nil];
}

@end
