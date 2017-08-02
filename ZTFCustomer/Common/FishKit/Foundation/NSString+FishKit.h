//
//  NSString+FishKit.h
//  Common
//
//  Created by QFish on 8/10/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FishKit)

- (NSString *)fk_MD5;
- (NSString *)fk_currencyString;

- (NSString *)fk_trim;

- (NSString *)stringWithNum:(NSString *)string;

- (NSArray *)matchedPoundStringRange;

- (NSAttributedString *)matchedPoundStringWithFont:(float)font textColor:(UIColor *)color;

- (float)heightWithWidth:(float)width font:(float)font;

- (float)widthWithheight:(float)height font:(float)font;

- (NSInteger)multipleNameLength;

@end
