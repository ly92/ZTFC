//
//  UIButton+helper.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ImagePosition) {
    NOSTYLE = 0,
    LEFTSTYLE = 1,
    RIGHTSTYLE = 2,
    TOPSTYLE = 3,
    BOTTOMSTYLE = 4
};


@interface UIButton(helper)
-(void)bgStrechableNormalImageName:(NSString *)normal SelectedImageName:(NSString *)selected HighlightImageName:(NSString *)highlight NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle HighlightTitle:(NSString *)highLightTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y  Localize:(BOOL)yesOrNo;

//设置文字和图片的相对位置
-(void)buttonSetTitle:(NSString *)title imageStr:(NSString *)imageStr selectImageStr:(NSString *)selectImageStr imagePosition:(ImagePosition)imagePosition;

@end
