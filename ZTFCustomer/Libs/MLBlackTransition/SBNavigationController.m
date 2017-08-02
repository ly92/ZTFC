//
//  SBNavigationController.m
//  gaibianjia
//
//  Created by QFish on 7/8/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "SBNavigationController.h"
#import "MLBlackTransition.h"

@implementation SBNavigationController

+ (void)load
{
	[MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypePan
																		   class:self];
}

@end
