//
//  EntranceGuardHeaderView.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "EntranceGuardHeaderView.h"

@implementation EntranceGuardHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self == [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"EntranceGuardHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
}


@end
