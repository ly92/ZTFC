//
//  IncomeViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "IncomeViewController.h"
#import "CLIncomeCell.h"
#import "ExpendDetailViewController.h"

@interface IncomeViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *limit;

@end

@implementation IncomeViewController
+(instancetype)spawn{
    return [IncomeViewController loadFromStoryBoard:@"MyDrop"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setHeaderAndFooter];
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerNib:@"CLIncomeCell"];
   
    self.limit = @"10";
    self.skip = @"0";
    
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
-(NSMutableArray *)listData{
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    if ([self.incomeType isEqualToString:@"0"]) {
         self.navigationItem.title = @"收入明细";
    }else{
        self.navigationItem.title = @"支出明细";
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
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
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    TransactionListAPI *transactionListApi = nil;
    
    if ([self.incomeType isEqualToString:@"0"]){
        transactionListApi = [[TransactionListAPI alloc]initWithLimit:self.limit skip:self.skip];
        transactionListApi.transcationType = InclomeType;
    }else{
        transactionListApi = [[TransactionListAPI alloc]initWithLimit:self.limit skip:self.skip];
        transactionListApi.transcationType = ExpendType;
    }
    
    [transactionListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];

        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            NSArray *list = content[@"info"];
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
            [self presentFailureTips:result[@"message"]];
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
- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLIncomeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CLIncomeCell" owner:nil options:nil] firstObject];
    if ([self.incomeType isEqualToString:@"0"] || [self.incomeType isEqualToString:@"1"]) {
        DropTransactionModel *receive = _listData[indexPath.row];
        [cell.titleLabel setText:receive.content];
        [cell.timerLabel setText:receive.create_time];
        if ([self.incomeType isEqualToString:@"0"]) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.moneyLabel setText:[NSString stringWithFormat:@"+%@元",receive.money]];
        } else {
            [cell.moneyLabel setText:[NSString stringWithFormat:@"%@元",receive.money]];
        }
         cell.moneyLblWidth.constant = [cell.moneyLabel resizeWidth];
        
    }  else {
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.incomeType isEqualToString:@"0"]){
//        if (_listData.count > indexPath.row) {
            DropTransactionModel *receive = _listData[indexPath.row];
            NSString *money = [NSString stringWithFormat:@"+%@元",receive.money];
            
            CGSize moneySize = [money sizeForFont:[UIFont systemFontOfSize:20.0] size:CGSizeMake(MAXFLOAT, 20) mode:NSLineBreakByWordWrapping];
            
            NSString *title = receive.content;
            
            CGSize titleSize = [title sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(SCREENWIDTH-moneySize.width-45, MAXFLOAT) mode:NSLineBreakByWordWrapping];
            
            if (titleSize.height > 20) {
                return 55-20+titleSize.height;
                
            }
            return 55;
//        }
//    }
//
//    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_listData.count > 0) {
        return 36;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_listData.count > 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
        [headView setBackgroundColor:[UIColor clearColor]];
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
//        if (_listData.count > 0) {
//            DropTransactionModel *receive = _listData[0];
            if ([self.incomeType isEqualToString:@"0"]) {
                [headLabel setText:[NSString stringWithFormat:@"共收入：¥%.2f",[self.totalMoney floatValue]]];
            } else if ([self.incomeType isEqualToString:@"1"]){
                [headLabel setText:[NSString stringWithFormat:@"共消费：¥%.2f",[self.totalMoney floatValue]]];
            }
//        } else {
//            if ([self.incomeType isEqualToString:@"0"]) {
//                [headLabel setText:[NSString stringWithFormat:@"共收入：¥0.00"]];
//            } else if ([self.incomeType isEqualToString:@"1"]){
//                [headLabel setText:[NSString stringWithFormat:@"共消费：¥0.00"]];
//            }
//        }
        [headLabel setTextColor:[UIColor whiteColor]];
        [headLabel setFont:[UIFont systemFontOfSize:14]];
        [headLabel setBackgroundColor:UIColorFromRGB(0xff8236)];
        [headLabel setTextAlignment:NSTextAlignmentCenter];
        [headView addSubview:headLabel];

        return headView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.incomeType isEqualToString:@"1"]) {
        DropTransactionModel *expendModel = _listData[indexPath.row];
        ExpendDetailViewController *expendDetailVC = [ExpendDetailViewController spawn];
        expendDetailVC.expendModel = expendModel;
        [self.navigationController pushViewController:expendDetailVC animated:YES];
    }
}

#pragma mark - 

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = nil;
    if ([self.incomeType isEqualToString:@"0"]) {
        text = @"还没有收入记录";
    }else{
        text = @"还没有支出记录";
    }
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
