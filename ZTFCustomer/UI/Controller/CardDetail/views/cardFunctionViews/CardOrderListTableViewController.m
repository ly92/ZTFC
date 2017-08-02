//
//  CardOrderListTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardOrderListTableViewController.h"
#import "CardOrderDetailViewController.h"
#import "CardOrderTableViewCell.h"
#import "CardOrderListAPI.h"
#import "CardOrderModel.h"


@interface CardOrderListTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSString *bid;
@property (copy, nonatomic) NSString *last_id;//

@property (strong, nonatomic) NSMutableArray *orderList;//

@end

@implementation CardOrderListTableViewController
- (instancetype)initWithBid:(NSString *)bid {
    if (self = [super init]){
        self.bid = bid;
    }
    return self;
}

- (NSMutableArray *)orderList{
    if (!_orderList){
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }

    self.navigationItem.title = @"订单列表";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setHeaderAndFooter];
    
    [self.tv registerNib:[CardOrderTableViewCell nib] forCellReuseIdentifier:@"CardOrderTableViewCell"];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);

    self.last_id = @"0";
    [self initloading];
}

-(void)loadNewData{
    [self.orderList removeAllObjects];
    self.last_id = @"0";
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

- (void)loadData{
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    CardOrderListAPI *cardOrderApi = [[CardOrderListAPI alloc] initWithPagesize:@"10" LastId:self.last_id Bid:self.bid];
    [cardOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        if ([self.last_id intValue] == 0){
            [self.orderList removeAllObjects];
        }
        CardOrderModel *result = [CardOrderModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            self.last_id = result.last_id;
            
            [self.orderList addObjectsFromArray:result.orderlist];
            
            if (self.orderList.count > 0){
                [self.tv reloadData];
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }else{
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }
            if (result.orderlist.count < 10) {
                [self loadAll];
            }
            
        }
        else{
             [self presentFailureTips:result.reason];
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderList.count != 0)
    {
        return self.orderList.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"CardOrderTableViewCell";
    CardOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell){
        cell = [[CardOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.orderList.count>indexPath.row) {
        cell.data = [self.orderList objectAtIndex:indexPath.row];
    }
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderModel *subscribe = [self.orderList objectAtIndex:indexPath.row];
    
    CardOrderDetailViewController *detailViewController = [[CardOrderDetailViewController alloc] initWithOrderId:subscribe.ID];
    detailViewController.cancelBlock = ^(){
        self.last_id = @"0";
        [self loadData];
    };
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
