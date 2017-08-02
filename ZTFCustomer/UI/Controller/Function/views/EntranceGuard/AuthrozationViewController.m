//
//  AuthrozationViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AuthrozationViewController.h"
#import "AllowAuthCell.h"
#import "AuthrozationCell.h"
#import "AccessDetailViewController.h"
#import "AuthrozationDetailViewController.h"

static NSString *authIdentifier = @"AuthrozationCell";
@interface AuthrozationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoHourImgLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneDayImgLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sevDayImgLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneYearImgLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *everImgLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (weak, nonatomic) IBOutlet UIButton *twoHourImg;
@property (weak, nonatomic) IBOutlet UIButton *oneDayImg;
@property (weak, nonatomic) IBOutlet UIButton *sevDayImg;
@property (weak, nonatomic) IBOutlet UIButton *oneYearImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *everImg;


@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;

@property (weak, nonatomic) IBOutlet UITextField *communityTxt;
@property (weak, nonatomic) IBOutlet UITextView *memoTxt;

//备注信息
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;

//备注高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoHeight;
//备注view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoViewHeight;

//滚动视图可滚动的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIView *tooltipBgView;

@property (weak, nonatomic) IBOutlet UIView *tooltipView;
@property (weak, nonatomic) IBOutlet UILabel *tooltipLabel;
@property (weak, nonatomic) IBOutlet UILabel *authSuccessLbl;


//授权时间
@property (copy, nonatomic) NSString *authTime;
//小区id

@property (copy, nonatomic) NSString *bid;

@property (nonatomic, strong) UIControl *communityControl;
@property (nonatomic, strong) UITableView *communityTable;//小区列表
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *allowAuthArr;

@property (nonatomic, assign) CGFloat tvHeight;
@property (nonatomic, assign) int count;

@property (assign, nonatomic) int countDown;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AuthrozationViewController

+(instancetype)spawn{
    return [AuthrozationViewController loadFromStoryBoard:@"EntranceGuard"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationBar];

    [self setLayOut];
    [self registerNoti];
    
    self.allowAuthArr = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    
    [self.twoHourImg setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.oneDayImg setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.sevDayImg setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.oneYearImg setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.everImg setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    self.authSuccessLbl.textColor = BLUE_TEXTCOLOR;
    [self.phoneTxt addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:[UINib nibWithNibName:authIdentifier bundle:nil] forCellReuseIdentifier:authIdentifier];
    
    [self loadAuthList];
    
    //创建小区列表
    [self createCommunityTable];
    
    [self loadAllowAuthCommunity];

    
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
-(void)navigationBar{
    
    self.navigationItem.title = @"授权";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)setLayOut{
    
    
    self.twoHourImgLeading.constant = self.oneDayImgLeading.constant = self.sevDayImgLeading.constant = self.oneYearImgLeading.constant = self.everImgLeading.constant = (SCREENWIDTH-45*5)/6.0;
    
//    self.imgWidth.constant = self.imgHeight.constant = (SCREENWIDTH-6*15)/5.0;
//    self.authViewHeight.constant = 30+self.imgWidth.constant;
    self.authViewHeight.constant = 75;
    
}

#pragma mark-registerNot
-(void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operateSuccess) name:@"AUTHAGAINSUCCESS" object:nil];
}
-(void)operateSuccess{
    [self loadAuthList];
}
#pragma mark-hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.phoneTxt resignFirstResponder];
    [self.memoTxt resignFirstResponder];
}


