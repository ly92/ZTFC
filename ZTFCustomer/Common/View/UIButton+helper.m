//
//  UIButton+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "UIButton+helper.h"
#import "ISNull.h"
#import "Macros.h"
//#import "LanguageManager.h"

@implementation UIButton(helper)


//使用图片拉伸，支持多语言标题
-(void)bgStrechableNormalImageName:(NSString *)normal SelectedImageName:(NSString *)selected HighlightImageName:(NSString *)highlight NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle HighlightTitle:(NSString *)highLightTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y  Localize:(BOOL)yesOrNo
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];

    }
    
    if ([ISNull isNilOfSender:highlight] == NO) {
        UIImage *highlightImg = [UIImage imageNamed:highlight];
        highlightImg = [highlightImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:highlightImg forState:UIControlStateSelected];
    }
    
    if ([ISNull isNilOfSender:selected] == NO) {
        UIImage *selectedImg = [UIImage imageNamed:selected];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:selectedImg forState:UIControlStateSelected];
    }
    
    if (normalTitle) {
        if (yesOrNo) {
//            [self setTitle:NSLocalizedStr(normalTitle, nil) forState:UIControlStateNormal];
        }
        else{
           [self setTitle:normalTitle forState:UIControlStateNormal];
        }
        
    }
    
    if (highLightTitle) {
        if (yesOrNo) {
//            [self setTitle:NSLocalizedStr(highLightTitle, nil) forState:UIControlStateHighlighted];
        }
        else{
            [self setTitle:highLightTitle forState:UIControlStateHighlighted];
        }
    }
    
    
    if (selectedTitle) {
        if (yesOrNo) {
//            [self setTitle:NSLocalizedStr(selectedTitle, nil) forState:UIControlStateSelected];
        }
        else{
            [self setTitle:selectedTitle forState:UIControlStateSelected];
        }
    }
}

//设置文字和图片的相对位置
-(void)buttonSetTitle:(NSString *)title imageStr:(NSString *)imageStr selectImageStr:(NSString *)selectImageStr imagePosition:(ImagePosition)imagePosition{
    
    [self setTitle:title forState:UIControlStateNormal];
    
    // 文字对齐
    
    if (imagePosition == NOSTYLE) {
        
    }else {
        [self setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectImageStr] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:selectImageStr] forState:UIControlStateSelected];
        if (imagePosition == LEFTSTYLE) {
            
        }else if (imagePosition == RIGHTSTYLE){
            CGFloat imgWidth = self.imageView.frame.size.width;
            CGFloat labWidth = self.titleLabel.frame.size.width;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth, 0, -labWidth)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];
            
        }else if (imagePosition == TOPSTYLE){
            CGFloat offset = 0;
            CGFloat imgWidth = self.imageView.frame.size.width;
            CGFloat imgHeight = self.imageView.frame.size.height;
            CGFloat labHeight = self.titleLabel.frame.size.height;
            CGFloat labWidth = self.titleLabel.frame.size.width;
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, -imgHeight-offset, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(-labHeight-offset, 0, 0, -labWidth)];
            
        }else if (imagePosition == BOTTOMSTYLE){
            CGFloat offset = 0;
            CGFloat imgWidth = self.imageView.frame.size.width;
            CGFloat imgHeight = self.imageView.frame.size.height;
            CGFloat labHeight = self.titleLabel.frame.size.height;
            CGFloat labWidth = self.titleLabel.frame.size.width;
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-imgWidth, 0, 0, imgHeight-offset)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0 , -labHeight-offset, -labWidth)];
        }
    }
    
}

@end
