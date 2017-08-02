//
//  UIView+Data.h
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Data)

@property (nonatomic, strong) id data;

- (void)dataDidChange;
- (void)dataWillChange;

@end
