//
//  FeedBackTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "FeedBackTableViewController.h"
#import "FeedbackTableViewCell.h"
#import "FeedbackDetailViewController.h"
#import "FeedbackListAPI.h"
#import "FeedbackListmodel.h"

@interface FeedBackTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSString *bid;
@property (strong, nonatomic) NSMutableArray *historyList;//
@property (copy, nonatomic) NSString *last_id;//
@end

@implementation FeedBackTableViewController
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
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }

    self.navigationItem.title = @"历史记录";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setHeaderAndFooter];
    [self.tv registerNib:[FeedbackTableViewCell nib] forCellReuseIdentifier:@"FeedbackTableViewCell"];
    self.tv.backgroundColor = [UIColor clearColor];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
    
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);


    self.last_id = @"0";
    
    [self initloading];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"feedbackReply" object:nil];
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
    if ([self.last_id intValue] == 0){
        [self.historyList removeAllObjects];
    }
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    FeedbackListAPI *feedbackListApi = [[FeedbackListAPI alloc] initWithPagesize:@"10" LastId:self.last_id Bid:self.bid];
    [feedbackListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                //停止刷新
        [self doneLoadingTableViewData];
        FeedbackListmodel *result = [FeedbackListmodel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            self.last_id = result.last_id;
            
            [self.historyList addObjectsFromArray:result.list];
            
            if (self.historyList.count > 0){
                [self.tv reloadData];
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }else{
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }
            
            if (result.list.count < 10) {
                [self loadAll];
            }
            
        }
        else{
             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData]; if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![ISNull isNilOfSender: self.historyList])
    {
        return self.historyList.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *ID = @"FeedbackTableViewCell";
        FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

        if (self.historyList.count > indexPath.row){
            cell.data = [self.historyList objectAtIndex:indexPath.row];
        }
        return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedbackModel *feedback = [self.historyList objectAtIndex:indexPath.row];
    
    FeedbackDetailViewController *detailViewController = [[FeedbackDetailViewController alloc] initWFeedback:feedback];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
