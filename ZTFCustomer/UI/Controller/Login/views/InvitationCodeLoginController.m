//
//  InvitationCodeLoginController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "InvitationCodeLoginController.h"

@interface InvitationCodeLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *invitationCodeInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *eyesButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation InvitationCodeLoginController

+(instancetype)spawn{
    
    return [InvitationCodeLoginController loadFromStoryBoard:@"Login"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.loginButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.loginButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self hideKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"邀请码登陆";
    self.navigationItem.leftBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"icon_back"] handler:^(id sender) {
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
    [self.invitationCodeInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

#pragma mark-click
//查看密码
- (IBAction)eyesButtonClick:(id)sender {
    
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

//登陆
- (IBAction)loginButtonClick:(id)sender {
    
    NSString *code = [self.invitationCodeInput.text trim];
    
    if (code.length == 0) {
         [self presentFailureTips:@"请输入邀请码"];
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    InvitationCodeLoginAPI *invitationCodeApi = [[InvitationCodeLoginAPI alloc]initWithCode:code];
    
    [invitationCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            NSDictionary *userInfo = result[@"user"];
            if (![ISNull isNilOfSender:userInfo]) {
                
                UserModel *user = [UserModel mj_objectWithKeyValues:userInfo];
                
                [[LocalData shareInstance]updateUserAccount:user];
                [LocalData updateAccessToken:user.access_token];
                [LocalData updateNormalUserInfo:user.mobile Psw:user.loginname];
            }

            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"INVITATIONCODELOGINSUCCESS" object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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

@end
