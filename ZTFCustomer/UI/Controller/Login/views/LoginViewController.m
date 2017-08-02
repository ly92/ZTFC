//
//  LoginViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/25.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPswController.h"
#import "InvitationCodeLoginController.h"
#import "HuanxinService.h"


@interface LoginViewController ()

//控件
@property (weak, nonatomic) IBOutlet UITextField *mobileInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *eyesButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property (weak, nonatomic) IBOutlet UILabel *rememberLbl;
@property (weak, nonatomic) IBOutlet UIButton *bigRememberButton;

@property (weak, nonatomic) IBOutlet UIButton *forgetPassworBtn;

@end

@implementation LoginViewController

+(instancetype)spawn{
    return [LoginViewController loadFromStoryBoard:@"Login"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //设置导航栏
    [self setNavigationBar];
    
    self.loginButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.loginButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 4;
    self.rememberLbl.textColor = BLUE_TEXTCOLOR;
    [self.forgetPassworBtn setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    
    [self registerNoti];
    //隐藏键盘
    [self hideKeyBoard];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    NSString *isRemember = [STICache.global objectForKey:@"RememberPsw"];
    NSString *isLogout = [STICache.global objectForKey:@"LOGOUT"];
    NSDictionary *dic = [LocalData fetchNormalUserInfo];
    if(dic){
        if ([isRemember isEqualToString:@"YES"]) {
            self.mobileInput.text = dic[@"account"];
            self.passwordInput.text = dic[@"password"];
        }else{
            if ([isLogout isEqualToString:@"NO"]) {
                self.rememberButton.selected = YES;
                self.bigRememberButton.selected = YES;
            }else{
                self.rememberButton.selected = NO;
                self.bigRememberButton.selected = NO;
            }
            
            self.mobileInput.text = dic[@"account"];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-setup navibar

-(void)setNavigationBar{
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"注册" handler:^(id sender) {
        RegisterViewController *registercon = [RegisterViewController spawn];
        [self.navigationController pushViewController:registercon animated:YES];
    }];
    
//    self.navigationItem.leftBarButtonItem = [AppTheme itemWithContent:@"邀请码登陆" handler:^(id sender) {
//        InvitationCodeLoginController *invitationCode = [InvitationCodeLoginController spawn];
//        [self.navigationController pushViewController:invitationCode animated:YES];
//    }];
}


#pragma mark-hideKeyBoard

-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.mobileInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}


#pragma mark-registerNoti
-(void)registerNoti{
    //注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccountAndPsw) name:@"REGISTERSUCCESS" object:nil];
    
    //找回密码成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAccountAndPsw) name:@"FINDPSWSUCCESS" object:nil];
    
    //邀请码登陆成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(invitationLoginSuccess) name:@"INVITATIONCODELOGINSUCCESS" object:nil];
}

-(void)refreshAccountAndPsw{
    NSDictionary *dic = [LocalData fetchNormalUserInfo];
    self.mobileInput.text = dic[@"account"];
    self.passwordInput.text = dic[@"password"];
    
}

-(void)invitationLoginSuccess{
    
}

#pragma mark-click
//登录
- (IBAction)loginClick:(id)sender {
    
    NSString *userName = [self.mobileInput.text trim];
    NSString *pwd = [self.passwordInput.text trim];
    if (userName.length == 0) {
        [self presentFailureTips:@"请输入用户名"];
        return;
    }
    
//    if (userName.length != 11) {
//        [self presentFailureTips:@"请输入正确的用户名"];
//        return;
//    }
    
    [self presentLoadingTips:nil];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
    //获取当前位置
    Location *location = [AppLocation sharedInstance].location;
    NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
    NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
    
    LoginAPI *loginApi = [[LoginAPI alloc]initWithNormalWithMobile:userName password:pwd lat:lat lng:lon];
    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
         if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
             
             UserModel *user = [UserModel mj_objectWithKeyValues:content[@"userinfo"]];
             
//             UserModel *user = [UserModel mj_objectWithKeyValues:result[@"user"]];
             
             if (user) {
                 
                 //更新user到本地
                [[LocalData shareInstance] updateUserAccount:user];
             
                [[HuanxinService shareInstance]login];
                 
                 //设置极光推送开关打开
                 [JPUSHService setTags:[NSSet setWithObjects:[NSString stringWithFormat:@"%@_c_%@",APP_ID,[LocalData shareInstance].getUserAccount.mobile], nil] alias:[LocalData shareInstance].getUserAccount.mobile callbackSelector:nil object:nil];
                 
                 //更新access_token到本地
//                 [STICache.global setObject:user.access_token forKey:@"ACCESSTOKEN"];
                 [LocalData updateAccessToken:user.access_token];
                 //更新用户名、密码
                 [LocalData updateNormalUserInfo:userName Psw:pwd];
                 
                 if (self.rememberButton.selected == YES) {
                     [STICache.global setObject:@"YES" forKey:@"RememberPsw"];
                 }else{
                     [STICache.global setObject:@"NO" forKey:@"RememberPsw"];
                 }
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];
                 [[AppDelegate sharedAppDelegate]registerDevice];
                 //登陆成功
                 [[AppDelegate sharedAppDelegate] setupRootViewController];
                 
             }
             
         }else{
              [self presentFailureTips:result[@"message"]];
             
         }
    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
}
//忘记密码
- (IBAction)forgetPwdClick:(id)sender {
    FindPswController *findPsw = [FindPswController spawn];
    [self.navigationController pushViewController:findPsw animated:YES];
}
//查看密码
- (IBAction)seePwdClick:(id)sender {
    if (self.passwordInput.secureTextEntry == YES)
    {
        self.passwordInput.secureTextEntry = NO;
        [self.eyesButton setImage:[UIImage imageNamed:@"a1_eyes"] forState:UIControlStateNormal];
    }
    else{
        self.passwordInput.secureTextEntry = YES;
        [self.eyesButton setImage:[UIImage imageNamed:@"a1_eye_closed"] forState:UIControlStateNormal];
    }
}
//记住密码
- (IBAction)rememberPswButtonClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        //记住密码
        self.rememberButton.selected = YES;
        
    }else{
        //不记住密码
        self.rememberButton.selected = NO;
    }
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectZero];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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
