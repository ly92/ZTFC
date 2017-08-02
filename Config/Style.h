//
//  Style.h
//  EstateBiz
//
//  Created by Ender on 10/20/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

/**
 * 用于统一的UI风格类，方便后期风格修改
 *
 */


#ifndef Style_h
#define Style_h

#import "Macros.h"

//viewContoller背景颜色（所有背景颜色）
#define VIEW_BG_COLOR UIColorFromRGB(0xf0f0f0)

//下方tabbar背景颜色
#define TAB_BG_COLOR UIColorFromRGB(0xffffff)
//tabbar字体颜色
//tabbar未点击色值
#define TAB_TEXT_COLOR UIColorFromRGB(0x000000)
//tabbar点击色值
#define TAB_SELECTTEXT_COLOR UIColorFromRGB(0x31A3ED)

//导航条背景颜色
#define NAV_BG_COLOR UIColorFromRGB(0x333B46)
//导航栏字体颜色
#define NAV_TEXTCOLOR UIColorFromRGB(0xffffff)
//导航栏上的搜索字体颜色(楼盘界面使用)
#define NAV_SEARCHTEXTCOLOR UIColorFromRGB(0xBBC2C7)
//导航栏上的搜索背景颜色(楼盘界面使用)
#define NAV_SEARCHBGCOLOR UIColorFromRGB(0x000000)

//首页“我的会员卡“字体颜色
#define HOMEMEMBERCARDCOLOR UIColorFromRGB(0x3a3a3a)

//按钮
//所有蓝色按钮的色值
#define BUTTON_BLUECOLOR UIColorFromRGB(0x27A2F0)
//#define BUTTON_BLUECOLOR UIColorFromRGB(0xff0000)
//蓝色按钮中对应的字体色值
#define BUTTONBLUE_TEXTCOLOR UIColorFromRGB(0xffffff)
//所有黑色按钮的色值
#define BUTTON_BLACKCOLOR UIColorFromRGB(0x333B46)
//黑色按钮中对应的字体色值
#define BUTTONBLACK_TEXTCOLOR UIColorFromRGB(0xffffff)
//所有灰色按钮的色值
#define BUTTON_GRAYCOLOR UIColorFromRGB(0xDEDEDE)
//灰色按钮中对应的字体色值
#define BUTTONGRAY_TEXTCOLOR UIColorFromRGB(0xffffff)

//楼盘详情和户型详情轮播图的原点选中和未选中颜色
//选中颜色
#define PAGECONTROL_SELECT_COLOR UIColorFromRGB(0xb0d2ff)
//未选中颜色
#define PAGECONTROL_UNSELECT_COLOR UIColorFromRGB(0x5077aa)

//项目中的蓝色字体颜色
#define BLUE_TEXTCOLOR UIColorFromRGB(0x27A2F0)
//#define BLUE_TEXTCOLOR UIColorFromRGB(0xff0000)

//项目中蓝色view
#define BLUE_VIEWCOLOR UIColorFromRGB(0x27A2F0)
//#define BLUE_VIEWCOLOR UIColorFromRGB(0xff0000)

//橙色view(0xff8236)
#define ORANGE_VIEWCOLOR UIColorFromRGB(0xff8236)

//用于投诉维修的评价界面
//viewController中的所有按钮背景颜色
#define VIEW_BTNBG_COLOR UIColorFromRGB(0x27A2F0)
//viewcontroller中的所有按钮中的字体颜色
#define VIEW_BTNTEXT_COLOR UIColorFromRGB(0xffffff)

//整个项目的主色调
#define MAINCOLOR UIColorFromRGB(0x27A2F0)

//促销信息，参加与不参加按钮的颜色
#define JoinButtonColor UIColorFromRGB(0x238EEC)
#define NoJoinButtonColor UIColorFromRGB(0x262C36)
#define NotJoinButtonColor UIColorFromRGB(0xB1BBC1)
//viewController中的字体颜色
#define TEXTCONTENTCOLOR UIColorFromRGB(0xffffff)

//个人中心默认头像
#define MemberHeadImage [UIImage imageNamed:@"head_member"]
#define SaleHeadImage [UIImage imageNamed:@"head_sale"]

//我的铁豆文字修改
#define MyDropText @"铁豆"
//app名字修改
#define AppName @"慧生活"


#endif /* Style_h */
