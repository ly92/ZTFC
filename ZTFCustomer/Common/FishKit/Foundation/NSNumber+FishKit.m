//
//  NSNumber+FishKit.m
//  xueyou
//
//  Created by QFish on 7/11/15.
//  Copyright (c) 2015 QFish. All rights reserved.
//

#import "NSNumber+FishKit.h"

@implementation NSNumber (FishKit)

- (NSString *)currencyString
{
	static NSNumberFormatter * formatter = nil;
	
	if ( !formatter )
	{
		formatter = [[NSNumberFormatter alloc]init];
		[formatter setGroupingSeparator:@","];
		[formatter setGroupingSize:3];
		[formatter setUsesGroupingSeparator:YES];
	}
	
	return [formatter stringFromNumber:self];
}

@end
