//
//  ConfirmOrderController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ConfirmOrderController.h"

#import "PropertyAddressCell.h"
#import "ConfirmOrderCell.h"
#import "PayController.h"
#import "CashierViewController.h"

@interface ConfirmOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)confirmAction:(id)sender;

@end

@implementation ConfirmOrderController

+ (instancetype)spawn
{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[ZhuGeModel sharedInstance] uploadEventAndUser:@"确认订单（确认订单）"];
    self.confirmBtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.confirmBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.navigationItem.title = @"确认订单";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.tableView registerNib:[PropertyAddressCell nib] forCellReuseIdentifier:@"PropertyAddressCell"];
    [self.tableView registerNib:[ConfirmOrderCell nib] forCellReuseIdentifier:@"ConfirmOrderCell"];
    
    self.tableView.separatorColor = [AppTheme lineColor];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.isTabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}
#pragma mark-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if ( indexPath.section == 0 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyAddressCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.data = self.address;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.data = self.data;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        return 64;
    }
    return [ConfirmOrderCell heightForConfirmCell:self.data];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 || section == 1 )
    {
        return 10;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] init];
    if (GT_IOS7)
    {
        sectionView.backgroundColor = [AppTheme lineColor];
    }
    else
    {
        sectionView.backgroundColor = [UIColor clearColor];
    }
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [AppTheme lineColor];
    return sectionView;
}

- (IBAction)confirmAction:(id)sender
{
    [self presentLoadingTips:@"请稍后..."];
    
    CGFloat totalMoney = 0;
    
//    if ( self.snType == SN_TYPE_PARKING )
//    {
//        // 预缴停车费是在上个界面创建的订单
//        [self dismissTips];
//        CashierViewController * cashier = [CashierViewController spawn];
//        cashier.sn = self.sn;
//        [self.navigationController pushViewController:cashier animated:YES];
//    }
//    else
//    {
        for (OrderInfoModel * orderInfo in self.data)
        {
            totalMoney += orderInfo.totalMoney.floatValue;
        }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    CreateOrderAPI *createOrderApi = [[CreateOrderAPI alloc]initWithBid:@"10000230" money:[NSString stringWithFormat:@"%.2f",totalMoney] callBack:@"" content:@"test" extype:@"5"];
    [createOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            PayController * cashier = [PayController spawn];
            cashier.tnum = result[@"tnum"];
            @weakify(cashier)
            cashier.paySuccess = ^(NSString *payCallback){
                @strongify(cashier)
//                [cashier.navigationController popToViewController:self animated:NO];
                
                UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",payCallback]]];
                cashier.navigationItem.title = @"支付结果";
                
                [webView loadRequest:request];
                [cashier.view addSubview:webView];
            };
            
            [self.navigationController pushViewController:cashier animated:YES];
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

@end
