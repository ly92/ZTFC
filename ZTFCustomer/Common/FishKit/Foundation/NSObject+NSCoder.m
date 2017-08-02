//
//  NSObject+KeyedArchiver.m
//  Foomoo
//
//  Created by QFish on 7/19/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "NSObject+NSCoder.h"

@implementation NSObject (NSCoder)

- (NSData *)archivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)objectFromArchivedData:(NSData *)data
{
    if ( data )
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}
@end
