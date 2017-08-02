//
//  UITabBarItem+CustomBadge.m
//
//  Created by QFish on 6/29/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <objc/runtime.h>
#import "UITabBarItem+CustomBadge.h"

static const void * kCustomBadgeKey;

@implementation UITabBarItem (CustomBadge)

@dynamic customBadgeValue;

- (UIView *)customBadge
{
	return objc_getAssociatedObject(self, &kCustomBadgeKey);
}

- (void)setCustomBadge:(UIView *)customBadge
{
	objc_setAssociatedObject(self, &kCustomBadgeKey, customBadge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCustomBadgeValue:(NSString *)badgeValue
{
	if ( !self.customBadge )
		return;

	if ( self.badgeValue == badgeValue )
		return;
	
	[self setBadgeValue:badgeValue];
	
	if ( badgeValue )
	{
		self.customBadge.hidden = NO;
		
		if ( !self.customBadge.superview )
		{
			UIView * v = [self valueForKey:@"view"];
			
			for( UIView * sv in v.subviews )
			{
				if( [NSStringFromClass([sv class]) isEqualToString:@"_UIBadgeView"] )
				{
					for ( UIView * ssv in sv.subviews )
					{
						if ( [NSStringFromClass([ssv class]) isEqualToString:@"_UIBadgeBackground"] )
						{
							ssv.hidden = YES;
							
							CGPoint center = ssv.center;
							center.x = 0;
							self.customBadge.center = center;
						}
						
						break;
					}
					
					[sv addSubview:self.customBadge];
					
					break;
				}
			}
		}
	}
	else
	{
		self.customBadge.hidden = YES;
	}
}

- (NSString *)customBadgeValue
{
	return self.badgeValue;
}

@end
