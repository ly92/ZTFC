//
//  NSString+helper.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helper)
- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b;

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts;

- (NSString*)trim;

- (BOOL)startsWith:(NSString*)s;

- (BOOL)containsString:(NSString*)aString;

- (NSString*)urlEncode;


- (BOOL) isEmail;

//判断手机号码的合法性
- (BOOL)isMobileNumber;

//判断图片是否合法
- (BOOL)complyWithTheRulesOfImage;

- (BOOL)validateIdentityCard;

//-(void)insertSearchSuggestion;

-(NSMutableDictionary *)separatedByJinAndAnte;

//处理电话号码(加***)
-(NSString *)handleMobile;

//提取拼音
//-(NSString *)pickUpPinYingName;

//判断字符串是否为纯数字
-(BOOL)isNumText;


//判断一个正整数是几位数
- (int)judgePositiveIntegerNumberOfDigits;

//判断是否网址
-(BOOL)isURL;

//短随机数
+(NSString *)randString;

//长随机数
+(NSString *)randStringLong;


//md5
- (NSString *)MD5Hash;
@end
