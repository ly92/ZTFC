//
//  SuppleView.m
//  WeiTown
//
//  Created by kakatool on 15/6/10.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import "SuppleView.h"

@implementation SuppleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
         _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-25, self.width, 25)];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.text = @"   ";
        [self addSubview:_titleLabel];
        
     _linkView = [[UIView alloc] initWithFrame:CGRectMake(0,_titleLabel.top+_titleLabel.height-1, self.width, 1)];
        [_linkView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
        [self addSubview:_linkView];
    }
    return self;
}

@end
