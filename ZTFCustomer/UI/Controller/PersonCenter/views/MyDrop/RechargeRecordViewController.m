//
//  RechargeRecordViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "CLRechargeListCell.h"
#import "RechargeRecordDetailViewController.h"
#import "PayController.h"

@interface RechargeRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *limit;
@end

@implementation RechargeRecordViewController
+(instancetype)spawn{
    return [RechargeRecordViewController loadFromStoryBoard:@"MyDrop"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self.tv tableViewRemoveExcessLine];
    [self setHeaderAndFooter];
    [self.tv registerNib:@"CLRechargeListCell"];
    self.skip = @"0";
    self.limit = @"10";
    [self initloading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"充值记录";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
-(NSMutableArray *)listData{
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}
#pragma mark-request
-(void)loadNewData{
    self.skip = @"0";
    [self.listData removeAllObjects];
    [self loadData];
}
-(void)loadMoreData{
     self.skip = [NSString stringWithFormat:@"%ld",[self.skip integerValue]+[self.limit integerValue]];
    
    [self loadData];
}
-(void)loadData{
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    
    TransactionListAPI *transactionListApi = [[TransactionListAPI alloc]initWithLimit:self.skip skip:self.limit];
    
    [transactionListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSArray *list = result[@"list"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    DropTransactionModel *incomeModel = [DropTransactionModel mj_objectWithKeyValues:dic];
                    [self.listData addObject:incomeModel];
                }
            }
            
            if (self.listData.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            
            if (list.count < [self.limit integerValue]) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }
            
            [self.tv reloadData];
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
    

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLRechargeListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CLRechargeListCell" owner:nil options:nil] firstObject];
    DropTransactionModel *rechargeModel = _listData[indexPath.row];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[rechargeModel.money floatValue]]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [cell.timerLabel setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[rechargeModel.create_time intValue]]]];
//    NSString *status;
//    switch ([rechargeModel.status integerValue]) {
//        case 0:
//        {
//            status = @"待付款";
//        }
//            break;
//        case 1:
//        {
//            status = @"已付款";
//        }
//            break;
//        case 2:
//        {
//            status = @"交易成功";
//        }
//            break;
//       
//        case 3:
//        {
//            status = @"取消订单";
//        }
//            break;
//        case 4:
//        {
//            status = @"已退款";
//        }
//            break;
//        
//            
//        default:
//            break;
//    }
//    [cell.statusLabel setText:status];
//    [cell.statusLabel setTextColor:[UIColor colorWithStatusName:status]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DropTransactionModel *rechargeModel = _listData[indexPath.row];

//    if ([rechargeModel.status integerValue] == 0) {
//        待付款订单直接跳去收银台
        
//        CashierViewController * cashier = [CashierViewController spawn];
//        cashier.sn = _contriButions.sn;
//        [self.navigationController pushViewController:cashier animated:YES];
        
        PayController *payController = [[PayController alloc]init];
//        payController.tnum = rechargeModel.tradeNo;
    @weakify(payController)
        payController.paySuccess = ^(NSString *payCallback){
            @strongify(payController)
//             [payController.navigationController popToViewController:self animated:NO];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",payCallback]]];
            payController.navigationItem.title = @"支付结果";
            
            [webView loadRequest:request];
            [payController.view addSubview:webView];
        };
        [self.navigationController pushViewController:payController animated:YES];
        
//    } else {
//        RechargeRecordDetailViewController *rechargeDetailVC = [RechargeRecordDetailViewController spawn];
//        rechargeDetailVC.rechargeDetailModel = rechargeModel;
////        [rechargeDetailVC setContriButions:_contriButions];
//        [self.navigationController pushViewController:rechargeDetailVC animated:YES];
//    }
}


#pragma mark -

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"还没有充值记录";
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor grayColor]}];
    return str;
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
