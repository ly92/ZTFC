//
//  UITableViewNoSepratorCell.m
//  gaibianjia
//
//  Created by QFish on 6/18/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "UITableViewNoSepratorCell.h"

#pragma mark -

@interface UIView (_UITableViewNoSepratorCellPrivate)
- (void)_removeAllSeparator;
@end

@implementation UIView (_UITableViewNoSepratorCellPrivate)

- (void)_removeAllSeparator
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        [subview _removeAllSeparator];
    }];
    
    if ( [self isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")] ) {
        [self removeFromSuperview];
    }
}

@end

#pragma mark -

@interface UITableViewNoSepratorCell ()
@end

@implementation UITableViewNoSepratorCell

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    [self _removeAllSeparator];
}

@end