#pragma mark-target
-(void)textChange:(UITextField *)textfield{
    NSString *pwd = textfield.text;
    
    NSUInteger length = pwd.length;
    
    if (length > 11 || ![pwd isNumText]){
         [self presentFailureTips:@"请输入11位电话号码"];
        pwd = [pwd substringFrom:0 to:11];
        self.phoneTxt.text = pwd;
        return;
    }
    if (textfield.text.length>=11&&self.communityTxt.text !=0) {
        self.confirmBtn.backgroundColor = BUTTON_BLUECOLOR;
        [self.confirmBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    }else{
        self.confirmBtn.backgroundColor = BUTTON_GRAYCOLOR;
        [self.confirmBtn setTitleColor:BUTTONGRAY_TEXTCOLOR forState:UIControlStateNormal];
    }
}

#pragma mark - 创建小区列表
- (void)createCommunityTable
{
    _communityControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    
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
    
    _communityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _communityControl.height-40*count, SCREENWIDTH, 40*count)];
    _communityTable.delegate = self;
    _communityTable.dataSource = self;
    _communityTable.showsVerticalScrollIndicator = NO;
    _communityTable.bounces = NO;
    
    [_communityControl addSubview:_communityTable];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 39)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = @"小区选择";
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:17];
    [header addSubview:titleLbl];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39,SCREENWIDTH, 1)];
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
    //    PRINT(@"community:%d",self.allowAuthModel.allowAuthList.count);
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

#pragma mark-可授权小区列表
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

