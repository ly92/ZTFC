//
//  PaySuccessViewController.m
//  WeiTown
//
//  Created by kakatool on 15/11/30.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PayOrderDetailController.h"


@interface PaySuccessViewController ()

@property (retain, nonatomic) IBOutlet UILabel *money;
@property (retain, nonatomic) IBOutlet UILabel *payWay;
@property (retain, nonatomic) IBOutlet UILabel *orderId;
@property (retain, nonatomic) IBOutlet UILabel *payTime;

@property (nonatomic, retain) NSString *tid;//

@property (nonatomic, retain) NSString *price;//
@property (nonatomic, retain) NSString *payway;//
@property (nonatomic, retain) NSString *orderid;//
@property (nonatomic, retain) NSString *paytime;//


@end

@implementation PaySuccessViewController


- (instancetype)initWithPrice:(NSString *)price Payway:(NSString *)payway Orderid:(NSString *)orderid{
    if (self = [super init]){
        self.price = price;
        self.payway = payway;
        self.orderid = orderid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];
    [self loadOrderInfo];
}

-(void)setNavigationBar{
    self.navigationItem.title = @"支付结果";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)layoutViews{
    self.money.text = self.price;
    self.payWay.text = self.payway;
    self.orderId.text = self.orderid;
    self.payTime.text = self.paytime;
}

- (void)loadOrderInfo{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    QueryPayInfAPI *queryPayResult = [[QueryPayInfAPI alloc]initWithTnum:self.orderid];
    queryPayResult.queryInfoType = QUERYPAYINFORESULT;
    
    [queryPayResult startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSDictionary *data = [result objectForKey:@"data"];
            self.tid = [data objectForKey:@"tid"];
            
            NSString *str = data[@"creationtime"];
            //            self.paytime
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            
            self.paytime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[str intValue]]];
            
            [self layoutViews];
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


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)goToOrderDetail:(id)sender {
    PayOrderDetailController *orderDetail = [PayOrderDetailController spawn];
    orderDetail.tid = self.tid;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

@end
