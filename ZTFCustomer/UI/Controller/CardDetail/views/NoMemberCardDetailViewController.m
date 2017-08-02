//
//  NoMemberCardDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "NoMemberCardDetailViewController.h"
#import "AddMemberCardAPI.h"

@interface NoMemberCardDetailViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *shopCategory;

@property (weak, nonatomic) IBOutlet UILabel *shopTel;

@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopAddressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *addMemberButton;


@property (nonatomic, strong) NSURL *callUrl;

@property (nonatomic, strong) NoMemberCardInfo *info;

@end

@implementation NoMemberCardDetailViewController

+(instancetype)spawn{
    return [NoMemberCardDetailViewController loadFromStoryBoard:@"CardDetail"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.addMemberButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.addMemberButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.telButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.addressButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
    //加载数据
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
    self.navigationItem.title = @"详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-加载数据

-(void)loadData{
    if (!self.bid) {
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    NoMemberCardDetailAPI *noMemberCardDetailApi = [[NoMemberCardDetailAPI alloc]initWithBid:self.bid];
    [noMemberCardDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            self.info = [NoMemberCardInfo mj_objectWithKeyValues:result[@"info"]];
            
            [self prepareData];
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

-(void)prepareData{
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:self.info.bizcard.frontimageurl] placeholder:[UIImage imageNamed:@"cardImage_no_bg"]];
    
    self.shopName.text = self.info.name;
    self.shopCategory.text = self.info.industryname;
    
    self.shopTel.text = self.info.tel;
    
    self.shopAddress.text = self.info.address;
    self.shopAddress.width = SCREENWIDTH-45-100;
    
    self.shopAddressHeight.constant = [self.shopAddress resizeHeight]>20?[self.shopAddress resizeHeight]:20;
    self.viewHeight.constant = 141-20+self.shopAddressHeight.constant;
    self.containerViewHeight.constant = 240-141+self.viewHeight.constant;
    
}

#pragma mark-click

- (IBAction)addMemberClick:(id)sender {
    
    if (!self.info.bizcard.cardid) {
        return;
    }
    
    [self presentLoadingTips:nil];
    AddMemberCardAPI *addMemberApi = [[AddMemberCardAPI alloc] initWithCardId:self.info.bizcard.cardid Bid:self.bid RecommandId:@"0"];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [addMemberApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = request.responseJSONObject;
        if (result && [result[@"result"] intValue] == 0) {
            
            //刷新列表
            self.reloadData();
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDMEMBERCARDSUCCESS" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
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

- (IBAction)callClick:(id)sender {
    NSString *tel = self.info.tel;
    if ([tel containsString:@"-"]) {
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    tel = [tel trim];
    
    NSString *realnum = [NSString stringWithFormat:@"tel://%@",tel];
    self.callUrl=[NSURL URLWithString:realnum];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
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

- (IBAction)naviClick:(id)sender {
    
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.info.latitude doubleValue], [self.info.longitude doubleValue]) addressDictionary:nil]];
        toLocation.name = self.info.address;
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        

}


@end
