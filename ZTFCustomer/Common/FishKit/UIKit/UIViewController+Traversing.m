//
//  UIViewController+Traversing.m
//  iMeetX
//
//  Created by QFish on 9/19/14.
//  Copyright (c) 2014 QFish. All rights reserved.
//

#import "UIViewController+Traversing.h"

@implementation UIViewController (Traversing)

- (UIViewController *)previousViewController
{
    UINavigationController * nav = self.navigationController;
    if ( nav )
    {
        NSArray * controllers = nav.viewControllers;
        if ( 0 == controllers.count )
            return nil;
        
        NSInteger index = [controllers indexOfObject:self];
        if ( NSNotFound == index )
            return nil;
        
        if ( index > 0 )
        {
            return [controllers objectAtIndex:(index - 1)];
        }
    }
    
    return nil;
}

- (UIViewController *)nextViewController
{
    UINavigationController * nav = self.navigationController;
    if ( nav )
    {
        NSArray *	controllers = nav.viewControllers;
        NSInteger	index = [controllers indexOfObject:self];
        
        if ( controllers.count > 1 && (index + 1) < controllers.count )
        {
            return [controllers objectAtIndex:(index + 1)];
        }
    }
    
    return nil;
}

@end
