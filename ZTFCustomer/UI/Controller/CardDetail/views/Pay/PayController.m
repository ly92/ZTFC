//
//  PayController.m
//  WeiTown
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "PayController.h"
#import "PayTypeTableViewCell.h"
#import "PayCouponViewController.h"
//#import "PayCarCoupon.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"


@interface PayController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *payList;//支付方式数据
@property (nonatomic, retain) NSMutableArray *couponlist;//优惠劵数据
@property (nonatomic, retain) NSMutableArray *choosedSns;//选中的优惠卷sn
@property (nonatomic,retain) NSIndexPath *indexPath;//上次点击的优惠劵索引

@property (nonatomic, retain) NSMutableArray *testarr;//仅为了将choosedSns传递（我不知道这么做的原因——ly）

@property (nonatomic, retain) NSString *amountStr;//需要支付的钱
@property (nonatomic, retain) NSString *totalMoneyStr;//总的钱
@property (nonatomic, retain) NSString *rechargeStr;//余额
@property (nonatomic, retain) NSString *useRechargeStr;//需要支付的钱
@property (nonatomic, retain) NSString *couponMonyStr;//优惠券抵用金额
@property (nonatomic, retain) NSString *accounttype;//支付方式

@property (nonatomic, retain) NSString *callbackUrl;//支付回调地址
@end

@implementation PayController

- (instancetype)initWithTnum:(NSString *)tnum{

    self = [super init];
    if (self){
        self.tnum = tnum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    
    self.couponMonyStr = @"";
    self.useRechargeStr = @"";
//    [self.useMoney addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.couponLabel addTapAction:@selector(useCoupon) forTarget:self];
 
    
    //键盘隐藏监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    
    
    //支付结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessBack) name:@"WX_PAY_BACK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessBack) name:@"ALI_PAY_BACK" object:nil];
    
    [self loadInfo];
    
}
#pragma mark-懒加载

-(NSMutableArray *)payList{
    if (!_payList) {
        _payList = [NSMutableArray array];
    }
    return _payList;
}

-(NSMutableArray *)choosedSns{
    if (!_choosedSns) {
        _choosedSns = [NSMutableArray array];
    }
    return _choosedSns;
}

-(NSMutableArray *)couponlist{
    if (!_couponlist) {
        _couponlist = [NSMutableArray array];
    }
    return _couponlist;
}



#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"收银台";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - 加载信息
- (void)loadInfo{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    QueryPayInfAPI *queryPayInfoApi = [[QueryPayInfAPI alloc]initWithTnum:self.tnum];
    
    queryPayInfoApi.queryInfoType = QUERYPAYINFO;
    
    [queryPayInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            //总钱数
            self.totalMoneyStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"amount"]];
            self.totalMoney.text = [NSString stringWithFormat:@"¥ %@元",self.totalMoneyStr];
            
            
            
            if ([self.totalMoneyStr floatValue] <= 0){
                //隐藏使用余额的view
                self.rechargeView.hidden = YES;
                self.rechargeViewH.constant = 0;
                //隐藏还需支付的view
                self.amountView.hidden = YES;
                self.amountViewH.constant = 0;
                //隐藏支付方式的view

                self.payView.hidden = YES;
                self.payViewH.constant = 0;
            }
            
            //使用余额
            self.rechargeStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"recharge"]];
            if ([self.rechargeStr floatValue] <= 0){
                //隐藏使用余额的view
                
                self.rechargeView.hidden = YES;
                self.rechargeViewH.constant = 0;
            }else{
                //显示使用余额的view
                self.rechargeView.hidden = NO;
                self.rechargeViewH.constant = 35;
            }
            
            //优惠劵相关
            for (NSDictionary *dict in [result objectForKey:@"couponlist"]) {
                RechargeCouponListModel *carC = [RechargeCouponListModel mj_objectWithKeyValues:dict];
                
                [self.couponlist addObject:carC];
            }
            
            for (NSDictionary *dict in [result objectForKey:@"paylist"]) {
                PayListModel *type = [PayListModel mj_objectWithKeyValues:dict];
                [self.payList addObject:type];

            }
            [self.payTV reloadData];
            
            //需要支付的钱
            self.amountStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"amount"]];
            
            [self setDataForSubViews];
            
            if (self.payList.count != 0 && [self.totalMoneyStr floatValue] > 0){
                self.payView.hidden = NO;
                self.payViewH.constant = self.payList.count * 60;
            }else{
               
                self.payView.hidden = YES;
                self.payViewH.constant = 0;
            }
            
            self.contentViewH.constant = CGRectGetMaxY(self.amountView.frame) + self.payViewH.constant + 80;
            
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        [self back];
    }];
}

