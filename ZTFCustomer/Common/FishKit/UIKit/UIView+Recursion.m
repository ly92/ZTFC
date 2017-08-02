//
//  UIView+Recursion.m
//  gaibianjia
//
//  Created by QFish on 6/18/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "UIView+Recursion.h"

@implementation UIView (Recursion)

- (void)fk_walkThroughUsingBlock:(void (^)(id obj))block
{
	if ( block ) {
		block(self);
	}
	
	[self.subviews enumerateObjectsWithOptions:NSEnumerationReverse
									usingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
										[subview fk_walkThroughUsingBlock:block];
									}];
}

@end