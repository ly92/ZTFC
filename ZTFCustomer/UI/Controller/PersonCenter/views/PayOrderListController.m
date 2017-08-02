//
//  PayOrderListController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PayOrderListController.h"
#import "PayOrderCell.h"
#import "PayOrderDetailController.h"

static NSString *payOrderIdentifier = @"PayOrderCell";

@interface PayOrderListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *payOrderArr;
@property (nonatomic, copy) NSString *last_id;
@property (nonatomic, copy) NSString *last_datetime;

@end

@implementation PayOrderListController


+(instancetype)spawn{
    return [PayOrderListController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    self.payOrderArr = [NSMutableArray array];
    
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerNib:[UINib nibWithNibName:payOrderIdentifier bundle:nil] forCellReuseIdentifier:payOrderIdentifier];
    
    
    [self setHeaderAndFooter];
    self.last_datetime = @"0";
    self.last_id = @"0";
    [self initloading];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"手机支付订单";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark-loadData

-(void)loadNewData{
    self.last_datetime = @"0";
    self.last_id = @"0";
    [self.payOrderArr removeAllObjects];
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

-(void)loadData{
    CardTransactionAPI *cardtransactionApi = [[CardTransactionAPI alloc] initWithBid:@"" Limits:@"10" LastId:self.last_id LastDatetime:self.last_datetime];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [cardtransactionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        [self dismissTips];
        CardTransactionModel *result = [CardTransactionModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            if (result.data.count <= 0){
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
                [self.payOrderArr addObjectsFromArray:result.data];
                
            }
            
            self.last_id =result.last_id;
            self.last_datetime = result.last_datetime;
            
            if (result.data.count < 10) {
                [self loadAll];
            }
            
            [self.tv reloadData];
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

#pragma mark-tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.payOrderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayOrderCell *cell=(PayOrderCell *)[tableView dequeueReusableCellWithIdentifier:payOrderIdentifier];
    if (self.payOrderArr.count > indexPath.row) {
        cell.data = self.payOrderArr[indexPath.row];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.payOrderArr.count > indexPath.row) {
        TransactionModel *payOrderModel = self.payOrderArr[indexPath.row];
        NSString *tid = payOrderModel.tid;
        
        PayOrderDetailController *payOrderDetail = [PayOrderDetailController spawn];
        
        payOrderDetail.tid = tid;
        
        [self.navigationController pushViewController:payOrderDetail animated:YES];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
