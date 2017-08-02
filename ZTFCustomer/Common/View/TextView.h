//
//  TextView.h
//  quchicha
//
//  Created by liuyadi on 15/9/9.
//  Copyright (c) 2015年 Vicky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView
@property (nonatomic, copy) NSString * placehoder;
@property (nonatomic, assign) CGFloat placeholderX;
-(float)resizeFrameWithWithText;
@end
