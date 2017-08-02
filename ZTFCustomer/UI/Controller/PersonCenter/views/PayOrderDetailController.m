//
//  PayOrderDetailController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PayOrderDetailController.h"
#import "MemberCardDetailViewController.h"

@interface PayOrderDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (weak, nonatomic) IBOutlet UILabel *couponPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *banlancePriceLbl;

@property (weak, nonatomic) IBOutlet UILabel *tradeNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *tradeTimeLbl;

@property (weak, nonatomic) IBOutlet UILabel *produceInfoLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *produceInfoLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (nonatomic, strong) TransactionDetailData *payOrderDetailModel;

@end

@implementation PayOrderDetailController

+(instancetype)spawn{
    return [PayOrderDetailController loadFromStoryBoard:@"PersonalCenter"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];
    
    [self loadData];
    
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
    
    self.navigationItem.title = @"手机支付详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark-laodData
-(void)loadData{
   
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    CardTransactionDetailAPI *payOrderDetail = [[CardTransactionDetailAPI alloc]initWithTid:self.tid];
    [self dismissTips];
    [payOrderDetail startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        CardTransactionDetailModel *result = [CardTransactionDetailModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            self.payOrderDetailModel = result.data;
            [self prepareData];
        }else{
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

-(void)prepareData{
    if (self.payOrderDetailModel) {
        self.nameLbl.text = self.payOrderDetailModel.name;
        self.priceLbl.text = self.payOrderDetailModel.amount;
        
        if ([self.payOrderDetailModel.tstatus intValue] == 100) {
            self.statusLbl.text = @"交易取消";
        }else{
            self.statusLbl.text = @"交易完成";
        }
        
        self.couponPriceLbl.text = self.payOrderDetailModel.coupon_amount;
        
        self.banlancePriceLbl.text = self.payOrderDetailModel.user_balance;
        self.tradeNoLbl.text = self.payOrderDetailModel.tnum;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        [self.tradeTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.payOrderDetailModel.creationtime intValue]]]];
        
        self.produceInfoLbl.text = self.payOrderDetailModel.content;
        
        CGFloat productInfoHeight = [self.produceInfoLbl resizeHeight];
        
        if (productInfoHeight> 20) {
            self.produceInfoLblHeight.constant = productInfoHeight;
        }
        
        self.productViewHeight.constant = 60+self.produceInfoLblHeight.constant;
        
        self.containerViewHeight.constant = 380 - 80 +self.productViewHeight.constant;
    }
}
#pragma mark-click
//查看商家信息
- (IBAction)gotoMerchantButtonClick:(id)sender {
    
    MemberCardDetailViewController *cardDetail = [MemberCardDetailViewController spawn];
    
    cardDetail.cardId = self.payOrderDetailModel.cardid;
    cardDetail.cardType = @"online";
    cardDetail.bid = [NSString stringWithFormat:@"%@",self.payOrderDetailModel.bid];
    [self.navigationController pushViewController:cardDetail animated:YES];
    
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
