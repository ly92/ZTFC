//
//  CityListCell.m
//  gaibianjia
//
//  Created by geekzoo on 15/6/23.
//  Copyright (c) 2015年 Geek Zoo Studio. All rights reserved.
//  定位城市列表cell

#import "CityListCell.h"
#import "ChineseString.h"

@interface CityListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CityListCell

- (void)dataDidChange
{
    ChineseString * data = self.data;
    self.nameLabel.text = data.string;
}

@end
