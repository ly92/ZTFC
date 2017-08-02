//
//  RechargeRecordDetailViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RechargeRecordDetailViewController.h"

@interface RechargeRecordDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation RechargeRecordDetailViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self prepareData];
    
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
    
    
    self.navigationItem.title = @"充值详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

-(void)prepareData{
//    NSString *status;
//    switch ([self.rechargeDetailModel.status integerValue]) {
//        case 99:
//        {
//            status = @"交易成功";
//        }
//            break;
//        case 1:
//        {
//            status = @"已付款";
//        }
//            break;
//        case 98:
//        {
//            status = @"取消订单";
//        }
//            break;
//        case 90:
//        {
//            status = @"已退款";
//        }
//            break;
//        case 0:
//        {
//            status = @"待付款";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self.statusLabel setText:status];
//    [self.statusLabel setTextColor:[UIColor colorWithStatusName:status]];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[self.rechargeDetailModel.money floatValue]]];
//    [self.paymentLabel setText:self.rechargeDetailModel.payment];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    [self.timerLabel setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.rechargeDetailModel.creationtime intValue]]]];
    self.timerLabel.text = self.rechargeDetailModel.create_time;
//    [self.snLabel setText:self.rechargeDetailModel.tradeNo];
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