- (void)setDataForSubViews{
    
    //默认未选择使用余额
    self.useRechargeBtn.selected = NO;
    self.rechargeLbl.text = @"";
    
    //优惠劵相关
    NSUInteger couponCount = self.couponlist.count;
    //如果有选择的优惠卷做相应处理
    if (self.choosedSns.count != 0){
        couponCount -= self.choosedSns.count;
        self.couponLabel.text = [NSString stringWithFormat:@"您使用%lu张,余%lu张优惠劵可用",(unsigned long)self.choosedSns.count,(unsigned long)couponCount];
        CGFloat couponMoney = 0;
        for (RechargeCouponListModel *carC in self.couponlist) {
            if ([self.choosedSns containsObject:carC.sn]){
                couponMoney += [carC.amount floatValue];
            }
        }
        self.couponMonyStr=[NSString stringWithFormat:@"%0.2f",couponMoney];
        
        self.amountStr = [NSString stringWithFormat:@"%0.2f",[self.totalMoneyStr floatValue] - [self.couponMonyStr floatValue]];
        self.couponMoney.text = [NSString stringWithFormat:@"¥ %0.2f",[self.couponMonyStr floatValue]];
        
        //如果优惠卷的金额大于需要支付金额，则隐藏支付方式view
        if ([self.amountStr floatValue] <= 0){
//            if ([self ceilFloat:[self.amountStr floatValue]] < 0){
//                [[WTAppDelegate sharedAppDelegate] showSucMsg:@"优惠卷金额大于需要支付金额" WithInterval:1.0f];
//            }
            self.couponMoney.text = [NSString stringWithFormat:@"¥ %0.2f",[self.totalMoneyStr floatValue]];
            
            self.payView.hidden = YES;
            self.payViewH.constant = 0;
            //隐藏使用余额的view
            self.rechargeView.hidden = YES;
            self.rechargeViewH.constant = 0;
            //隐藏还需支付的view
            self.amountView.hidden = YES;
            self.amountViewH.constant = 0;
        }else{
            //显示支付方式和余额的使用
              self.payView.hidden = NO;
              self.payViewH.constant = self.payList.count * 60;
              if ([self.rechargeStr floatValue] > 0){
                  //显示使用余额的view
                  self.rechargeView.hidden = NO;
                  self.rechargeViewH.constant = 35;
              }
            //显示还需支付的view
            self.amountView.hidden = NO;
            self.amountViewH.constant = 35;
        }
        self.contentViewH.constant = CGRectGetMaxY(self.amountView.frame) + self.payViewH.constant + 80;
        
    }
    else{
        //显示支付方式和余额的使用
        if ([self.totalMoneyStr floatValue] != 0){
            self.payView.hidden = NO;
            self.payViewH.constant = self.payList.count * 60;
            if ([self.rechargeStr floatValue] > 0){
                //显示使用余额的view
                self.rechargeView.hidden = NO;
                self.rechargeViewH.constant = 35;
            }
            //显示还需支付的view
            self.amountView.hidden = NO;
            self.amountViewH.constant = 35;
        }
        if (couponCount <= 0){
            self.couponLabel.text = [NSString stringWithFormat:@"您有0张优惠劵可用"];
            self.couponLabel.textColor = [UIColor grayColor];
            self.couponLabel.userInteractionEnabled = NO;
            self.useCouponBtn.userInteractionEnabled = NO;
        }else{
            self.couponLabel.text = [NSString stringWithFormat:@"您有%lu张优惠劵可用",(unsigned long)couponCount];
            self.couponLabel.textColor = RGBCOLOR(253, 140, 11);
            self.couponLabel.userInteractionEnabled = YES;
            self.useCouponBtn.userInteractionEnabled = YES;
        }
        self.couponMoney.text = @"¥ 0";
        self.amountStr = self.totalMoneyStr;
    }
    
    //需要支付的钱
    self.amountLbl.text = [NSString stringWithFormat:@"¥ %@",self.amountStr];
    if ([self.amountStr floatValue] <= 0){
        self.amountLbl.text = @"0";
        
        
        self.payView.hidden = YES;
        self.payViewH.constant = 0;
        //隐藏使用余额的view
        self.rechargeView.hidden = YES;
        self.rechargeViewH.constant = 0;
        //隐藏还需支付的view
        self.amountView.hidden = YES;
        self.amountViewH.constant = 0;
    }else{
        self.payView.hidden = NO;
        self.payViewH.constant = self.payList.count * 60;
        if ([self.rechargeStr floatValue] > 0){
            //显示使用余额的view
            self.rechargeView.hidden = NO;
            self.rechargeViewH.constant = 35;
        }
    }
}

