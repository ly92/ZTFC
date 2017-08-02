//
//  UIView+Nib.h
//  Foomoo
//
//  Created by QFish on 5/4/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

+ (UINib *)nib;
+ (UINib *)nibWithName:(NSString *)name;

// 在 StoryBoard 或者 XIB 里复用另外一个 XIB
- (void)loadFromNib;

+ (instancetype)loadFromNib;
+ (instancetype)loadFromNib:(NSString *)nibName;

- (void)customize;

@end
