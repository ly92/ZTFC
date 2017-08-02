//
//  MemberCardDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardDetailViewController.h"

#import "FeedBackViewController.h"
#import "CardOrderListTableViewController.h"
#import "CardSubBranchViewController.h"
#import "SubscribeMerchantViewController.h"
#import "CardPromotionTableViewController.h"
#import "CardPointTableViewController.h"
#import "CardTransactionTableViewController.h"
#import "VoucherTableViewController.h"
#import "RechargeComboListControllerViewController.h"
#import "PopCouponSN.h"

#define CARTOON_B_C_URL @"http://kakatool.com/?B=%@&C=%@"

@interface MemberCardDetailViewController ()<UIAlertViewDelegate>

//控件
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UIView *containerView;
//frontimgurl
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *shopName;
//类别
@property (weak, nonatomic) IBOutlet UILabel *shopCategory;
@property (weak, nonatomic) IBOutlet UILabel *shopTel;
@property (weak, nonatomic) IBOutlet UILabel *callLbl;

//@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
@property (weak, nonatomic) IBOutlet UILabel *GPSLbl;

//@property (weak, nonatomic) IBOutlet UIButton *addressButton;

//无分店时，显示成没有其他分店，并且不可点
@property (weak, nonatomic) IBOutlet UILabel *subbranchShopLbl;
//@property (weak, nonatomic) IBOutlet UIButton *subbranchShopbutton;

@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *pointLbl;

//折扣（无折扣时，隐藏该view）
@property (weak, nonatomic) IBOutlet UILabel *discountLbl;

//底部按钮的视图
@property (strong, nonatomic) UIView *bottomView;//

//
@property (assign, nonatomic) int numOfSecFive;//需要判断是否有折扣
@property (assign, nonatomic) BOOL haveSubBranch;//是否有分店

@property (nonatomic, strong)Card *card;
@property (nonatomic,strong)Bizswitch *bizswitch;
@property (nonatomic, copy) NSString *kakapay;
@property (nonatomic, retain) NSString *enable;//app是否支持在线支付
@property (nonatomic, strong) NSArray *subbranchArray;

@property (nonatomic, strong) NSURL *callUrl;

@property(nonatomic,assign) NSNumber *LonLct;
@property(nonatomic,assign) NSNumber *LatLct;
@property (strong, nonatomic) UIButton *qrCodeBtn;//二维码按钮
@property (nonatomic, strong) PopCouponSN *popView;

@end

@implementation MemberCardDetailViewController

+(instancetype)spawn{
    return [MemberCardDetailViewController loadFromStoryBoard:@"CardDetail"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.callLbl.textColor = BLUE_TEXTCOLOR;
    self.GPSLbl.textColor = BLUE_TEXTCOLOR;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.numOfSecFive = 4;
    [self setNavigationBar];
    
    [self registerNoti];
    
    [self checkKakaPay];
    [self loadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    //设置底部按钮栏
    [self prepareBottomView];
    
    //卡信息：推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgCardAdWithPush:) name:@"PushMsgCardAd" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //去除底部按钮栏
    [self.bottomView removeFromSuperview];
}
-(void)msgCardAdWithPush:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSString *cardId = [userInfo objectForKey:@"cardId"];
    
    [[LocalizePush shareLocalizePush] removeBudgleCardId:cardId KindArray:[NSArray arrayWithObjects:CardMsg,Votes,Events, nil]];
}
#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    
    self.qrCodeBtn = [[UIButton alloc] initWithSize:CGSizeMake(30, 30)];
    
    [self.qrCodeBtn setImage:[UIImage imageNamed:@"d1_crcode"] forState:UIControlStateNormal];
    self.qrCodeBtn.hidden = YES;
    [self.qrCodeBtn addTapAction:@selector(showQrcode) forTarget:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.qrCodeBtn];
    
    self.LatLct = [AppLocation sharedInstance].location.lat;
    self.LonLct = [AppLocation sharedInstance].location.lon;
    
//    [self loadCardInfo];
    
//    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"d1_crcode"] handler:^(id sender) {
//        
//        
//        
//    }];
    
}
#pragma mark - 二维码
- (void)showQrcode{
    //会员卡二维码
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    NSString *qrcode = [NSString stringWithFormat:CARTOON_B_C_URL,self.card.bid,user.cid];
    
    if (self.popView == nil) {
        self.popView = [[PopCouponSN alloc] initWithParentController:self.parentViewController];
    }
    if (self.popView) {
        [self.popView showCard:qrcode];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.popView];
}
#pragma mark-registerNoti
-(void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RECHARGE_PAY_SUCCESS" object:nil];
    
    //积分，充值推送
    //商户为我充值,商户给我扣款
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"chargeMoney" object:nil];
    
    //积分充值,积分消费
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"pointsTransaction" object:nil];
}

