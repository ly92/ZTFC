//
//  CardOrderDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardOrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"
#import "CardOrderCancleAPI.h"
#import "CardOrderDetailAPI.h"
#import "CardOrderDetailModel.h"

@interface CardOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *replyL;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvViewH;

@property (nonatomic, strong) NSString *orderid;


@property (nonatomic, strong) NSMutableArray *detailList;

@end

@implementation CardOrderDetailViewController

- (NSMutableArray *)detailList{
    if (!_detailList){
        _detailList = [NSMutableArray array];
    }
    return _detailList;
}

- (instancetype)initWithOrderId:(NSString *)orderid{
    if (self = [super init]){
        self.orderid = orderid;
    }
    return self;
}

- (IBAction)cancleClick:(id)sender {
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    CardOrderCancleAPI *cancelOrderApi = [[CardOrderCancleAPI alloc] initWithOrderId:self.orderid];
    [cancelOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [[result objectForKey:@"result"] intValue] == 0){
            [self presentSuccessTips:@"取消成功"];
            self.cancelBlock();
            
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.cancleBtn.layer.cornerRadius = 5;
    self.btnView.layer.cornerRadius = 5;
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.tv registerNib:[OrderDetailTableViewCell nib] forCellReuseIdentifier:@"OrderDetailTableViewCell"];
    
    CardOrderDetailAPI *orderDetailApi = [[CardOrderDetailAPI alloc] initWithOrderId:self.orderid];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [orderDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
         CardOrderDetailModel *result = [CardOrderDetailModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            self.detailList = [NSMutableArray arrayWithArray:result.detaillist];
            self.tvViewH.constant = self.detailList.count * 44;
            
            [self.tv reloadData];
            
            self.amountL.text = [NSString stringWithFormat:@"¥ %@",result.orderinfo.totalprice];
            self.orderNo.text = [NSString stringWithFormat:@"NO.%@",result.orderinfo.orderno];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[result.orderinfo.creationtime  longLongValue]];
            self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
            
//            self.timeL.text = [NSDate longlongToDayDateTime:result.orderinfo.creationtime];
            self.telL.text = result.orderinfo.mobile;
            self.addressL.text = result.orderinfo.address;
            self.remarkL.text = result.orderinfo.memo;
            self.replyL.text = result.orderinfo.advice;
            
            //订单状态
            NSString *a_status = [NSString stringWithFormat:@"%@",result.orderinfo.status];
            
            if ([a_status isEqualToString:@"0"]) {//未处理
                self.titleL.text = @"等待商家处理中";
                self.btnView.hidden = NO;
            }
            if ([a_status isEqualToString:@"1"]) { //确认
                self.titleL.text = @"恭喜，您的订单已经确认";
                //self.cancelOrderBtn.hidden = YES;
            }
            if ([a_status isEqualToString:@"2"]) {//完成
                self.titleL.text = @"恭喜，您的订单已经完成";
            }
            if ([a_status isEqualToString:@"-1"]) {//拒绝
                self.titleL.text = @"您的订单已经被拒绝";
            }
            if ([a_status isEqualToString:@"-3"]) {//过期
                self.titleL.text = @"您的订单已经过期";
            }
            if ([a_status isEqualToString:@"-2"]) {//取消
                self.titleL.text = @"您的订单已经取消";
            }

        }
        else{
             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.detailList.count) return 0;
    return self.detailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.detailList.count != 0){
        static NSString *ID = @"OrderDetailTableViewCell";
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        if (!cell){
            cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.data = [self.detailList objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
