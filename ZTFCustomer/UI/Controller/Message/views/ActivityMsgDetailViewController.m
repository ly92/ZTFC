//
//  ActivityMsgDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ActivityMsgDetailViewController.h"

@interface ActivityMsgDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblHeight;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

//不参加
@property (weak, nonatomic) IBOutlet UIButton *noJoinButton;
//参加
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
//未参加
@property (weak, nonatomic) IBOutlet UIButton *notJoinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noJoinButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (nonatomic, assign) NSInteger isJoin;

@property (nonatomic, strong) ActivityMsg_extinfoModel *msg_extinfo;
@property (nonatomic, strong) CardMsgDetailModel *msg;



@end

@implementation ActivityMsgDetailViewController

+(instancetype)spawn{
    return [ActivityMsgDetailViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];

    [self setStyle];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
    self.noJoinButtonWidth.constant =(SCREENWIDTH-30)/2.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar

-(void)setNavigationBar{
    
    self.navigationItem.title = @"商家活动";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark-style
-(void)setStyle{
    
    self.noJoinButton.backgroundColor = NoJoinButtonColor;
    [self.noJoinButton setTitleColor:TEXTCONTENTCOLOR forState:UIControlStateNormal];
    
    self.joinButton.backgroundColor = JoinButtonColor;
    [self.joinButton setTitleColor:TEXTCONTENTCOLOR forState:UIControlStateNormal];
    
    self.notJoinButton.backgroundColor = NotJoinButtonColor;
    [self.notJoinButton setTitleColor:TEXTCONTENTCOLOR forState:UIControlStateNormal];
    
    
    self.noJoinButton.layer.cornerRadius = 4;
    self.joinButton.layer.cornerRadius = 4;
    self.notJoinButton.layer.cornerRadius = 4;
    
}

#pragma mark-加载数据
-(void)loadData{
    if (!self.relatedId) {
        return;
    }
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    MerchantMsgDetailAPI *merchantMsgDetailApi = [[MerchantMsgDetailAPI alloc]initWithMsgId:self.relatedId];
    
    [merchantMsgDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        ActivityDetailResultModel *result = [ActivityDetailResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            
            self.msg = result.Msg;
            self.msg_extinfo = result.msg_extinfo;
            [self prepareData];
            
        }else{
             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
    
    
}

-(void)prepareData{
    
    self.contentLbl.text = self.msg.content;
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    self.contentLblHeight.constant = contentHeight;
    self.contentViewHeight.constant = contentHeight + 50;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.msg.creationtime intValue]]]];
    
    self.isJoin = [self.msg_extinfo.is_join intValue];
    
    [self joinStatus];
    
    self.containerViewHeight.constant = 200 - 100 + self.contentViewHeight.constant;
}

-(void)joinStatus{
    if (self.isJoin == 3) {
        //2个按钮，未表态
        self.noJoinButton.hidden = NO;
        self.joinButton.hidden = NO;
        self.notJoinButton.hidden = YES;
    }else if (self.isJoin == 1){
        //表态，已参加
        self.notJoinButton.hidden = YES;
        self.joinButton.hidden = YES;
        self.notJoinButton.hidden = NO;
        [self.notJoinButton setTitle:@"已参加" forState:UIControlStateNormal];
        
    }else if (self.isJoin == 0){
        self.notJoinButton.hidden = YES;
        self.joinButton.hidden = YES;
        self.notJoinButton.hidden = NO;
        [self.notJoinButton setTitle:@"未参加" forState:UIControlStateNormal];
    }
}


#pragma mark-click

//不参加
- (IBAction)noJoinButtonClick:(id)sender {
    [self joinOrNot:@"0"];
}

//参加
- (IBAction)joinButtonClick:(id)sender {
    [self joinOrNot:@"1"];
}

-(void)joinOrNot:(NSString *)joinOrNot{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    [self presentLoadingTips:nil];
    JoinActivityAPI *joinActivityApi = [[JoinActivityAPI alloc]initWithId:self.msg_extinfo.info.id isJoin:joinOrNot];
    [joinActivityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if(![ISNull isNilOfSender:result] && [result[@"result"]intValue] == 0){
            [self dismissTips];
            
//            ActivityInfoModel *info = [ActivityInfoModel mj_objectWithKeyValues:result[@"info"]];
            
            self.isJoin = [result[@"is_join"] intValue];
            [self joinStatus];
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
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