//#pragma mark - 键盘监听
////输入使用金额时
//- (void)textChanged:(UITextField *)textF{
//    NSString *text = textF.text;
//    self.amount.text = [NSString stringWithFormat:@"¥ %@",self.amountStr];
//    double value = [text doubleValue];
//
//    if (0 <= value && value <= [self.rechargeStr doubleValue]){
//        double D_value = [self.amountStr doubleValue] - value;
//        
//        if (D_value < 0){
//            [[AppPlusAppDelegate sharedAppDelegate] showErrMsg:@"土豪您给的钱太多了" WithInterval:0.5];
//            if (text.length >= 1){
//                self.useMoney.text = [text substringToIndex:text.length - 1];
//            }
//            return;
//        }
//    }else{
//        [[AppPlusAppDelegate sharedAppDelegate] showErrMsg:@"请输入不超过余额的金额！" WithInterval:0.5];
//        if (text.length >= 1){
//            self.useMoney.text = [text substringToIndex:text.length - 1];
//        }
//        return;
//    }
//    
//}
//

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
        cell.icon.imageURL = [NSURL URLWithString:payType.icon];
        if ([payType.accounttype isEqualToString:@"weixin"]){
        cell.memoLbl.text = @"推荐安装微信5.0及以上版本的使用";
        }else{
        cell.memoLbl.text = @"推荐有支付宝帐号的用户使用";
        }
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

//#pragma mark - 键盘退出
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self contentClick];
//    return YES;
//}
//- (void)keyboardFrameChanged:(NSNotification *)noti{
//
//    CGRect keyFrame = [[[noti userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    
//    if (keyFrame.origin.y >= [UIScreen mainScreen].bounds.size.height){//隐藏
//        self.contentView.frameOriginY = 0;
//        [self contentClick];
//    }else{//显示
//        self.contentView.frameOriginY = -100;
//    }
//}

////滚动时释放amount第一响应者
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self contentClick];
//}

//- (IBAction)contentClick{
//    [self.useMoney resignFirstResponder];
//    
//    self.amount.text = [NSString stringWithFormat:@"¥ %0.2f",[self.amountStr doubleValue] - [self.useMoney.text doubleValue]];
//    
//    //如果不需要另外支付则隐藏支付方式view
//    if ([self.amountStr doubleValue] - [self.useMoney.text doubleValue] <= 0){
//        self.amount.text = @"¥ 0";
//        self.payView.hidden = YES;
//        self.payViewH.constant = 0;
//    }else{
//        self.payView.hidden = NO;
//        self.payViewH.constant = self.payList.count * 50;
//    }
//    
//    self.contentViewH.constant = CGRectGetMaxY(self.amountView.frame) + self.payViewH.constant + 80;
//}

