//
//  UIPlaceHolderTextView.h
//  BizKaKaTool
//
//  Created by Austin on 1/14/14.
//  Copyright (c) 2014 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
