//
//  UIViewController+TableView.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UIViewController+TableView.h"

#import <objc/runtime.h>

static const char kUIViewControllerTableViewKey;

@implementation UIViewController (TableView)


-(void)setTv:(UITableView *)tv{
    return objc_setAssociatedObject(self, &kUIViewControllerTableViewKey, tv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITableView *)tv{
    return objc_getAssociatedObject(self, &kUIViewControllerTableViewKey);
}

-(void)setHeaderAndFooter{
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

-(void)initloading{
    [self.tv.mj_header beginRefreshing];
}

//下拉刷新
-(void)loadNewData{
    self.tv.userInteractionEnabled = NO;
}
//上拉加tableView
-(void)loadMoreData{
    
}
//加载完全
-(void)loadAll{
    [self.tv.mj_footer endRefreshingWithNoMoreData];
    
}

//重置加载完全（允许再次下拉）
-(void)resetLoadAll
{
    [self.tv.mj_footer resetNoMoreData];
}

//加载完成
-(void)doneLoadingTableViewData{
    
    self.tv.userInteractionEnabled = YES;
    if ([self.tv.mj_header isRefreshing]) {
        [self.tv.mj_header endRefreshing];
    }
    
    if([self.tv.mj_footer isRefreshing]){
        [self.tv.mj_footer endRefreshing];
    }
}

@end
