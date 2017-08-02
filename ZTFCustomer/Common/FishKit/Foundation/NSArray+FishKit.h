//
//  NSArray+FishKit.h
//  FishKit
//
//  Created by QFish on 4/27/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSMutableArray

@interface NSMutableArray(BeeExtension)

+ (NSMutableArray *)nonRetainingArray;			// copy from Three20

@end