#pragma mark-授权列表
-(void)loadAuthList{
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    ApplyListAPI *applistApi = [[ApplyListAPI alloc]init];
    applistApi.entranceGuardType = AUTHROZATION;
    [applistApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [_dataList removeAllObjects];
            [self dismissTips];
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [_dataList addObject:[ApplyModel mj_objectWithKeyValues:dic]];
            }
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

-(void)prepareData{
    if (self.allowAuthArr.count > 0) {
        Community  *cmt = (Community *)self.allowAuthArr[0];
        self.bid = [NSString stringWithFormat:@"%@",cmt.bid];
        self.communityTxt.text = cmt.name;
        cmt.selected = YES;
    }
    else{
        self.communityTxt.text = nil;
    }
    
    [self.communityTable reloadData];

}

#pragma mark-click

- (IBAction)tooltipBgViewClick:(id)sender {
    if (self.tooltipView.hidden == NO) {
        if (_timer) {
            [_timer invalidate];
        }
        self.tooltipBgView.hidden = YES;
        self.tooltipView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


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

- (IBAction)sevDayClick:(id)sender {
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
- (IBAction)everClcik:(id)sender {
    
    self.twoHourImg.selected=NO;
    self.oneDayImg.selected=NO;
    self.sevDayImg.selected=NO;
    self.oneYearImg.selected=NO;
    self.everImg.selected=YES;
    
    self.authTime = @"4";
}
//点击确定授权
- (IBAction)confirmClick:(id)sender {
    
    NSString *autype = @"1";//默认限时
    NSString *granttype = @"0";//默认没有二次授权
    NSString *starttime = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    NSString *usertype = @"4";//默认2小时
    NSString *mobile = self.phoneTxt.text;
    NSString *memo = self.memoTxt.text;
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"手机号码不能为空"];
        
        return;
    }
    else if (mobile.length != 11) {
         [self presentFailureTips:@"请输入正确的手机号"];
        return;
    }
    if (self.communityTxt.text.length == 0) {
         [self presentFailureTips:@"请选择小区"];
        [SVProgressHUD showErrorWithStatus:@"请选择小区"];
        return;
    }
    
    switch ([self.authTime intValue]) {
        case 0: //2小时
            usertype = @"4";
            
            stoptime = [[[NSDate date] dateByAddingHours:2]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            
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
    [self.view endEditing:YES];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    AuthAPI *authApi = [[AuthAPI alloc]initWithAutype:autype mobile:mobile bid:self.bid usertype:usertype granttype:granttype starttime:starttime stoptime:stoptime memo:memo];
    
    [authApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
//            self.refreshBlock();
            
            self.countDown = 6;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
//            [self.navigationController popViewControllerAnimated:YES];
            
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


//计算时间差，每一秒进行刷新
-(void)timerFireMethod:(NSTimer *)timer{
    _countDown--;
    if (_countDown==0) {
        self.tooltipBgView.hidden = YES;
        self.tooltipView.hidden = YES;
        [_timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.tooltipLabel.text = [NSString stringWithFormat:@"(提示：此页面将在%d秒内自动关闭，并返回到门禁首页)",self.countDown];
    [self fuwenbenLabel:self.tooltipLabel FontNumber:[UIFont systemFontOfSize:14] AndRange:NSMakeRange(9, 1) AndColor:RGBACOLOR(253, 61, 65, 1.0)];
    self.tooltipBgView.hidden = NO;
    self.tooltipView.hidden=NO;
    
}
//改变倒计时字体的颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}
#pragma mark-textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.communityTxt) {
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

#pragma mark-textview delegate

- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        
        [self.memoLabel setHidden:NO];
        
    }else{
        [self.memoLabel setHidden:YES];
        CGSize size=[self.memoTxt sizeThatFits:CGSizeMake(self.memoTxt.frame.size.width, MAXFLOAT)];
        if (size.height>30) {
            self.memoHeight.constant = size.height;
        }else{
            self.memoHeight.constant = 30;
        }
        self.memoViewHeight.constant=10+self.memoHeight.constant;
        
        self.containerViewHeight.constant=350-40+self.memoViewHeight.constant+self.tvHeight -80 + self.authViewHeight.constant;
    }
}

#pragma mark-tableView的代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tv) {
        if (self.dataList.count == 0) {
            self.containerViewHeight.constant = 350 -80 + self.authViewHeight.constant;
        }
        
        return self.dataList.count;
    }else{
        return self.allowAuthArr.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView == self.tv) {
        AuthrozationCell *cell = [tableView dequeueReusableCellWithIdentifier:authIdentifier];
        if (self.dataList.count > indexPath.row) {
            
            ApplyModel *apply = self.dataList[indexPath.row];
            
            
            cell.data = apply;
        }
        return cell;
        
        
    }else{
    
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tv) {
        
        AuthrozationCell *cell = (AuthrozationCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        if (_count<self.dataList.count) {
            
            self.tvHeight+=cell.cellHeight;
            self.containerViewHeight.constant=350-40+self.memoViewHeight.constant+self.tvHeight-80 + self.authViewHeight.constant;
            _count+=1;
           
        }
        return [cell cellHeight];
    }else{
         return 40;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (tableView == self.tv) {
        
        if (self.dataList.count > indexPath.row) {
            
            ApplyModel *apply = self.dataList[indexPath.row];
            
            int type = [apply.type intValue];
            
            if (type == 1) {
                //未批复
                AuthrozationDetailViewController *authrozationDetail=[[AuthrozationDetailViewController alloc]init];
                authrozationDetail.apply = apply;
                
                authrozationDetail.allowAuthArr = self.allowAuthArr;
                
                [self.navigationController pushViewController:authrozationDetail animated:YES];
                
            }
            else if (type == 2){
                //授权
                AccessDetailViewController *accessDetail = [[AccessDetailViewController alloc]init];
                accessDetail.apply = apply;
                
                accessDetail.allowAuthArr = self.allowAuthArr;
                
                accessDetail.authController = self;
                
                accessDetail.refreshBlock = ^(){
                    
                    [self.dataList removeAllObjects];
                    [self loadAuthList];
                    
                };
                
                [self.navigationController pushViewController:accessDetail animated:YES];
            }
            
            
        }
    }else{
    
        //可授权小区列表
        if (self.allowAuthArr.count>0) {
            Community *community = self.allowAuthArr[indexPath.row];
            if (community) {
                community.selected = !community.selected;
                self.communityTxt.text = community.name;
                self.bid = [NSString stringWithFormat:@"%@",community.bid];
                [self resetCommunityState:indexPath.row];
                
                if (self.phoneTxt.text.length>=11&&self.communityTxt.text !=0) {
                    self.confirmBtn.backgroundColor = BUTTON_BLUECOLOR;
                    [self.confirmBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
                }else{
                    self.confirmBtn.backgroundColor = BUTTON_GRAYCOLOR;
                    [self.confirmBtn setTitleColor:BUTTONGRAY_TEXTCOLOR forState:UIControlStateNormal];
                }
                
            }
            [self hideCommunityControl:nil];
            [self.communityTable reloadData];
        }
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