#pragma mark-bottom
- (void)prepareBottomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50)];

    //反馈，我的订单，分享会员卡
    NSArray *nameArray = @[@"反馈",@"我的订单",@"分享会员卡"];
    NSArray *imgArray = @[@"d1_feedback",@"d1_order",@"d1_share"];
    CGFloat w = SCREENWIDTH / 3.0;
    CGFloat imgX = (w - 20) / 2.0;
    for (int i = 0; i < nameArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(w * i, 0, w, 50)];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 10, 20, 20)];
        imgV.image = [UIImage imageNamed:imgArray[i]];
        [view addSubview:imgV];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, w, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = RGBCOLOR(39, 162, 240);
        label.text = nameArray[i];
        [view addSubview:label];

        switch (i) {
            case 0:
                [view addTapAction:@selector(feedbackClick) forTarget:self];
                break;
            case 1:
                [view addTapAction:@selector(myorderClick) forTarget:self];
                break;
            case 2:
                [view addTapAction:@selector(shareMemberCardClick) forTarget:self];
                break;
                
            default:
                break;
        }
        
        [self.bottomView addSubview:view];
    }
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    topLine.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.bottomView addSubview:topLine];
    
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.bottomView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bottomView];
}

//反馈
- (void)feedbackClick{
    NSLog(@"反馈");
    if (!self.card.businessinfo.bid) {
        return;
    }
    FeedBackViewController *feedbackVC = [[FeedBackViewController alloc] initWithBid:self.card.businessinfo.bid];
    
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
//我的订单
- (void)myorderClick{
    NSLog(@"我的订单");
    if (!self.card.bid) {
        return;
    }
    CardOrderListTableViewController *orderListVC = [[CardOrderListTableViewController alloc] initWithBid:self.card.bid];
    [self.navigationController pushViewController:orderListVC animated:YES];
}

//预约商家
- (IBAction)bookClick {
     NSLog(@"预约商家");
   
    SubscribeMerchantViewController *subscribeVC = [[SubscribeMerchantViewController alloc] initWithBid:self.card.bid Tel:self.card.businessinfo.tel];
    [self.navigationController pushViewController:subscribeVC animated:YES];
}

//全部商品
- (IBAction)allShopsClick {
     NSLog(@"全部商品");
    //https://api.kakatool.com/
    NSString *baseURL = @"https://api.kakatool.com/";
    baseURL = [baseURL stringByReplacingOccurrencesOfString:@"v1/" withString:@""];
    //商品列表不支持https协议
    if ([baseURL containsString:@"https"]) {
        baseURL = [baseURL stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@""];
    }
    NSLog(@"baseURL = %@",baseURL);
    NSString *urlStr     = [NSString stringWithFormat:@"%@production/index.html?bid=%@&token=%@",baseURL,self.card.bid,[LocalData getAccessToken]];
    
    WebViewController *web = [WebViewController spawn];
    web.isShop = YES;
    web.webURL = urlStr;
    web.webTitle = @"全部商品";
    [self.navigationController pushViewController:web animated:YES];
    
   
}

#pragma mark-加载数据
//网络加载数据
-(void)loadData{
    
    if (!self.cardId || !self.cardType) {
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    MemberCardDetailAPI *memberCardDetailApi = [[MemberCardDetailAPI alloc]initWithCardId:self.cardId cardType:self.cardType];
    [memberCardDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [[UIApplication sharedApplication].keyWindow.rootViewController  dismissTips];
        MemberCardDetailResultModel *result = [MemberCardDetailResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            [SVProgressHUD dismiss];
            self.card = result.Card;
            self.subbranchArray = result.branch;
            self.bizswitch = result.bizswitch;
            self.kakapay = result.kakapay;
            [self.tv reloadData];
            [self prepareData];
        }
        else{
             [[UIApplication sharedApplication].keyWindow.rootViewController  presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [[UIApplication sharedApplication].keyWindow.rootViewController  presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [[UIApplication sharedApplication].keyWindow.rootViewController  presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

//布局数据
-(void)prepareData{
    
    if ([self.bizswitch.p2p intValue] == 1) {
        
        self.qrCodeBtn.hidden = NO;
    }else{
         self.qrCodeBtn.hidden = YES;
    }
    [self.iconImgView setImageWithURL:[NSURL URLWithString:self.card.frontimageurl] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
    
    
    self.shopName.text = self.card.cardname;
    self.shopCategory.text = self.card.businessinfo.industryname;
    
    self.shopTel.text = self.card.businessinfo.tel;
    
    self.shopAddress.text = self.card.businessinfo.address;
    
    if (self.subbranchArray.count == 0) {
        self.subbranchShopLbl.text = @"没有其他分店";
        self.haveSubBranch = NO;
    }else{
        self.haveSubBranch = YES;
    }
    
    self.balanceLbl.text = self.card.amounts;
    self.pointLbl.text = self.card.points;
    
    if ([self.card.discounts isEqualToString:@"0"]) {
        self.numOfSecFive = 3;
    }else{
        self.discountLbl.text = self.card.discounts;
    }
    
    [self.tableView reloadData];
}

-(void)checkKakaPay{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    
    CheckForKakaPayAPI *checkForkakaPayApi = [[CheckForKakaPayAPI alloc]initWithAppId:APP_ID];
    [checkForkakaPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            self.enable = result[@"enable"];
            
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

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
        {
            if ([self.kakapay intValue] != 0 && [self.enable intValue] != 0){
                return 3;
            }else{
                return 2;
            }
            
        }
            break;
        case 3:
            return 1;
            break;
        case 4:
            return self.numOfSecFive;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 85;
            break;
        case 1:
            
            if (indexPath.row == 0){
                return 44;
            }else if (indexPath.row == 1){
                return 70;
            }else{
                if (self.shopAddress.resizeHeight > 21){
                    return 70 - 21 + self.shopAddress.resizeHeight;
                }else{
                    return 70;
                }
            }
            break;
        default:
            return 44;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 || section == 1)
    {
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:

            break;
        case 1:
            if(indexPath.row == 1){
                //商家电话
                NSLog(@"商家电话");
                NSString *tel = self.card.businessinfo.tel;
                if ([tel containsString:@"-"]) {
                    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                }
                tel = [tel trim];
                
                NSString *realnum = [NSString stringWithFormat:@"tel://%@",tel];
                self.callUrl=[NSURL URLWithString:realnum];
                
                
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (indexPath.row == 2){
                //商家地址，导航
                 NSLog(@"商家地址，导航");
                [self callMapShowPathFromCurrentLocation];
            }
            break;
        case 2:
            if (indexPath.row == 0){
                //商家代金券
                 NSLog(@"我的优惠券");
                VoucherTableViewController *voucherVC = [[VoucherTableViewController alloc] initWithBid:self.card.bid];
                
                voucherVC.refreshBadgeBlock = ^(){
                    
                };
                [self.navigationController pushViewController:voucherVC animated:YES];
                
            }else if(indexPath.row == 1){
                //商家促销
                 NSLog(@"商家促销");
                CardPromotionTableViewController *promotionVC = [[CardPromotionTableViewController alloc] initWithBid:self.card.bid Name:self.card.cardname];
                [self.navigationController pushViewController:promotionVC animated:YES];
            }else if(indexPath.row == 2){
                //充值套餐
                RechargeComboListControllerViewController *recharge = [[RechargeComboListControllerViewController alloc]initWithBid:self.bid IconUrl:self.card.frontimageurl Name:self.card.cardname];
                
                [self.navigationController pushViewController:recharge animated:YES];
                
            }
            break;
        case 3:
            //其他分店
            if (self.haveSubBranch){
                 NSLog(@"其他分店");
                CardSubBranchViewController *subBranch = [[CardSubBranchViewController alloc] initWithBranchArray:self.subbranchArray];
                [self.navigationController pushViewController:subBranch animated:YES];

            }
            break;
        case 4:
            if(indexPath.row == 1){
                //余额
                 NSLog(@"余额");
                CardTransactionTableViewController *transactionVC = [[CardTransactionTableViewController alloc] initWithBid:self.card.bid Name:self.card.cardname];
                [self.navigationController pushViewController:transactionVC animated:YES];
            }else if (indexPath.row == 2){
                //积分
                 NSLog(@"积分");
                UserModel *user = [[LocalData shareInstance] getUserAccount];
                CardPointTableViewController *pointVC = [[CardPointTableViewController alloc] initWithBid:self.card.bid Cid:user.cid Name:self.card.cardname];
                [self.navigationController pushViewController:pointVC animated:YES];

            }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] openURL:self.callUrl]) {
            [[UIApplication sharedApplication] openURL:self.callUrl];
        }
        else
        {
             [self presentFailureTips:@"此设备无法拨打电话"];
        }
    }
}


-(void)callMapShowPathFromCurrentLocation{
    
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.card.businessinfo.latitude doubleValue], [self.card.businessinfo.longitude doubleValue]) addressDictionary:nil]];
        toLocation.name = self.card.businessinfo.address;
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
   }

//分享会员卡
- (void)shareMemberCardClick{
    NSLog(@"分享会员卡");
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance] getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *cShareTitle = [NSString stringWithFormat:@"%@邀请您立刻加入",self.card.cardname];
    NSString *cShareContent = [NSString stringWithFormat:@"一卡在手，优惠我有！还等什么？%@会员火热招募中……",self.card.cardname];
    
    NSString *cShareurl = [NSString stringWithFormat:@"http://kkt.me/w/%@/%@/%@",self.card.bid,tUserDetail.cid,APP_ID];
    NSLog(@"cShareurl-%@" ,cShareurl);
    
    
    NSURL *shareUrl = [NSURL URLWithString:cShareurl];
    
    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,cShareurl];
    NSString *cShareAllContent = [NSString stringWithFormat:@"%@！%@",cShareTitle,cShareTheme];
    
    
    //构造分享内容
    //常见分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:cShareAllContent
                                     images:self.card.frontimageurl
                                        url:shareUrl
                                      title:nil
                                       type:SSDKContentTypeAuto];
    
    
    //定制新浪微博
    [shareParams SSDKSetupSinaWeiboShareParamsByText:cShareContent
                                               title:cShareContent
                                               image:nil
                                                 url:shareUrl
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    
    
    //微信好友
    [shareParams SSDKSetupWeChatParamsByText:cShareContent
                                       title:nil
                                         url:shareUrl
                                  thumbImage:nil
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //微信朋友圈
    
    [shareParams SSDKSetupWeChatParamsByText:nil
                                       title:cShareContent
                                         url:shareUrl
                                  thumbImage:nil
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    //定制QQ空间信息
    
    [shareParams SSDKSetupQQParamsByText:nil
                                   title:cShareContent
                                     url:shareUrl
                              thumbImage:nil
                                   image:nil
                                    type:SSDKContentTypeAuto
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    //QQ好友
    [shareParams SSDKSetupQQParamsByText:nil
                                   title:cShareContent
                                     url:shareUrl
                              thumbImage:nil
                                   image:nil
                                    type:SSDKContentTypeAuto
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    //短信
    [shareParams SSDKSetupSMSParamsByText:cShareContent
                                    title:cShareContent
                                   images:nil
                              attachments:nil
                               recipients:nil
                                     type:SSDKContentTypeAuto];
    
    //,
//    @(SSDKPlatformSubTypeQZone),
//    @(SSDKPlatformTypeSMS)
    //定义菜单分享列表
    [ShareSDK showShareActionSheet:nil
                             items:@[
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   if (state == SSDKResponseStateSuccess)
                   {
                       [self presentSuccessTips:@"分享成功"];
                       
                   }
                   else if (state == SSDKResponseStateFail)
                   {
                        [self presentFailureTips:@"分享失败,请重试"];
                       
                   }
                   
               }];
}

@end
