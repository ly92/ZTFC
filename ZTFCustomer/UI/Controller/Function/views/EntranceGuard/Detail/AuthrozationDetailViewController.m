//
//  AuthrozationDetailViewController.m
//  colourlife
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "AuthrozationDetailViewController.h"
#import "AuthrozationViewController.h"


#define MainScreenBoundsSize [UIScreen mainScreen].bounds.size

@interface AuthrozationDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoLabelHeight;

//信息
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;

@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet UITextField *communityField;

//授权时间的选择

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twnHourLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneDayLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sevDayLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneYearLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *everLeading;


@property (weak, nonatomic) IBOutlet UIButton *twoHourImg;
@property (weak, nonatomic) IBOutlet UIButton *oneDayImg;
@property (weak, nonatomic) IBOutlet UIButton *sevDayImg;
@property (weak, nonatomic) IBOutlet UIButton *oneYearImg;
@property (weak, nonatomic) IBOutlet UIButton *everImg;


//通过
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
//拒绝
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet UIButton *passBtn1;

//确认授权
//@property (strong, nonatomic) ApproveApplyModel *approveApplyModel;

@property (nonatomic, strong) NSMutableArray *communityArray;//小区列表数据
@property (nonatomic, strong) UITableView *communityTable;
@property (nonatomic, strong) UIControl *communityControl;

//@property (nonatomic, strong) AuthrozationAgainModel *authAgainModel;

@property (nonatomic, copy) NSString *authTime;
@property (nonatomic, copy) NSString *bid;


@end

