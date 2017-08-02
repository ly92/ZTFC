//
//  UIView+FKAutoLayout.h
//  gaibianjia
//
//  Created by QFish on 9/16/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef LessThanOrEqual
#define LessThanOrEqual
#undef  LessThanOrEqual
#endif
#ifndef Equal
#define Equal
#undef  Equal
#endif
#ifndef GreaterThanOrEqual
#define GreaterThanOrEqual
#undef  GreaterThanOrEqual
#endif

#ifndef Left
#undef  Left
#define Left
#endif
#ifndef Right
#undef  Right
#define Right
#endif
#ifndef Top
#undef  Top
#define Top
#endif
#ifndef Bottom
#undef  Bottom
#define Bottom
#endif
#ifndef Leading
#undef  Leading
#define Leading
#endif
#ifndef Trailing
#undef  Trailing
#define Trailing
#endif
#ifndef Width
#undef  Width
#define Width
#endif
#ifndef Height
#undef  Height
#define Height
#endif
#ifndef CenterX
#undef  CenterX
#define CenterX
#endif
#ifndef CenterY
#undef  CenterY
#define CenterY
#endif
#ifndef Baseline
#undef  Baseline
#define Baseline
#endif
#ifndef LastBaseline
#undef  LastBaseline
#define LastBaseline
#endif
#ifndef FirstBaseline
#undef  FirstBaseline
#define FirstBaseline
#endif

#ifndef LeftMargin
#undef  LeftMargin
#define LeftMargin
#endif
#ifndef RightMargin
#undef  RightMargin
#define RightMargin
#endif
#ifndef TopMargin
#undef  TopMargin
#define TopMargin
#endif
#ifndef BottomMargin
#undef  BottomMargin
#define BottomMargin
#endif
#ifndef LeadingMargin
#undef  LeadingMargin
#define LeadingMargin
#endif
#ifndef TrailingMargin
#undef  TrailingMargin
#define TrailingMargin
#endif
#ifndef CenterXWithinMargins
#undef  CenterXWithinMargins
#define CenterXWithinMargins
#endif
#ifndef CenterYWithinMargins
#undef  CenterYWithinMargins
#define CenterYWithinMargins
#endif

// a.attr = b.attr * n + c

#define FKAutoLayoutPrepare(v) UIView * __xQxFxiXsXh = (v); (v).translatesAutoresizingMaskIntoConstraints = NO;
#define FKAutoLayoutActive(cs) [(__xQxFxiXsXh).superview addConstraints:(cs)]; __xQxFxiXsXh = nil;

#define FKAutoLayoutMakeSize(a, attr1, relation, c) \
[NSLayoutConstraint constraintWithItem:(a) \
                             attribute:NSLayoutAttribute##attr1 \
                             relatedBy:NSLayoutRelation##relation \
                                toItem:(nil) \
                             attribute:NSLayoutAttributeNotAnAttribute \
                            multiplier:1 \
                              constant:(c)]

#define FKAutoLayoutMake(a, attr1, relation, b, attr2, c) \
[NSLayoutConstraint constraintWithItem:(a) \
                             attribute:NSLayoutAttribute##attr1 \
                             relatedBy:NSLayoutRelation##relation \
                                toItem:(b) \
                             attribute:NSLayoutAttribute##attr2 \
                            multiplier:1 \
                              constant:(c)]

#define FKAutoLayoutMakeM(a, attr1, relation, b, attr2, n, c) \
[NSLayoutConstraint constraintWithItem:(a) \
                             attribute:NSLayoutAttribute##attr1 \
                             relatedBy:NSLayoutRelation##relation \
                                toItem:(b) \
                             attribute:NSLayoutAttribute##attr2 \
                            multiplier:(n) \
                              constant:(c)]


#define TO_STRING(x) TO_STRING1(x)
#define TO_STRING1(x) #x

@interface UIView (FKAutoLayout)

- (NSArray *)autoFillSuperView;
- (NSArray *)autoFillSuperViewWithInsets:(UIEdgeInsets)insets;

@end
