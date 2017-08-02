//
//  CashierViewController.m
//  ZTFCustomer
//
//  Created by wangshanshan on 16/9/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CashierViewController.h"
#import "PayTypeTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>

@interface CashierViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *payList;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UITableView *payTV;
//需支付金额
@property (weak, nonatomic) IBOutlet UILabel *paymentMoneyLbl;
//还需支付金额
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLbl;

@property (nonatomic,copy)NSString *accounttype;

@end

@implementation CashierViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setnavigationBar];
    [self.payTV registerNib:@"PayTypeTableViewCell"];
    
    self.payMoneyLbl.text = [NSString stringWithFormat:@"¥ %@",self.totalMoney];
    self.paymentMoneyLbl.text = [NSString stringWithFormat:@"¥ %@",self.totalMoney];
    
    PayListModel *payType = [[PayListModel alloc]init];
    payType.name= @"微信";
    payType.icon = @"img_wxpay";
    payType.accounttype = @"推荐安装微信5.0及以上版本的使用";
    
    PayListModel *payType1 = [[PayListModel alloc]init];
    payType1.name= @"支付宝";
    payType1.icon = @"img_alipay";
    payType1.accounttype = @"推荐有支付宝帐号的用户使用";
    
    
    [self.payList addObject:payType];
    [self.payList addObject:payType1];
    [self.payTV reloadData];

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

-(NSMutableArray *)payList{
    if (!_payList) {
        _payList = [NSMutableArray array];
    }
    return _payList;
}
#pragma mark-navibar
-(void)setnavigationBar{
    
    self.navigationItem.title = @"收银台";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



- (IBAction)confirmBtnClick:(id)sender {
    
    
    [self presentFailureTips:@"暂未开通支付"];
    
//    NSString *sns=[self.choosedSns componentsJoinedByString:@","];
//    if (!self.couponMonyStr) {
//        self.couponMonyStr=@"";
//    }
//    
//    NSString *chargeAmount = [self.amountLbl.text substringFromIndex:1];//获取需要支付的金额数
//    //参数为总金额，内容，备注，需支付金额，余额，优惠券抵用额度，优惠码，支付类型
//    
//    if (![ISNull isNilOfSender:self.payList]) {
//        PayListModel *type = _payList[self.indexPath.row];
//        
//        
//        [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
//        
//        GetPayOrderAPI *getpayOrderApi = [[GetPayOrderAPI alloc]initWithTnum:self.tnum amount:self.totalMoneyStr content:@"" memo:@"" chargeAmount:chargeAmount userBalance:[self.useRechargeStr trim] couponAmount:self.couponMonyStr couponSn:sns orgtype:@"" orgid:@"" orgAccount:@"" desttype:type.desttype destno:type.destno destaccount:type.destaccount];
//        
//        [self presentLoadingTips:nil];
//        [getpayOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//            [self dismissTips];
//            PayOrderResultModel *result =[PayOrderResultModel mj_objectWithKeyValues:request.responseJSONObject];
//            
//            if (result && [result.result intValue] == 0) {
//                
//                
//                self.callbackUrl = result.callback;
//                
//                WeiXinModel *weixin = result.weixin;
//                AlipayModel *alipay = result.alipay;
//                
//                if (weixin) {
//                    //微信
//                    
//                    if ([WXApi isWXAppInstalled]){
//                        
//                        //调起微信支付
//                        PayReq* req             = [[PayReq alloc] init];
//                        req.openID              = weixin.appId;
//                        req.partnerId           = weixin.partnerId;
//                        req.prepayId            = weixin.prepayId;
//                        req.nonceStr            = weixin.nonceStr;
//                        req.timeStamp           = [weixin.timeStamp intValue];
//                        req.package             = weixin.packageValue;
//                        req.sign                = weixin.sign;
//                        
//                        [WXApi sendReq:req];
//                        
//                    }else{
//                        [self presentFailureTips:@"请安装微信"];
//                    }
//                    
//                    
//                }else if (alipay){
//                    //支付宝
//                    [[AlipaySDK defaultService] payOrder:alipay.orderInfo fromScheme:ALI_PAY_KEY callback:^(NSDictionary *resultDic) {
//                        
//                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
//                            //支付成功
//                            [self paySuccessBack];
//                        }else{
//                            [self presentFailureTips:@"支付失败"];
//                            
//                        }
//                        
//                    }];
//                    
//                }else{
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECHARGE_PAY_SUCCESS" object:nil];
//                    
//                    [self paySuccessBack];
//                }
//                
//            }else{
//                [self presentFailureTips:result.reason];
//            }
//            
//        } failure:^(__kindof YTKBaseRequest *request) {
//            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
//        }];
//    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _payList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"PayTypeTableViewCell";
    
    PayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    if (_payList.count != 0){
        PayListModel *payType = _payList[indexPath.row];
        cell.name.text = payType.name;
        
        cell.icon.image = [UIImage imageNamed:payType.icon];
        
        cell.memoLbl.text = payType.accounttype;
        
//        cell.icon.imageURL = [NSURL URLWithString:payType.icon];
//        if ([payType.accounttype isEqualToString:@"weixin"]){
//            cell.memoLbl.text = @"推荐安装微信5.0及以上版本的使用";
//        }else{
//            cell.memoLbl.text = @"推荐有支付宝帐号的用户使用";
//        }
    }
    
    //默认选中第一个
    if (indexPath.row == 0){
        self.indexPath = indexPath;
        [self.payTV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//保证选中一个，重复选中等于取消选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexPath && self.indexPath.row == indexPath.row){
        [self.payTV deselectRowAtIndexPath:indexPath animated:YES];
        self.indexPath = nil;
        self.accounttype = @"";
    }else{
        self.indexPath = indexPath;
        PayListModel *payType = _payList[indexPath.row];
        //设置支付方式
        self.accounttype = payType.accounttype;
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
