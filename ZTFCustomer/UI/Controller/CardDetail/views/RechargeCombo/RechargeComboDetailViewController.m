//
//  RechargeComboDetailViewController.m
//  WeiTown
//
//  Created by 李勇 on 16/3/2.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "RechargeComboDetailViewController.h"
#import "PayTypeTableViewCell.h"
#import "PaySuccessViewController.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
#import "RechargeComboListControllerViewController.h"

@interface RechargeComboDetailViewController ()

@property (retain, nonatomic) IBOutlet UILabel *peiceLbl;
@property (retain, nonatomic) IBOutlet UILabel *nameLbl;
@property (retain, nonatomic) IBOutlet UILabel *amountsLbl;
@property (retain, nonatomic) IBOutlet UILabel *infoLbl;

@property (retain, nonatomic) IBOutlet UITableView *tv;
@property (retain, nonatomic) IBOutlet UIButton *payBtn;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *comboViewH;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *payviewH;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;


@property (nonatomic, retain) NSMutableArray *payList;//
@property (nonatomic,retain) NSIndexPath *indexPath;//

@property (nonatomic, retain) NSString *rechargeid;//

@property (nonatomic, retain) NSString *tnum;//
@property (nonatomic, retain) NSString *accounttype;//支付方式
@property (nonatomic, retain) NSString *callbackUrl;//支付回调地址


@end

@implementation RechargeComboDetailViewController

- (instancetype)initWithRechargeid:(NSString *)rechargeid{
    if (self = [super init]){
        self.rechargeid = rechargeid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    
    
    self.tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payRechargeSuccessBack) name:@"WX_PAY_BACK" object:nil];
    
    [self replayCombo];
    
    [self loadData];

}

#pragma mark-懒加载
-(NSMutableArray *)payList{
    if (!_payList) {
        _payList = [NSMutableArray array];
    }
    return _payList;
}


#pragma mark-navibar

-(void)setNavigationBar{
    self.navigationItem.title = @"支付";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)replayCombo{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    ReplyRechargeAPI *replyRechargeApi = [[ReplyRechargeAPI alloc]initWithRechargeId:self.rechargeid];
    replyRechargeApi.rechargeType = REPAYRECHARGE;
    
    [replyRechargeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            self.tnum = result[@"tnum"];
            [self loadPayWay];
            
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

- (void)loadPayWay{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    QueryPayInfAPI *queryPayInfoApi = [[QueryPayInfAPI alloc]initWithTnum:self.tnum];
    queryPayInfoApi.queryInfoType = QUERYPAYINFO;
    [queryPayInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSArray *payList = result[@"paylist"];
            for (NSDictionary *dic in payList) {
                [self.payList addObject:[PayListModel mj_objectWithKeyValues:dic]];
            }
            [self.tv reloadData];
            self.payviewH.constant = self.payList.count * 50;
            self.contentViewH.constant = CGRectGetMaxY(self.payBtn.frame) + 80;
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


- (void)loadData{
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    ReplyRechargeAPI *replyRechargeApi = [[ReplyRechargeAPI alloc]initWithRechargeId:self.rechargeid];
    replyRechargeApi.rechargeType = GETRECHARGEDETAIL;
    
    [replyRechargeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSDictionary *package = [result objectForKey:@"package"];
            self.peiceLbl.text = [package objectForKey:@"price"];
            self.nameLbl.text = [package objectForKey:@"name"];
            self.amountsLbl.text = [package  objectForKey:@"amounts"];
            self.infoLbl.text = [package objectForKey:@"info"];
//            [self.infoLbl resizeFrameWithWithText];
//            self.comboViewH.constant = 200 + self.infoLbl.frameSizeHeight + 15;
            
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

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _payList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
        [self.tv selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

//保证选中一个，重复选中等于取消选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexPath && self.indexPath.row == indexPath.row){
        [self.tv deselectRowAtIndexPath:indexPath animated:YES];
        self.indexPath = nil;
        self.accounttype = @"";
    }else{
        self.indexPath = indexPath;
        PayListModel *payType = _payList[indexPath.row];
        //设置支付方式r
        self.accounttype = payType.accounttype;
    }
}


- (IBAction)payClick:(id)sender {
    //    self.accounttype//支付方式
    //    self.choosedSns//选中的优惠卷sn
    //    self.amount.text//还需要支付的金额
    
    
    NSString *chargeAmount = self.peiceLbl.text;//获取需要支付的金额数
    
    //参数为总金额，内容，备注，需支付金额，余额，优惠券抵用额度，优惠码，支付类型
    
    if (![ISNull isNilOfSender:self.payList]) {
        PayListModel *type = _payList[self.indexPath.row];
        [self presentLoadingTips:nil];

        [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
        
        GetPayOrderAPI *getpayOrderApi = [[GetPayOrderAPI alloc]initWithTnum:self.tnum amount:chargeAmount content:@"" memo:@"" chargeAmount:chargeAmount userBalance:@"0" couponAmount:@"0" couponSn:@"" orgtype:@"" orgid:@"" orgAccount:@"" desttype:type.desttype destno:type.destno destaccount:type.destaccount];
        
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
                            [self payRechargeSuccessBack];
                        }else{
                             [self presentFailureTips:@"支付失败"];
                            
                        }
                        
                    }];
                    
                }else{
                    [self payRechargeSuccessBack];
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
- (void)payRechargeSuccessBack{
    PayListModel *payType = _payList[self.indexPath.row];
    
    [self.navigationController popViewControllerAnimated:NO];

    self.paySuccess(self.peiceLbl.text,payType.name,self.tnum);
}

@end