@implementation AuthrozationDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.passBtn.clipsToBounds=YES;
    self.passBtn.layer.cornerRadius=8;
    self.refuseBtn.clipsToBounds=YES;
    self.refuseBtn.layer.cornerRadius=8;
    
    self.passBtn1.clipsToBounds=YES;
    self.passBtn1.layer.cornerRadius=8;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    if ( GT_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //设置导航栏的数据
    [self setupNavgationBar];
    
    [self createCommunityTable];
    
    
    if (self.allowAuthArr.count == 0) {
        //获取可授权小区列表
        [self loadAllowAuthCommunity];
    }else{
        [self prepareDataAllowAuth];
    }
    
    //准备数据
    [self prepareData];
    
    self.authTime = @"0";
    
   
}
//设置导航栏的数据
-(void)setupNavgationBar{
    self.navigationItem.title=@"授权";
    self.navigationItem.leftBarButtonItem=[AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)updateViewConstraints{
    
    self.twnHourLeading.constant = self.oneDayLeading.constant = self.sevDayLeading.constant = self.oneYearLeading.constant = self.everLeading.constant = (SCREENWIDTH-45*5)/6.0;
    
    [super updateViewConstraints];
    
}
-(void)autoArrangeBoxWithConstraints:(NSArray *)constraintsArray width:(CGFloat)width{
    CGFloat step=(self.view.frame.size.width-(width * constraintsArray.count))/(constraintsArray.count+1);
    for (int i=0; i<constraintsArray.count; i++) {
        
        NSLayoutConstraint *constraint=constraintsArray[i];
        constraint.constant=step * (i+1)+width*i;
    }
}


#pragma mark-loadAllowAuthCommunity

-(void)loadAllowAuthCommunity{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    ApplyListAPI *allowAuth = [ApplyListAPI alloc];
    allowAuth.entranceGuardType = ALLOWAUTHCOMMUNITY;
    
    [allowAuth startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSArray *arr = result[@"communitylist"];
            
            for (NSDictionary *dic in arr) {
                [self.allowAuthArr addObject:[Community mj_objectWithKeyValues:dic]];
            }
            
            [self prepareDataAllowAuth];
            
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
}

-(void)prepareDataAllowAuth{
    if (self.allowAuthArr.count > 0) {
        Community  *cmt = (Community *)self.allowAuthArr[0];
        self.bid = [NSString stringWithFormat:@"%@",cmt.bid];
        self.communityField.text = cmt.name;
        cmt.selected = YES;
    }
    else{
        self.communityField.text = nil;
    }
    
    [self.communityTable reloadData];
    
}

#pragma mark - 创建小区列表
- (void)createCommunityTable
{
    _communityControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, MainScreenBoundsSize.width, MainScreenBoundsSize.height-64)];
    
    if (GT_IOS7) {
        
    }
    _communityControl.hidden = YES;
    _communityControl.clipsToBounds = YES;
    _communityControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_communityControl addTarget:self action:@selector(hideCommunityControl:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_communityControl];
    [self.view bringSubviewToFront:_communityControl];
    
    //小区列表
    //    int count = self.communityArray.count;
    int count = 3;
    if (count >= 3) {
        count = 4;
    }
    else {
        count += 1;
    }
    
    _communityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _communityControl.height-40*count, MainScreenBoundsSize.width, 40*count)];
    _communityTable.delegate = self;
    _communityTable.dataSource = self;
    _communityTable.showsVerticalScrollIndicator = NO;
    _communityTable.bounces = NO;
    
    [_communityControl addSubview:_communityTable];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenBoundsSize.width, 40)];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenBoundsSize.width, 39)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = @"小区选择";
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:17];
    [header addSubview:titleLbl];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MainScreenBoundsSize.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:line];
    
    self.communityTable.tableHeaderView = header;
    
    if (GT_IOS7) {
        _communityTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

//隐藏小区列表
- (void)hideCommunityControl:(id)sender
{
    [self showCommunityTable:NO];
}

- (void)showCommunityTable:(BOOL)cshow
{
    [self.view endEditing:YES];
    
    NSInteger count = self.allowAuthArr.count;
  
    if (count >= 3) {
        count = 4;
    }
    else {
        count += 1;
    }
    
    if (cshow) {
        
        self.communityTable.y = self.communityControl.height;
        self.communityControl.hidden = NO;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.communityTable.y = self.communityControl.height - 40*count;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.35 animations:^{
            self.communityTable.y = self.communityControl.height;
            
        } completion:^(BOOL finished) {
            
            _communityControl.hidden = YES;
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//准备数据
-(void)prepareData{
    
    
    //判断状态
    //未批复
    int type = [self.apply.type intValue];
    if (type == 1) {
        //未批复
        if (self.apply.isdeleted == 0) {
            self.passBtn.hidden = NO;
            self.refuseBtn.hidden = NO;
            self.passBtn1.hidden = YES;
        }else{
            
        }
    }
    //通过
    else{
//        int usertype = [self.apply.usertype intValue];
        if ([self.apply.isdeleted intValue] == 1) {
            //已失效
            self.passBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.passBtn1.hidden = NO;
        }
        else{
            self.passBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
        }
    }
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[self.apply.creationtime intValue]];
    NSString *time = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.applyDateLabel.text = time;
    
    self.memoLabel.text = self.apply.memo;
    
    CGFloat memoHeight=[self.memoLabel resizeHeight];
    
    if (memoHeight > 20) {
         self.memoLabelHeight.constant=memoHeight;
    }else{
        self.memoLabelHeight.constant = 20;
    }

    self.memoViewHeight.constant=20+self.memoLabelHeight.constant;
    
    self.communityLabel.text = self.apply.name;
    
    self.containerViewheight.constant=320-40+self.memoViewHeight.constant;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.communityField) {
        if (self.allowAuthArr.count<=1) {
            [self showCommunityTable:NO];
            [self.communityTable reloadData];
        }else{
            [self showCommunityTable:YES];
            [self.communityTable reloadData];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark-点击事件

- (IBAction)twoHourClick:(id)sender {
    self.twoHourImg.selected=YES;
    self.oneDayImg.selected=NO;
    self.sevDayImg.selected=NO;
    self.oneYearImg.selected=NO;
    self.everImg.selected=NO;
    
    self.authTime = @"0";
}

- (IBAction)oneDayClick:(id)sender {
    self.twoHourImg.selected=NO;
    self.oneDayImg.selected=YES;
    self.sevDayImg.selected=NO;
    self.oneYearImg.selected=NO;
    self.everImg.selected=NO;
    
    self.authTime = @"1";
}
- (IBAction)wevDayClick:(id)sender {
    self.twoHourImg.selected=NO;
    self.oneDayImg.selected=NO;
    self.sevDayImg.selected=YES;
    self.oneYearImg.selected=NO;
    self.everImg.selected=NO;
    
    self.authTime = @"2";
}

- (IBAction)oneYearClick:(id)sender {
    self.twoHourImg.selected=NO;
    self.oneDayImg.selected=NO;
    self.sevDayImg.selected=NO;
    self.oneYearImg.selected=YES;
    self.everImg.selected=NO;
    
       self.authTime = @"3";
}
- (IBAction)everClick:(id)sender {
    self.twoHourImg.selected=NO;
    self.oneDayImg.selected=NO;
    self.sevDayImg.selected=NO;
    self.oneYearImg.selected=NO;
    self.everImg.selected=YES;
    
    self.authTime = @"4";
}

//通过授权
- (IBAction)passClick:(id)sender {
    [self authReply:@"1"];
}

//拒绝授权
- (IBAction)refuseClick:(id)sender {
    
    [self authReply:@"2"];
    
}

-(void)authReply:(NSString *)approve{
    
    if (self.bid.length == 0) {
        return;
    }
    
    NSString *applyid = self.apply.id;
    NSString *autype = @"1";//默认限时
    NSString *granttype = [NSString stringWithFormat:@"%@",self.apply.granttype];//默认没有二次授权
    NSString *starttime = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    NSString *usertype = @"4";//默认2小时
    NSString *memo = self.apply.memo;
    
    switch ([self.authTime intValue]) {
            
            break;
        case 1: //一天
            usertype = @"3";
            
            stoptime = [[[NSDate date] dateByAddingDays:1]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            break;
        case 2: //7天
            usertype = @"2";
            
            stoptime = [[[NSDate date] dateByAddingDays:7]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            break;
        case 3: //一年
            usertype = @"5";
            
            stoptime = [[[NSDate date] dateByAddingYears:1]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;

        case 4: //永久
            usertype = @"1";
            granttype = @"1";
            autype = @"2";
            
            starttime = @"0000-00-00 00:00:00";
            
            break;
            
        default:
            break;
    }
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    ApplyApproveAPI *applyApproveApi = [[ApplyApproveAPI alloc]initWithApplyid:applyid approve:approve autype:autype usertype:usertype granttype:granttype bid:self.bid starttime:starttime stoptime:stoptime memo:memo];
    [applyApproveApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AUTHAGAINSUCCESS" object:nil];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
        }

        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

//再次授权通过
- (IBAction)passBtn1Click:(id)sender {
    if (self.bid.length == 0) {
        return;
    }
    
    NSString *autype = [NSString stringWithFormat:@"%@",self.apply.autype];//默认限时
    NSString *granttype = [NSString stringWithFormat:@"%@",self.apply.granttype];//默认没有二次授权
    
   NSString *starttime = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    NSString *usertype = @"4";//默认2小时
    NSString *memo = self.apply.memo;
    
    switch ([self.authTime intValue]) {
            
            break;
        case 1: //一天
            usertype = @"3";
            
            stoptime = [[[NSDate date] dateByAddingDays:1]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            break;
        case 2: //7天
            usertype = @"2";
            
            stoptime = [[[NSDate date] dateByAddingDays:7]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            break;
        case 3: //一年
            usertype = @"5";
            
            stoptime = [[[NSDate date] dateByAddingYears:1]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 4: //永久
            usertype = @"1";
            granttype = @"1";
            autype = @"2";
            
            starttime = @"0000-00-00 00:00:00";
            
            break;
            
        default:
            break;
    }

    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    AuthAgainAPI *authAgainApi = [[AuthAgainAPI alloc]initWithAutype:autype toid:self.apply.toid bid:self.bid usertype:usertype granttype:granttype starttime:starttime stoptime:stoptime memo:memo];
    
    [authAgainApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AUTHAGAINSUCCESS" object:nil];
            
            
            for (UIViewController* tempVC in [self.navigationController viewControllers]) {
                if ([tempVC isKindOfClass:[AuthrozationViewController class]]) {
                    [self.navigationController popToViewController:tempVC animated:YES];
                }
            }
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
}


#pragma mark-tableView的代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allowAuthArr.count;
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier = @"AllowAuthCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].firstObject;
        }
        if (self.allowAuthArr.count>0) {
            
            Community *community = self.allowAuthArr[indexPath.row];
            
            cell.data = community;
            
        }
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
        //可授权小区列表
        if (self.allowAuthArr.count>0) {
            Community *community = self.allowAuthArr[indexPath.row];
            if (community) {
                community.selected = !community.selected;
                self.communityField.text = community.name;
                self.bid = [NSString stringWithFormat:@"%@",community.bid];
                 [self resetCommunityState:indexPath.row];
            }
            [self hideCommunityControl:nil];
            [self.communityTable reloadData];
        }
}

//除当前选择的小区，恢复其他的默认值
- (void)resetCommunityState:(NSInteger)index
{
    if (self.allowAuthArr.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.allowAuthArr.count; i++) {
        Community *cm = (Community *)self.allowAuthArr[i];
        if (i != index) {
            cm.selected = NO;
        }
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
