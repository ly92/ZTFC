//
//  test.m
//  mplus
//
//  Created by Chenyun on 14-10-13.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "NSData+Md5.h"

typedef uint32_t CC_LONG;

extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);

@implementation NSData (Md5)
- (NSData *)sti_MD5
{
	unsigned char	md5Result[16 + 1];
	CC_LONG			md5Length = (CC_LONG)[self length];
	
	CC_MD5( [self bytes], md5Length, md5Result );

	NSMutableData * retData = [[NSMutableData alloc] init];
	if ( nil == retData )
		return nil;
	
	[retData appendBytes:md5Result length:16];
	return retData;
}
@end
