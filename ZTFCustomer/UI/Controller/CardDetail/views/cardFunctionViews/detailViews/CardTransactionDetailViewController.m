//
//  CardTransactionDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardTransactionDetailViewController.h"
#import "CardTransactionDetailAPI.h"
#import "CardTransactionDetailModel.h"

@interface CardTransactionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *busNameL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *styleL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *receiveableL;
@property (weak, nonatomic) IBOutlet UILabel *receivedL;
@property (weak, nonatomic) IBOutlet UILabel *useBalanceL;
@property (weak, nonatomic) IBOutlet UILabel *discountL;
@property (weak, nonatomic) IBOutlet UILabel *preferentialL;
@property (weak, nonatomic) IBOutlet UILabel *couponMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *pointScale;
@property (weak, nonatomic) IBOutlet UILabel *pointL;
@property (weak, nonatomic) IBOutlet UILabel *transactionNo;
@property (weak, nonatomic) IBOutlet UILabel *transactionTime;
@property (weak, nonatomic) IBOutlet UIView *sunView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewH;

@property (nonatomic, strong) NSString *tid;

@property (nonatomic, strong) TransactionDetailData *transaction;


@end

@implementation CardTransactionDetailViewController

- (instancetype)initWithTid:(NSString *)tid{
    if (self = [super init]){
        self.tid = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    CardTransactionDetailAPI *transactionDetailApi = [[CardTransactionDetailAPI alloc] initWithTid:self.tid];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [transactionDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        CardTransactionDetailModel *result = [CardTransactionDetailModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            self.transaction = result.data;
            [self prepareData];
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
    
//    self.transactionDetailModel = [[CardTransactionDetailModel alloc] init];
//    @weakify(self);
//    [self presentLoadingTips:@"加载中..."];
//    [self.transactionDetailModel getConsumeWithTID:self.tid then:^(STIHTTPResponseError *e) {
//        @strongify(self);
//        [self dismissTips];
//        if (e){
//            [self presentFailureTips:self.transactionDetailModel.reason];
//        }else{
//            if ([ISNull isNilOfSender:self.transactionDetailModel.result] || [self.transactionDetailModel.result intValue] != 0){
//                [self presentFailureTips:self.transactionDetailModel.reason];
//                return ;
//            }
//            self.transaction = self.transactionDetailModel.transactionInfo;
//            [self prepareData];
//        }
//        
//    }];
}


- (void)prepareData{
    self.busNameL.text = self.transaction.name;
    self.amountL.text = self.transaction.amount;
    int state = [self.transaction.tstatus intValue];
    if (state == 1) {
        self.stateL.text = @"交易成功";
    }
    else {
        self.stateL.text = @"交易取消";
    }
    
    
    if ([self.transaction.maintype intValue] == 1){//现金充值
        self.sunView.hidden = YES;
        self.subViewH.constant = 0;
        self.styleL.text = @"充值金额";
        self.navigationItem.title = @"充值详情";
        
    }else{//现金消费或二维码消费
        self.sunView.hidden = NO;
        self.subViewH.constant = 214;
        self.styleL.text = @"消费金额";
        self.navigationItem.title = @"消费详情";
        
        self.receiveableL.text = [NSString stringWithFormat:@"¥ %@",self.transaction.need_pay];
        self.receivedL.text = [NSString stringWithFormat:@"¥ %@",self.transaction.charge_amount];
        self.useBalanceL.text = [NSString stringWithFormat:@"¥ %@",self.transaction.user_balance];
        if ([self.transaction.discount floatValue] > 0 && [self.transaction.discount floatValue] < 100){
            self.discountL.text = [NSString stringWithFormat:@"%.1f",[self.transaction.discount floatValue]/10];
        }else{
            self.discountL.text = @"无";
        }
        self.preferentialL.text = self.transaction.saving_amount;
        if ([ISNull isNilOfSender:self.transaction.coupon_amount]){
            self.couponMoneyL.text = @"0.00";
        }else{
            self.couponMoneyL.text = self.transaction.coupon_amount;
        }
        if ([self.transaction.rate intValue] == 0) {
            self.pointScale.text = @"无";
        }
        else {
            self.pointScale.text = [NSString stringWithFormat:@"%.0f%%",[self.transaction.rate floatValue]];
        }
        self.pointL.text = self.transaction.rate_amount;
    }
    
    self.transactionNo.text = self.transaction.tnum;
//    self.transactionTime.text = [NSDate longlongToDateTime:self.transaction.creationtime];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.transaction.creationtime  longLongValue]];
    self.transactionTime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
