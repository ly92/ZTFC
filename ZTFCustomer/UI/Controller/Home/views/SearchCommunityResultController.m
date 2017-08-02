//
//  SearchCommunityResultController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchCommunityResultController.h"

@interface SearchCommunityResultController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


@property (nonatomic, strong) NSMutableArray *communityArr;

@end

@implementation SearchCommunityResultController

+(instancetype)spawn{
    return [SearchCommunityResultController loadFromStoryBoard:@"Home"];
}

-(NSMutableArray *)communityArr{
    if (!_communityArr) {
        _communityArr = [NSMutableArray array];
    }
    return _communityArr;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationbar];
    
    
    
    
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self setHeaderAndFooter];
    [self initloading];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}

#pragma mark-navibar
-(void)setNavigationbar{
    self.navigationItem.title = @"搜索结果";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark-load data
-(void)loadNewData{
    [self.communityArr removeAllObjects];
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

-(void)loadData{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    SearchCommunityAPI *searchCommunityApi = [[SearchCommunityAPI alloc]initWithKeyword:self.searchword];
    [searchCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSArray *communityArr = result[@"community"];
            for (NSDictionary *dic in communityArr) {
                [self.communityArr addObject:[Community mj_objectWithKeyValues:dic]];
            }
            
            if (self.communityArr.count == 0) {
                self.emptyView.hidden = NO;
                self.tv.hidden = YES;
            }else{
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }
            
            [self loadAll];
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
    
}

#pragma mark-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.communityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(self.communityArr.count>0){
        
        Community *community = self.communityArr[indexPath.row];
        cell.textLabel.text = community.name;
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.communityArr.count > indexPath.row) {
        
        Community *community = self.communityArr[indexPath.row];
        
        //替换搜索纪录
        [LocalData removeCommunitySearchOfHistoryRecord:self.searchword];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateHistoryRecord:)]) {
            [self.delegate updateHistoryRecord:community.name];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTCOMMUNITY" object:community];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
       
        
    }
    
}

@end
