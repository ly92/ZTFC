//
//  PropertyOrderController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PaymentViewController.h"
#import "CommonChooseCell.h"
#import "CommunityPaymentController.h"
#import "PropertyInfoCell.h"
#import "PropertyOrderCell.h"
#import "PropertyOrderInfoCell.h"
#import "PropertyAddressCell.h"
#import "AlertView.h"
#import "PaymentMonthView.h"
#import "ConfirmOrderController.h"

@interface PaymentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIButton *cnfirmButton;

@property (nonatomic, strong) PaymentAddressModel *address;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, strong) OrderInfoModel * totalOrder;     // 待缴费月数和金额

@property (nonatomic, strong) NSMutableDictionary * responseDict;   // 返回的信息

@property (nonatomic, strong) AlertView * alertView;    // 弹出的缴费选择框
@property (nonatomic, strong) PaymentMonthView * paymentMonth;  // 选择要缴费的月份框

@end

@implementation PaymentViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.cnfirmButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.cnfirmButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setnavigationBar];
    
    self.keyArray = [NSArray array];
    self.orderArray = [NSArray array];
    
    [self.tv registerNib:@"PropertyAddressCell"];
    [self.tv registerNib:[CommonChooseCell nib] forCellReuseIdentifier:@"CommonChooseCell"];
    [self.tv registerNib:[PropertyInfoCell nib] forCellReuseIdentifier:@"PropertyInfoCell"];
    [self.tv registerNib:[PropertyOrderCell nib] forCellReuseIdentifier:@"PropertyOrderCell"];
    [self.tv registerNib:[PropertyOrderInfoCell nib] forCellReuseIdentifier:@"PropertyOrderInfoCell"];
  
    
    self.cnfirmButton.hidden = YES;
    
    //获取缴费地址
    
    [self loadPaymentList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPaymentList) name:@"ADDADDRESSSUCCESS" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.isTabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}

