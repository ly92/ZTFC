//
//  UILabel+helper.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UILabel(helper)
-(void)textLocalizedText:(NSString *)text;
-(void)autoCalculateTextViewFrame;

//返回高度
-(CGFloat)resizeHeight;

//返回宽度
-(CGFloat)resizeWidth;


@end
