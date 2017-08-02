//
//  UIViewController+TableView.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TableView)
@property (nonatomic, strong) UITableView *tv;
-(void)setHeaderAndFooter;
-(void)initloading;
//加载完成
-(void)doneLoadingTableViewData;
//下拉刷新
-(void)loadNewData;
//上拉加tableView
-(void)loadMoreData;

//是否还有更多数据
-(void)loadAll;
-(void)resetLoadAll;

@end
