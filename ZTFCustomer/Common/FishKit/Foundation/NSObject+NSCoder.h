//
//  NSObject+KeyedArchiver.h
//  Foomoo
//
//  Created by QFish on 7/19/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSCoder)
- (NSData *)archivedData;
+ (instancetype)objectFromArchivedData:(NSData *)data;
@end
