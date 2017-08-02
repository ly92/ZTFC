//
//  UITableView+RemoveExcessLine.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/24.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UITableView+RemoveExcessLine.h"

@implementation UITableView (RemoveExcessLine)
//移除多余的分割线
- (void)tableViewRemoveExcessLine
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [self setTableHeaderView:view];
}
@end
