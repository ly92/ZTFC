//
//  UIImage+FishKit.h
//  Foomoo
//
//  Created by purplepeng on 14-6-7.
//  Copyright (c) 2014年 QFish.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FishKit)

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)fixedLibraryImageToSize:(CGSize)size;
- (UIImage *)fixedCameraImageToSize:(CGSize)size;

- (UIImage *)fixOrientation;

- (void)fixedCameraImageToSize:(CGSize)size then:(void (^)(NSData *))then;

@end
