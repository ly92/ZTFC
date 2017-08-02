//
//  SubscribeHistoryTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SubscribeHistoryTableViewController.h"
#import "SubscribeTableViewCell.h"
#import "SubscribeDetailViewController.h"
#import "SubscribeListAPI.h"
#import "SubscribeListModel.h"

@interface SubscribeHistoryTableViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSString *bid;
@property (copy, nonatomic) NSString *last_id;//
@property (strong, nonatomic) NSMutableArray *historyList;//


@end

@implementation SubscribeHistoryTableViewController
- (instancetype)initWithBid:(NSString *)bid {
    if (self = [super init]){
        self.bid = bid;
    }
    return self;
}

- (NSMutableArray *)historyList{
    if (!_historyList){
        _historyList = [NSMutableArray array];
    }
    return _historyList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"历史记录";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setHeaderAndFooter];
    [self.tv registerNib:[SubscribeTableViewCell nib] forCellReuseIdentifier:@"SubscribeTableViewCell"];
    self.tv.backgroundColor = [UIColor clearColor];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
    
 

    self.last_id = @"0";
    
    [self initloading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"confirmBook" object:nil];
    
}

-(void)refreshData{
    [self initloading];
}

-(void)loadNewData{
    [self.historyList removeAllObjects];
    self.last_id = @"0";
    [self loadData];
}
-(void)loadMoreData{
    [self loadData];

}

- (void)loadData{
    
    
    if (self.isHouseDetail) {
        
    }else{
    
        if ([self.last_id intValue] == 0){
            [self.historyList removeAllObjects];
        }
        SubscribeListAPI *subscribeListApi = [[SubscribeListAPI alloc] initWithBid:self.bid LastId:self.last_id Pagesize:@"10"];
        [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
        [subscribeListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            //停止刷新
            [self doneLoadingTableViewData];
            [self dismissTips];
            SubscribeListModel *subscribeListModel = [SubscribeListModel mj_objectWithKeyValues:request.responseJSONObject];
            if (subscribeListModel && [subscribeListModel.result intValue] == 0) {
                self.last_id = subscribeListModel.last_id;
                
                [self.historyList addObjectsFromArray:subscribeListModel.list];
                
                if (self.historyList.count > 0){
                    [self.tv reloadData];
                    self.emptyView.hidden = YES;
                    self.tv.hidden = NO;
                }else{
                    self.tv.hidden = YES;
                    self.emptyView.hidden = NO;
                }
                
                if (subscribeListModel.list.count < 10) {
                    [self loadAll];
                }
                
            }
            else{
                 [self presentFailureTips:subscribeListModel.reason];
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
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (self.historyList.count != 0){
        return self.historyList.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"SubscribeTableViewCell";
    SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    if (self.historyList.count > indexPath.row){
    cell.data = self.historyList[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubscribeRecordModel *subscribe = self.historyList[indexPath.row];
    
    SubscribeDetailViewController *detailViewController = [[SubscribeDetailViewController alloc] initWithSubscribe:subscribe];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
