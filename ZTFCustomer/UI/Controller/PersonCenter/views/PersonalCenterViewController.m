//
//  PersonalCenterViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/24.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonInformationController.h"
#import "ModifyPswController.h"
#import "MyCodeController.h"
#import "VoucherTableViewController.h"
#import "PayOrderListController.h"
#import "AboutViewController.h"
#import "WebViewController.h"
#import "MyBookController.h"
#import "MessageViewController.h"
#import "MyBookRootController.h"
#import "SettingController.h"
#import "MyDropController.h"
#import "CollectHouseViewController.h"
#import "ShareViewController.h"


@interface PersonalCenterViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UIImageView *pushImg;
@property (weak, nonatomic) IBOutlet UITableViewCell *payOrderCell;

@property (weak, nonatomic) IBOutlet UILabel *myDropLbl;
@property (nonatomic, retain) NSString *enable;//app是否支持在线支付

@end

@implementation PersonalCenterViewController

+(instancetype)spawn{
    return [PersonalCenterViewController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self checkKakaPay];
    
    _myDropLbl.text = [NSString stringWithFormat:@"我的%@",MyDropText];
    
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 35;
    self.tableView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    
    [self.tableView tableViewRemoveExcessLine];
    
    self.tableView.separatorColor = [AppTheme lineColor];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCoupon) name:@"getCoupon" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];
    }
    
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    NSLog(@"my coupon amount = %d",amount);
    
    if (amount != 0) {
        self.pushImg.hidden = NO;
    }
    else {
        self.pushImg.hidden = YES;
    }
    
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self getCounpCount];
//    _user = [UserModel sharedInstance].user;
    [self showUserInformation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//接收优惠券
-(void)getCoupon{
    
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    NSLog(@"my coupon amount = %d",amount);
    
    if (amount != 0) {
        self.pushImg.hidden = NO;
    }
    else {
        self.pushImg.hidden = YES;
    }
}

-(void)showUserInformation{
   
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if (user) {
        
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.iconurl] placeholder:MemberHeadImage];
        
        self.nameLbl.text = (user.realname.length>0)?user.realname:user.loginname;
        self.mobileLbl.text = user.mobile;
    }
    
}


-(void)checkKakaPay{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    CheckForKakaPayAPI *checkForkakaPayApi = [[CheckForKakaPayAPI alloc]initWithAppId:APP_ID];
    [checkForkakaPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            self.enable = result[@"enable"];
            if ( [self.enable intValue] == 0) {
                self.payOrderCell.hidden = YES;
            }
            [self.tableView reloadData];
            
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

#pragma mark-tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section == 2 )
    {
        return 5;
    }

    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        return 220;
    }
    
    if ( [self.enable intValue] == 0) {
        if (indexPath.section == 1 && indexPath.row == 5 ) {
            return 0;
        }
    }
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
    }else if ( indexPath.section == 1 ){
        if (indexPath.row == 0) {
            //我的铁豆
            MyDropController *myDrop = [MyDropController spawn];
            [self.navigationController pushViewController:myDrop animated:YES];
        }else if (indexPath.row == 1){
            //我的二维码名片
            
            MyCodeController *myCode = [MyCodeController spawn];
            [self.navigationController pushViewController:myCode animated:YES];
        }else if (indexPath.row == 2){
            //我的优惠券
            VoucherTableViewController *voucher = [[VoucherTableViewController alloc]init];
            voucher.isCouponTicket = YES;
            voucher.refreshBadgeBlock = ^(){
                
                [[LocalizePush shareLocalizePush] removeSettingWithCouponPushDic];
                self.pushImg.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
                
            };
            
            [self.navigationController pushViewController:voucher animated:YES];
            
        }else if (indexPath.row == 3){
            //我的预约
            MyBookRootController *myBook = [MyBookRootController spawn];
            [self.navigationController pushViewController:myBook animated:YES];
        }else if (indexPath.row == 4){
            //我的收藏
            CollectHouseViewController *collectHouseVC = [CollectHouseViewController spawn];
            [self.navigationController pushViewController:collectHouseVC animated:YES];
            
        }else if (indexPath.row == 5){
            //手机支付订单
            PayOrderListController *payOrder = [PayOrderListController spawn];
            [self.navigationController pushViewController:payOrder animated:YES];
        }
     
    }else if ( indexPath.section == 2 ){
        
        //分享给好友
        
        ShareViewController *shareViewCon = [ShareViewController spawn];
        [self.navigationController pushViewController:shareViewCon animated:YES];
        
    }
    
}

#pragma mark-click
//个人信息
- (IBAction)personalCenterClick:(id)sender {
    NSLog(@"personclick");
    
    PersonInformationController *personInformation = [PersonInformationController spawn];
    
    [self.navigationController pushViewController:personInformation animated:YES];
    
}

//信息
- (IBAction)messageClick:(id)sender {
    
    MessageViewController *message = [MessageViewController spawn];
    [self.navigationController pushViewController:message animated:YES];
    
    
}

- (IBAction)settingClick:(id)sender {
    
    SettingController *setting = [SettingController spawn];
    [self.navigationController pushViewController:setting animated:YES];
    
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
