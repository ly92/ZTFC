//
//  SettingPasswordController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SettingPasswordController.h"
#import "ForgetPayPwdViewController.h"

@interface SettingPasswordController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (nonatomic, strong) UITextField * mainTextField;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation SettingPasswordController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mainTextField becomeFirstResponder];
    [self clear];
    
    [self setNavigationBar];
//    [self.passwordView bk_whenTapped:^{
//        if ( !self.mainTextField.isFirstResponder )
//        {
//            [self.mainTextField becomeFirstResponder];
//            [self clear];
//        }
//    }];
    
//     [self setupPasswordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 清除支付密码框的内容
    [self clear];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"设置密码";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    if ( self.settingType == SETTING_PASSWORD_TYPE_OLD )
    {
        // 旧密码
        self.navigationItem.title = @"修改密码";
        self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"下一步" handler:^(id sender) {
            if ( self.mainTextField.text.length < 6 )
            {
                [self presentFailureTips:@"请至少输入六位支付密码"];
                return;
            }
            [self.mainTextField resignFirstResponder];
            [self checkOldPassword];
        }];
        self.titleLabel.text = @"请输入旧密码";
    }
    else if ( self.settingType == SETTING_PASSWORD_TYPE_NEW )
    {
        // 新密码
        self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"下一步" handler:^(id sender) {
            if ( self.mainTextField.text.length < 6 )
            {
                [self presentFailureTips:@"请至少输入六位支付密码"];
                return;
            }
            [self.mainTextField resignFirstResponder];
            SettingPasswordController * passwordVC = [SettingPasswordController spawn];
            passwordVC.popViewController = self.popViewController;
            passwordVC.resetPassword = self.mainTextField.text;
            passwordVC.passwordType = self.passwordType;
            passwordVC.messageCode = self.messageCode;
            passwordVC.settingType = SETTING_PASSWORD_TYPE_CONFIRM;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }];
        self.titleLabel.text = @"请设置支付密码";
    }
    else
    {
        // 确认密码
        self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"完成" handler:^(id sender) {
            if ( self.mainTextField.text.length < 6 )
            {
                [self presentFailureTips:@"请至少输入六位支付密码"];
                return;
            }
            if ( ![self.resetPassword isEqualToString:self.mainTextField.text] )
            {
                [self clear];
                [self presentFailureTips:@"两次输入密码不一致"];
                [self.mainTextField becomeFirstResponder];
                return;
            }
            [self.mainTextField resignFirstResponder];
            [self finishResetPassword];
        }];
        self.titleLabel.text = @"请确认支付密码";
    }
    [self setupPasswordView];
}

// 初始化支付密码输入框
- (void)setupPasswordView
{
    self.mainTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.passwordView.width, self.passwordView.height)];
    self.mainTextField.hidden = YES;
    self.mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordView addSubview:self.mainTextField];
    
    CGFloat margin = 8;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (2 * 45) - 5 * margin) / 6;
    
    for (int i = 0; i < 6; i++)
    {
        UITextField * textField = [[UITextField alloc] init];
        textField.tag = i;
        textField.enabled = NO;
        textField.secureTextEntry = YES;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [AppTheme lineColor].CGColor;
        textField.layer.borderWidth = [AppTheme onePixel];
        textField.frame = CGRectMake( i * (width + margin), 0, width, width);
        [self.passwordView addSubview:textField];
        [self.dataSource addObject:textField];
    }
}

- (void)textDidChange:(UITextField *)textField
{
    NSString *password = textField.text;
    
    if (password.length == self.dataSource.count)
    {
        [textField resignFirstResponder];//隐藏键盘
    }
    
    for (int i = 0; i < self.dataSource.count; i++)
    {
        UITextField *pwdtx = [self.dataSource objectAtIndex:i];
        if (i < password.length)
        {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
        else
        {
            pwdtx.text = nil;
        }
        
    }
}

// 检验旧的支付密码是否正确
- (void)checkOldPassword
{
    [self presentLoadingTips:nil];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    CheckOldPayPwdAPI *checkOldPayPwdApi = [[CheckOldPayPwdAPI alloc]initWithOldPayPwd:self.mainTextField.text];
    [checkOldPayPwdApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            SettingPasswordController * passwordVC = [SettingPasswordController spawn];
            passwordVC.popViewController = self.popViewController;
            passwordVC.passwordType = self.passwordType;
            passwordVC.settingType = SETTING_PASSWORD_TYPE_NEW;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }else{
            [self presentFailureTips:result[@"reason"]];
            [self clear];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
}

// 完成修改密码
- (void)finishResetPassword
{
    [self presentLoadingTips:nil];
    
    NSString *messageCode = self.messageCode;
    if (messageCode.length == 0) {
        messageCode = @"";
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    ResetPayPwdAPI *resetPayPwdApi = [[ResetPayPwdAPI alloc]initWithPassword:self.mainTextField.text code:messageCode];
    resetPayPwdApi.passwordType = self.passwordType;
    [resetPayPwdApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
       
            if (self.passwordType == PASSWORD_TYPE_SET) {
                // 设置支付密码后返回我的饭票首页重新读取我的饭票功能
                [self fk_postNotification:@"SETPASSWORDSUCCESS"];
                
            }
            if ( self.popViewController )
            {
                [self.navigationController popToViewController:self.popViewController animated:YES];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }else{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"message"]];
            
            if (self.settingType == SETTING_PASSWORD_TYPE_OLD) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            
                for (UIViewController *tempVs in self.navigationController.viewControllers) {
                    if ([tempVs isKindOfClass:[ForgetPayPwdViewController class]]) {
                        [self.navigationController popToViewController:tempVs animated:YES];
                    }
                }
            }
            
            [self clear];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }

    }];
}

// 清除密码框里的信息
- (void)clear
{
    self.mainTextField.text = @"";
    [self textDidChange:self.mainTextField];
    [self.mainTextField becomeFirstResponder];
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