- (IBAction)useRecharge {
    //需要支付的钱
    CGFloat amount = [self.amountStr floatValue];
    CGFloat recharge = [self.rechargeStr floatValue];
    
    if (self.useRechargeBtn.selected){
        [self setDataForSubViews];
    }else{
        if (recharge >= amount){
            //余额足以支付
            
            self.payView.hidden = NO;
            self.payViewH.constant = self.payList.count * 60;
            self.payView.hidden = YES;
            self.payViewH.constant = 0;
//            隐藏还需支付的view
            self.amountView.hidden = YES;
            self.amountViewH.constant = 0;
            
            self.amountStr = @"0";
            self.useRechargeStr = [NSString stringWithFormat:@"%0.2f",amount];
            self.rechargeLbl.text = [NSString stringWithFormat:@"¥ %0.2f",amount];
            
        }else{
            //余额不足以支付
            self.useRechargeStr = [NSString stringWithFormat:@"%0.2f",recharge];
            self.amountStr = [NSString stringWithFormat:@"%0.2f",amount - recharge];
            self.rechargeLbl.text = [NSString stringWithFormat:@"¥ %0.2f",recharge];
            self.payView.hidden = NO;
            self.payViewH.constant = self.payList.count * 60;
        }
        self.amountLbl.text = [NSString stringWithFormat:@"¥ %@",self.amountStr];
        self.useRechargeBtn.selected = YES;
    }
}




#pragma mark - 点击事件
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 使用优惠劵
- (IBAction)useCoupon {
    self.testarr = [NSMutableArray arrayWithArray:self.choosedSns];
    PayCouponViewController *carVC = [[PayCouponViewController alloc] initWithCarCoupons:self.couponlist CarCouponSns:self.testarr TotalMoney:self.totalMoneyStr];
    
    carVC.doneChoose = ^(NSMutableArray *arrayM){
        [self.choosedSns removeAllObjects];
        for (NSString *str in arrayM) {
            if (![self.choosedSns containsObject:str])
                [self.choosedSns addObject:str];
        }
        
        [self setDataForSubViews];
    };
    [self.navigationController pushViewController:carVC animated:YES];

}


- (IBAction)paySure {
//    self.accounttype//支付方式
//    self.choosedSns//选中的优惠卷sn
//    self.amount.text//还需要支付的金额
    
    NSString *sns=[self.choosedSns componentsJoinedByString:@","];
    if (!self.couponMonyStr) {
        self.couponMonyStr=@"";
    }
    
    NSString *chargeAmount = [self.amountLbl.text substringFromIndex:1];//获取需要支付的金额数
    //参数为总金额，内容，备注，需支付金额，余额，优惠券抵用额度，优惠码，支付类型
    
    if (![ISNull isNilOfSender:self.payList]) {
        PayListModel *type = _payList[self.indexPath.row];
        
        
        [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
        
        GetPayOrderAPI *getpayOrderApi = [[GetPayOrderAPI alloc]initWithTnum:self.tnum amount:self.totalMoneyStr content:@"" memo:@"" chargeAmount:chargeAmount userBalance:[self.useRechargeStr trim] couponAmount:self.couponMonyStr couponSn:sns orgtype:@"" orgid:@"" orgAccount:@"" desttype:type.desttype destno:type.destno destaccount:type.destaccount];
        
        [self presentLoadingTips:nil];
        [getpayOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            PayOrderResultModel *result =[PayOrderResultModel mj_objectWithKeyValues:request.responseJSONObject];
            
            if (result && [result.result intValue] == 0) {
                
                
                self.callbackUrl = result.callback;
                
                WeiXinModel *weixin = result.weixin;
                AlipayModel *alipay = result.alipay;
                
                if (weixin) {
                    //微信
                    
                    if ([WXApi isWXAppInstalled]){
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = weixin.appId;
                        req.partnerId           = weixin.partnerId;
                        req.prepayId            = weixin.prepayId;
                        req.nonceStr            = weixin.nonceStr;
                        req.timeStamp           = [weixin.timeStamp intValue];
                        req.package             = weixin.packageValue;
                        req.sign                = weixin.sign;
                        
                        [WXApi sendReq:req];
                        
                    }else{
                         [self presentFailureTips:@"请安装微信"];
                    }
                    
                    
                }else if (alipay){
                    //支付宝
                    [[AlipaySDK defaultService] payOrder:alipay.orderInfo fromScheme:ALI_PAY_KEY callback:^(NSDictionary *resultDic) {
                        
                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
                            //支付成功
                            [self paySuccessBack];
                        }else{
                             [self presentFailureTips:@"支付失败"];
                        }
                        
                    }];
                    
                }else{
                    
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"RECHARGE_PAY_SUCCESS" object:nil];
                    
                    [self paySuccessBack];
                }
                
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
}


#pragma mark - 支付回调
//支付回调
- (void)paySuccessBack{
    self.paySuccess(self.callbackUrl);
}

@end