#pragma mark-navibar
-(void)setnavigationBar{
    
    self.navigationItem.title = (NSString *)self.data;
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-request
-(void)loadPaymentList{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    PaymentAddressListAPI *paymentAddressListApi = [[PaymentAddressListAPI alloc]init];
    [paymentAddressListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            
            if (![ISNull isNilOfSender:list]) {
                self.address = [PaymentAddressModel mj_objectWithKeyValues:list[0]];
                self.cnfirmButton.hidden = NO;
                [self loadPayOrder];
            }else{
                self.cnfirmButton.hidden = YES;
                [self.tv reloadData];
            }
            
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

-(void)loadPayOrder{
    [self presentLoadingTips:nil];
    GetPayOrderListAPI *payOrderApi = [[GetPayOrderListAPI alloc]initWithAddressId:self.address.id];
    [payOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            NSMutableArray *orderArr = [NSMutableArray array];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    AppearModel *appearModel = [AppearModel mj_objectWithKeyValues:dic];
                    [orderArr addObject:appearModel];
                }
                [self genrateKeyArray:orderArr];
                [self generateData:orderArr];
                
                self.cnfirmButton.hidden = NO;
            }else{
                self.cnfirmButton.hidden = YES;
                
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

// 订单的日期
- (void)genrateKeyArray:(NSArray *)data
{
    // 把订单的日期单独存起来
    NSMutableArray * keysArray = [NSMutableArray array];
    for ( AppearModel * appear in data )
    {
        if ( ![keysArray containsObject:appear.yearmonth] )
        {
            [keysArray addObject:appear.yearmonth];
        }
    }
    self.keyArray = keysArray;
}

// 按照日期分离订单
- (NSMutableDictionary *)generateData:(NSArray *)data
{
    NSMutableDictionary * responseDict = [NSMutableDictionary dictionary];
    
    // 只有一条数据的情况
    if ( data.count == 1 )
    {
        AppearModel * appear = data[0];
        NSMutableArray * valueArrays = [NSMutableArray arrayWithObjects:appear, nil];
        [responseDict setObject:valueArrays forKey:appear.yearmonth];
    }
    else
    {
        // 有多条数据的情况
        // 根据订单的日期，找出来这个日期的账单，放到一起
        for (int i = 0; i < data.count; i++)
        {
            AppearModel * appear = data[i];
            
            if ( [responseDict allKeys].count == 0 )
            {
                NSMutableArray * valueArrays = [NSMutableArray arrayWithObjects:appear, nil];
                [responseDict setObject:valueArrays forKey:appear.yearmonth];
            }
            else
            {
                BOOL isExist = YES;
                
                for (int j = 0; j < [responseDict allKeys].count; j++)
                {
                    NSString * key = [responseDict allKeys][j];
                    if ( [appear.yearmonth isEqualToString:key] )
                    {
                        NSMutableArray * valueArrays = responseDict[appear.yearmonth];
                        if ( [valueArrays containsObject:appear] )
                        {
                            continue;
                        }
                        isExist = YES;
                        [valueArrays addObject:appear];
                        [responseDict setObject:valueArrays forKey:appear.yearmonth];
                        break;
                    }
                    else
                    {
                        isExist = NO;
                    }
                }
                
                if ( !isExist )
                {
                    NSMutableArray * valueArrays = [NSMutableArray arrayWithObjects:appear, nil];
                    [responseDict setObject:valueArrays forKey:appear.yearmonth];
                }
            }
        }
    }
    
    // 总条目清单
    NSMutableArray * orderInfoArray = [NSMutableArray array];
    
    for (NSString * key in self.keyArray)
    {
        OrderInfoModel * orderInfo = [[OrderInfoModel alloc] init];
        NSArray *appearsArray = responseDict[key];
        
        float money = 0;
        for (AppearModel * appear in appearsArray)
        {
            orderInfo.time = appear.yearmonth;
            money += appear.fee.floatValue;
        }
        
        orderInfo.totalMoney = [NSString stringWithFormat:@"%.2f", money];
        [orderInfoArray addObject:orderInfo];
    }
    self.orderArray = orderInfoArray;
    
    // 待缴费金额
    float feeMoney = 0;
    for (AppearModel * appear in data)
    {
        feeMoney += appear.fee.floatValue;
    }
    
    NSString * feeMoneyString = [NSString stringWithFormat:@"%.2f", feeMoney];
    
    // 计算出总共的待缴费月数和待缴费金额
    OrderInfoModel * totalOrder = [[OrderInfoModel alloc] init];
    totalOrder.totalMoney = feeMoneyString;
    
    // 待缴费月数
    NSString * monthCount = [NSString stringWithFormat:@"%lu", (unsigned long)[responseDict allKeys].count];
    totalOrder.time = monthCount;
    
    self.totalOrder = totalOrder;
    
    self.responseDict = responseDict;
    
    return responseDict;
}

#pragma mark-click
- (IBAction)confirmBtnClick:(id)sender {
    
    if ( self.totalOrder.totalMoney.floatValue <= 0 )
    {
        [self presentFailureTips:@"没有可以缴费的项目"];
        return;
    }
    if ( self.alertView == nil )
    {
        PaymentMonthView * paymentMonth = [PaymentMonthView loadFromNib];
        AlertView * alertView = [[AlertView alloc] initWithContent:paymentMonth type:AlertViewTypeMonospaced];
        [alertView showSharedView];
        paymentMonth.data = self.orderArray;
        @weakify(self);
        paymentMonth.confirmOrder = ^(NSArray * orders){
            @strongify(self);
            
            if ( orders.count == 0 )
            {
                [self presentFailureTips:@"没有可以缴费的项目"];
                return;
            }
            
            NSString * orderIds = @"";
            
            // 生成需要缴费项目的id串
            for (OrderInfoModel * ordenInfo in orders)
            {
                NSArray * ordersArray = self.responseDict[ordenInfo.time];
                for (AppearModel * appear in ordersArray)
                {
                    orderIds = [orderIds stringByAppendingString:[NSString stringWithFormat:@"%@,", appear.billid]];
                }
            }
            
            if ( orderIds.length > 0 )
            {
                orderIds = [orderIds substringToIndex:orderIds.length - 1];
            }
            
            [alertView hide];
            ConfirmOrderController * order = [ConfirmOrderController spawn];
            order.address = self.address;
            order.data = orders;
            order.orders = orderIds;
//            order.snType = SN_TYPE_PROPERTY;
            [self.navigationController pushViewController:order animated:YES];
        };
        self.paymentMonth = paymentMonth;
        self.alertView = alertView;
    }
    else
    {
        [self.alertView showSharedView];
    }
}


#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.address==nil )
    {
        return 1;
    }
    else
    {
        NSInteger count = 2;
        
        count += self.responseDict.allKeys.count;
        
        return count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.address==nil )
    {
        return 1;
    }
    else
    {
        if ( section >= 2 )
        {
            NSArray * orderInfoArray = self.orderArray;
            if ( orderInfoArray.count )
            {
                OrderInfoModel * orderInfo = orderInfoArray[section - 2];
                if ( orderInfo.isOpen )
                {
                    return 1;
                }
                else
                {
                    return 2;
                }
            }
            return 1;
        }
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if ( self.address==nil )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommonChooseCell" forIndexPath:indexPath];
    }
    else
    {
        if ( indexPath.section == 0 )
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyAddressCell" forIndexPath:indexPath];
            cell.data = self.address;
        }
        else if ( indexPath.section == 1 )
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyInfoCell" forIndexPath:indexPath];
            cell.data = self.totalOrder;
        }
        else
        {
            if ( indexPath.row == 0 )
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyOrderCell" forIndexPath:indexPath];
                NSArray * orderInfoArray = self.orderArray;
                cell.data = orderInfoArray[indexPath.section - 2];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyOrderInfoCell" forIndexPath:indexPath];
                
                NSString * time = self.keyArray[indexPath.section - 2];
                //            ORDERINFO * orderInfo = self.model.orderArray[indexPath.section - 2];
                NSArray * dataArray = self.responseDict[time];
                
                cell.data = dataArray;
            }
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.address==nil )
        
    {
        return 50;
    }
    else
    {
        if ( indexPath.section == 0 )
        {
            return 64;
        }
        else if ( indexPath.section == 1 )
        {
            return 115;
        }
        else
        {
            if ( indexPath.row == 0 )
            {
                return 44;
            }
            else
            {
                NSString * time = self.keyArray[indexPath.section - 2];
                NSArray * dataArray = self.responseDict[time];
                return [PropertyOrderInfoCell heightForData:dataArray];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( self.address==nil )
        
    {
        return 1;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return 0.01;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] init];
    if ( GT_IOS7 )
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
    if ( GT_IOS7 )
    {
        sectionView.backgroundColor = [AppTheme lineColor];
    }
    else
    {
        sectionView.backgroundColor = [UIColor clearColor];
    }
    return sectionView;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ( self.address == nil )
        {
    CommunityPaymentController * community = [CommunityPaymentController spawn];
//    community.paymentType = PAYMENT_TYPE_PROPERTY;
    //        @weakify(self);
    //        community.didSelect = ^(id address) {
    //            @strongify(self);
    //            [self presentLoadingTips:nil];
    //            self.address = address;
    //            self.model.addressId = self.address.id;
    //            [self.propertyModel.items addObject:address];
    //            [self.model refresh];
    //        };
    [self.navigationController pushViewController:community animated:YES];
        }
        else
        {
            if ( indexPath.section == 0 )
            {
                CommunityPaymentController * paymentVC = [CommunityPaymentController spawn];

                paymentVC.didSelect = ^(id address) {
                    [self presentLoadingTips:nil];
                    self.address = address;
                    
                    [self loadPayOrder];

                };
                [self.navigationController pushViewController:paymentVC animated:YES];
            }
            if ( indexPath.section >= 2 && indexPath.row == 0 )
            {
                NSArray * orderInfoArray = self.orderArray;
                if ( orderInfoArray.count )
                {
                    OrderInfoModel * orderInfo = orderInfoArray[indexPath.section - 2];
                    orderInfo.isOpen = !orderInfo.isOpen;
                    [tableView reloadData];
                }
            }
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
