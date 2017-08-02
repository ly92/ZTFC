//
//  ModifyMobileController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyMobileController.h"

@interface ModifyMobileController ()

@property (weak, nonatomic) IBOutlet UITextField *oldMobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet CountdownButton *sendVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

@end

@implementation ModifyMobileController


+(instancetype)spawn{
   return [ModifyMobileController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.modifyButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.modifyButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self.sendVerifyCodeButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self hideKeyBoard];
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
    
    self.navigationItem.title = @"修改手机";
    
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
    [self.oldMobileTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
}

#pragma mark-click

//发送验证码
- (IBAction)sendVerifyCodeButtonClick:(id)sender {
    
    
    NSString *mobile = [self.mobileTextField.text trim];
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入新手机号码"];
        return;
    }
    
    if (mobile.length !=11) {
         [self presentFailureTips:@"请输入正确的新手机号码"];
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    GetCodeAPI *getCodeApi = [[GetCodeAPI alloc]initWithMoblie:mobile];
    [getCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *) request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"已发送至您的手机，请注意查收"];
            //验证码倒计时操作
            [self.sendVerifyCodeButton start];
        }else{
            [self.sendVerifyCodeButton stop];
             [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.sendVerifyCodeButton stop];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];

}

//修改按钮
- (IBAction)modifyButtonClick:(id)sender {
    
    
    NSString *oldMobile = [self.oldMobileTextField.text trim];
    
    NSString *mobile = [self.mobileTextField.text trim];
    NSString *code = [self.verifyCodeTextField.text trim];
    
    
    if (oldMobile.length == 0) {
         [self presentFailureTips:@"请输入旧手机号码"];
        return;
    }
    
    
    if (oldMobile.length !=11) {
         [self presentFailureTips:@"请输入正确的旧手机号码"];
        return;
    }
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入新手机号码"];
        return;
    }
    
    if (mobile.length !=11) {
         [self presentFailureTips:@"请输入正确的新手机号码"];
        return;
    }
    
    
    if (code.length == 0) {
         [self presentFailureTips:@"请输入验证码"];
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ModifyMobileAPI *modifyMobileApi = [[ModifyMobileAPI alloc]initWithNewMobile:mobile verifyCode:code];
    
    [modifyMobileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSDictionary *muser = [result objectForKey:@"user"];
            
            if (![ISNull isNilOfSender:muser] ) {
                
                //更新用户信息
                UserModel *user = [[LocalData shareInstance]getUserAccount];
                user.loginname = muser[@"loginname"];
                user.mobile = muser[@"mobile"];
                [[LocalData shareInstance] updateUserAccount:user];
                
                
                //更新本地账号密码
                NSDictionary *dic = [LocalData fetchNormalUserInfo];
                if (dic) {
                    [LocalData updateNormalUserInfo:mobile Psw:dic[@"psw"]];
                }
                
                self.mobileBlock(self.mobileTextField.text);
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            
            
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 10;
}


@end
