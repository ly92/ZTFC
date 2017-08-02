//
//  ScanView.h
//  gaibianjia
//
//  Created by PURPLEPENG on 9/17/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView

@property (nonatomic, assign) BOOL animating;

- (void)startAnimation;
- (void)stopAnimation;

@end
