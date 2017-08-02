//
//  ApplyViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyCell.h"
#import "ApplyDetailViewController.h"

static NSString *applyIdentifier = @"ApplyCell";

@interface ApplyViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextView *remarkTxt;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIView *tooltipBgView;

@property (weak, nonatomic) IBOutlet UIView *tooltipView;
@property (weak, nonatomic) IBOutlet UILabel *tooltipLabel;
@property (assign, nonatomic) int countDown;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *applySuccessLbl;

//存储我的申请列表的数据
@property (strong, nonatomic) NSMutableArray *dataArray;

//@property (strong, nonatomic) ApplyAuthrozationModel *applyModel;
//@property (strong, nonatomic) GetApplyListModel *applyListModel;

@property (assign, nonatomic) CGFloat tvHeight;
@property (assign, nonatomic) int count;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ApplyViewController

+(instancetype)spawn{
    return [ApplyViewController loadFromStoryBoard:@"EntranceGuard"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationBar];
    [self hideKeyBoard];
    
    [self registerNoti];
    
    if( GT_IOS7){
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.applySuccessLbl.textColor = BLUE_TEXTCOLOR;
    [self.phoneTxt addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.dataList = [NSMutableArray array];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:[UINib nibWithNibName:applyIdentifier bundle:nil] forCellReuseIdentifier:applyIdentifier];
    
    
    [self loadApplyListData];
    
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
    
    self.navigationItem.title = @"申请";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
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
    [self.remarkTxt resignFirstResponder];
}
#pragma mark-registerNot
-(void)registerNoti{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operateSuccess) name:@"APPLYSUCCESS" object:nil];
}
-(void)operateSuccess{
    [self loadApplyListData];
}
#pragma mark-加载申请列表
-(void)loadApplyListData{
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    ApplyListAPI *applistApi = [[ApplyListAPI alloc]init];
    applistApi.entranceGuardType = APPLY;
    [applistApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [_dataList addObject:[ApplyModel mj_objectWithKeyValues:dic]];
            }
            [self.tv reloadData];
            
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
#pragma mark-target
-(void)textChange:(UITextField *)txt{
    NSString *pwd = txt.text;
    
    NSUInteger length = pwd.length;
    
    if (length > 11){
         [self presentFailureTips:@"请输入正确的手机号码"];
        pwd = [pwd substringFrom:0 to:11];
        self.phoneTxt.text = pwd;
        return;
    }
    
    if (![pwd isNumText]) {
         [self presentFailureTips:@"请输入正确的手机号码"];
        return;
    }
    
    if (txt.text.length>=11) {
        self.submitBtn.backgroundColor = BUTTON_BLUECOLOR;
        [self.submitBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    }else {
        self.submitBtn.backgroundColor = BUTTON_GRAYCOLOR;
        [self.submitBtn setTitleColor:BUTTONGRAY_TEXTCOLOR forState:UIControlStateNormal];
        
    }
}

#pragma mark-UITextView的代理方法
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        
        [self.remarkLabel setHidden:NO];
        
    }else{
        
        [self.remarkLabel setHidden:YES];
        
        CGSize size=[self.remarkTxt sizeThatFits:CGSizeMake(self.remarkTxt.frame.size.width, MAXFLOAT)];
        
        if (size.height>30) {
            self.remarkHeight.constant = size.height;
        }else{
            self.remarkHeight.constant = 30;
        }
        self.remarkViewHeight.constant = 10+self.remarkHeight.constant;
        
        
        self.containerViewHeight.constant=250-40+self.remarkViewHeight.constant+self.tvHeight;
        
//        self.containerViewHeight.constant=218-40+self.remarkViewHeight.constant;
    }
}




#pragma mark-click

- (IBAction)tooltipbgViewClick:(id)sender {
    if (self.tooltipBgView.hidden == NO) {
        if (_timer) {
            [_timer invalidate];
        }
        self.tooltipBgView.hidden = YES;
        self.tooltipView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}


//确定
- (IBAction)sureButtonClick:(id)sender {
    
    NSString *account = self.phoneTxt.text;
    NSString *memo = self.remarkTxt.text;
    
    if ([ISNull isNilOfSender:account]) {
         [self presentFailureTips:@"手机号码不能为空"];
        return;
    }
    if (account.length<11) {
        [self presentFailureTips:@"请输入正确的手机号码"];
        return;
    }
    [self.view endEditing:YES];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ApplyAPI *applyApi = [[ApplyAPI alloc]initWithAccount:account memo:memo];
    [self presentLoadingTips:nil];
    [applyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            self.countDown = 6;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            

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
    self.tooltipBgView.hidden=NO;
    self.tooltipView.hidden = NO;
    
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


#pragma mark-tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.containerViewHeight.constant=246+self.tvHeight;
    
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:applyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.dataList.count > indexPath.row) {
        cell.data = self.dataList[indexPath.row];
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyCell *cell = (ApplyCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (_count<self.dataList.count) {
        
        self.tvHeight+=cell.cellHeight;
        self.containerViewHeight.constant=250+self.tvHeight;
        _count+=1;
        
    }
    
    return [cell cellHeight];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataList.count > indexPath.row) {
        ApplyModel *applyModel = self.dataList[indexPath.row];

        ApplyDetailViewController *applyDetail = [[ApplyDetailViewController alloc]init];
        
        applyDetail.apply = applyModel;
        
        [self.navigationController pushViewController:applyDetail animated:YES];
        
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
