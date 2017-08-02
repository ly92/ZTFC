//
//  ActivityController.m
//  KaKaTool
//
//  Created by fengwanqi on 13-12-25.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#import "ActivityController.h"
//#import "UIButton+StrechableBgImage.h"
#import "CardPromotionModel.h"
#import "JoinActivityAPI.h"


@interface ActivityController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeighr;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *noJoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (strong, nonatomic) Msg_Extinfo *msgInfo;
@property (strong, nonatomic) PromotionInfo *info;

@property (nonatomic,assign)int isjoin;

//@property (copy, nonatomic) NSString *creationtime;
@property (nonatomic, strong) PromotionModel *promotion;
//@property (nonatomic,copy)NSString *mid;

//
//@property (nonatomic,copy)NSString *joinUsers;
//@property (retain, nonatomic) IBOutlet UITextView *txtContent;
//@property (retain, nonatomic) IBOutlet UIButton *btnJoin;
//- (IBAction)backClicked:(id)sender;
//- (IBAction)joinClicked:(id)sender;
//@property (retain, nonatomic) IBOutlet UIButton *btnNoJoin;
//- (IBAction)noJoinClicked:(id)sender;
//
//@property (retain, nonatomic) IBOutlet UILabel *lblJoinOrNot;
//
//@property (retain, nonatomic) IBOutlet UILabel *lblJoinUsers;
//
//@property (retain, nonatomic) IBOutlet UIButton *btnBack;
//@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
//@property (nonatomic, strong) CARD_PROMOTION_CardList *msgInfo;

@end

@implementation ActivityController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.noJoinBtn.clipsToBounds = YES;
    self.noJoinBtn.layer.cornerRadius = 8;
    
    self.joinBtn.clipsToBounds = YES;
    self.joinBtn.layer.cornerRadius = 8;
    
    self.statusBtn.clipsToBounds = YES;
    self.statusBtn.layer.cornerRadius = 8;
    
}

-(instancetype)initWithMsgInfo:(Msg_Extinfo *)msgInfo creationtime:(PromotionModel *)creationtime{
    if (self = [super init]) {
        self.msgInfo = msgInfo;
        self.info = self.msgInfo.info;
        self.promotion = creationtime;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if (self.promotion.bid) {
        
        [[LocalizePush shareLocalizePush] updateLoaclCardId:self.promotion.bid Kind:Events];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    }
    
    //导航栏数据
    [self setupNavigationBtn];
    
    
    //准备数据
    [self prepareData];
    
}
-(void)updateViewConstraints{
    self.btnWidth.constant = (SCREENWIDTH-30)/2.0;
    [super updateViewConstraints];
}
//设置导航栏的左右按钮
-(void)setupNavigationBtn{
    self.navigationItem.title = @"详情";
    //返回
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)prepareData{
    //内容
    self.contentLabel.text = self.info.intro;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.width, MAXFLOAT)];
    
    self.labelHeighr.constant = size.height;
    
    self.topViewHeight.constant = 50+size.height;
    
    self.containerViewHeight.constant = self.topViewHeight.constant + 60;
    
    //时间
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[self.promotion.creationtime intValue]];
    NSString *str = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = str;
    
    //判断是否参加活动
    self.isjoin = [self.msgInfo.is_join intValue];
    if (self.isjoin == 3) {
        //表示默认没有参加活动
        self.noJoinBtn.hidden = NO;
        self.joinBtn.hidden = NO;
        self.statusBtn.hidden = YES;;
    }
    else if (self.isjoin == 1)
    {
        self.noJoinBtn.hidden = YES;
        self.joinBtn.hidden = YES;
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"已参加" forState:UIControlStateNormal];
    }
    
    else if (self.isjoin == 0)
    {
        self.noJoinBtn.hidden = YES;
        self.joinBtn.hidden = YES;
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"未参加" forState:UIControlStateNormal];
    }
    
}

#pragma mark-点击方法

//不参加
- (IBAction)noJoinClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定不参加该活动吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    //    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"确定不参加该活动吗？" leftButtonTitle:@"不参加" rightButtonTitle:@"参加"];
    //    [alert show];
    //    alert.leftBlock = ^{
    //        [self joinEventOrNot:@"0"];
    //    };
    //    alert.rightBlock = ^{
    //        [self joinEventOrNot:@"1"];
    //    };
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        
        [self joinEventOrNot:@"0"];
    }
}
//参加
- (IBAction)joinClick:(id)sender {
    [self joinEventOrNot:@"1"];
}

-(void)joinEventOrNot:(NSString *)joinOrNot
{
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    
    [self presentLoadingTips:nil];
    
    JoinActivityAPI *joinActivityApi = [[JoinActivityAPI alloc]initWithId:self.info.ID isJoin:joinOrNot];
    [joinActivityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if(![ISNull isNilOfSender:result] && [result[@"result"]intValue] == 0){
            [self dismissTips];
            
            self.isjoin = [result[@"is_join"] intValue];
            
            if (self.isjoin == 3) {
                //表示默认没有参加活动
                self.noJoinBtn.hidden = NO;
                self.joinBtn.hidden = NO;
                self.statusBtn.hidden = YES;;
            }
            else if (self.isjoin == 1)
            {
                self.noJoinBtn.hidden = YES;
                self.joinBtn.hidden = YES;
                self.statusBtn.hidden = NO;
                [self.statusBtn setTitle:@"已参加" forState:UIControlStateNormal];
            }
            //
            else if (self.isjoin == 0)
            {
                self.noJoinBtn.hidden = YES;
                self.joinBtn.hidden = YES;
                self.statusBtn.hidden = NO;
                [self.statusBtn setTitle:@"未参加" forState:UIControlStateNormal];
            }
            
            //刷新上一个界面
            if ([self.activityDelegate respondsToSelector:@selector(refreshData)]){
                [self.activityDelegate refreshData];
            }
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
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

@end
