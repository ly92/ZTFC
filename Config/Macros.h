//
//  Macros.h
//  EstateBiz
//
//  Created by Ender on 10/20/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#pragma mark - include 辅助类

//#import "UIView+Helper.h"
#import "UIDevice+Reachability.h"
#import "ISNull.h"
#import "NSString+helper.h"
#import "UIDevice+Additions.h"
#import "UIDevice+Hardware.h"
#import "UIDevice+MacAddress.h"
#import "UILabel+helper.h"
#import "UITextField+helper.h"
#import "UITextView+helper.h"
#import "UIButton+helper.h"
#import "UIDatePickerSheetController.h"
#import "UITableView+RemoveExcessLine.h"
#import "FishKit.h"
#import "APPTheme.h"
#import "CountdownButton.h"
#import "UIView+Data.h"
#import "UIViewController+TableView.h"
#import "STICache.h"
#import "NSObject+Tips.h"
#import "UIView+Extension.h"
#import "TextView.h"


/**
 * 通用的配置宏
 *
 */


#ifndef Macros_h
#define Macros_h


/**
 是否为App Store版本 0 企业版本  1 App Store版本
 */
#define IS_APPSTORE 1

//隐藏tabbar
#define HIDETABBAR if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {\
[[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];\
}
//显示tabbar
#define SHOWTABBAR if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {\
[[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];\
}

/**
 *屏幕宽高
 *
 */
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  颜色
 *
 */

#define COLORWITHRGB(red,green,blue,alpha) [UIColor colorWithRed:((float)(red))/255.0f green:((float)(green))/255.0f blue:((float)(blue))/255.0f alpha:((float)(alpha))]

#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


/**
 *  系统版本
 *
 */

#define IOS_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define GT_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10
#define GT_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9
#define GT_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
#define GT_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#define GT_IOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6
#define GT_IOS5 [[[UIDevice currentDevice] systemVersion] floatValue] >= 5

/*
*IS_IPHONE_5 （IPhone5判断）
*/

#define IPHONE_5_HEIGHT IS_IPHONE_5 ? 88 : 0
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height>=1136) : NO)
#define STATUS_BAR_OFFSET ( GT_IOS7 ? 20.0 : 0.0)



/*
 *COMMON (通用)
*/

#define DOCUMENTS_PATH      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define APP_PATH            [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] bundlePath]]
#define CLEAR_TEXT(__TEXT) { if (__TEXT.text != nil && [__TEXT.text trim].length != 0) { __TEXT.text = @"";}; }


/*
 *语言
 */

#define SYSTEMLANGUAGE			[NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]]

#define NSLocalizedStr(key, comment) \
[[LanguageManager bundle] localizedStringForKey:(key) value:@"" table:nil]


#define IS_CHINESE                         [SYSTEMLANGUAGE isEqualToString:@"zh-Hans"]
#define IS_JAPANESE                        [SYSTEMLANGUAGE isEqualToString:@"ja"]
#define IS_ENGLISH                         [SYSTEMLANGUAGE isEqualToString:@"en"]

#define CHINESE                         @"zh-Hans"
#define JAPANESE                        @"ja"
#define ENGLISH                         @"en"


/*
 *（计算）
*/
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

/*
 *VIEW FRAME （视图的坐标）
*/
#define ViewWidth(a) a.frame.size.width
#define ViewHeight(a) a.frame.size.height
#define ViewTop(a) a.frame.origin.y
#define ViewLeft(a) a.frame.origin.x
#define FrameReposition(a,x,y) a.frame = CGRectMake(x, y, width(a), height(a))
#define FrameResize(a,w,h) a.frame = CGRectMake(left(a), top(a), w, h)
#define debugRect(rect) LOG(@"%s x:%.4f, y:%.4f, w:%.4f, h%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define debugSize(size) LOG(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define debugPoint(point) LOG(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

/*
 *SAFELY RELSEASE
 */

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define AUTORELEASE_SAFELY(__POINTER) { [__POINTER autorelease]; __POINTER = nil; }
#define RELEASE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

/*
 *LOG （日志）
 */

#define MARK	CFShow([NSString stringWithFormat:@"%s [%d]", __FUNCTION__, __LINE__]);

#if TARGET_IPHONE_SIMULATOR

#define LOG(format, ...) \
CFShow([NSString stringWithFormat:@"%s[%d] : %@", \
__PRETTY_FUNCTION__,  __LINE__ ,\
[NSString stringWithFormat:format, ## __VA_ARGS__] ]);
#define Log(format, ...) \
NSLog([NSString stringWithFormat:@"%@%d: %@", \
[[[NSString alloc] initWithBytes:__FILE__ length:strlen(__FILE__) encoding:NSUTF8StringEncoding] lastPathComponent] ,\
__LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__]]);
#define ASSERT(STATEMENT) do { assert(STATEMENT); } while(0)

#else

#define LOG(format, ...)
#define Log(format, ...)
#define ASSERT(STATEMENT) do { (void)sizeof(STATEMENT);} while(0)

#endif

#endif /* Macros_h */




