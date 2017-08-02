//
//  NSString+FishKit.m
//  Common
//
//  Created by QFish on 8/10/14.
//  Copyright (c) 2014 iNoknok. All rights reserved.
//

#import "NSString+FishKit.h"
#import "NSData+Md5.h"
#import "NSNumber+FishKit.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (FishKit)

- (NSString*)fk_MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output.uppercaseString;
}

- (NSString *)fk_currencyString
{
    return @([self doubleValue]).currencyString;
}

- (NSString *)fk_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringWithNum:(NSString *)string
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    NSNumber *num= [NSNumber numberWithInt:string.intValue];
    NSString *str = [formatter stringFromNumber:num];
    return str;
}

- (NSAttributedString *)matchedPoundStringWithFont:(float)font textColor:(UIColor *)color
{
	NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString:self];

	[[self matchedPoundStringRange] enumerateObjectsUsingBlock:^(NSTextCheckingResult * obj, NSUInteger idx, BOOL *stop) {
		[attriString addAttributes:@{
									 NSFontAttributeName:[UIFont systemFontOfSize:font],
									 NSForegroundColorAttributeName:color
									 }
							 range:obj.range];
	}];

	return attriString;
}

- (NSArray *)matchedPoundStringRange
{
	NSError *error;
	
	NSString * regulaStr = @"#[^#]+#";
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];

	return [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (float)heightWithWidth:(float)width font:(float)font
{
	// 计算文本的大小
    CGSize sizeToFit;
    if ( GT_IOS7)
    {
        sizeToFit = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}        // 文字的属性
                                       context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    }
    else
    {
        sizeToFit = [self sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    }
    
	return sizeToFit.height;
}

- (float)widthWithheight:(float)height font:(float)font
{
    CGSize sizeToFit;
    if ( GT_IOS7 )
    {
        sizeToFit = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) // 用于计算文本绘制时占据的矩形块
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}        // 文字的属性
                                       context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    }
    else
    {
        sizeToFit = [self sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, height)];
    }
    
	return sizeToFit.width;
}

- (NSInteger)multipleNameLength
{
	NSInteger count = 0;
	
	NSRegularExpression *  iExpression;
	NSString * pattern = @"[^\u4e00-\u9fa5]+";
	iExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
	NSRange paragaphRange = NSMakeRange(0, self.length);
	
	NSArray * matches = [iExpression matchesInString:self options:0 range:paragaphRange];
	if ( matches )
	{
		for (int i = 0; i < matches.count;i++)
		{
			NSTextCheckingResult *result = matches[i];
			count += result.range.length;
		}
	}
	
	NSRegularExpression * iExpression2;
	NSString * pattern2 = @"[\u4e00-\u9fa5]+";
	iExpression2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:NULL];
	
	NSArray * matches2 = [iExpression2 matchesInString:self options:0 range:paragaphRange];
	if ( matches2 )
	{
		for (int i = 0; i < matches2.count;i++)
		{
			NSTextCheckingResult *result = matches2[i];
			count += result.range.length;
		}
	}
	return count;
}

@end
