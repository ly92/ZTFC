//
//  ForgetPayPwdViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ForgetPayPwdViewController.h"
#import "SettingPasswordController.h"

@interface ForgetPayPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet CountdownButton *sendButton;

@end

@implementation ForgetPayPwdViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.sendButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self setNavigationBar];
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    self.mobileLabel.text = user.mobile;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    if (self.bindType == BIND_USER_TYPE_BIND) {
        self.navigationItem.title = @"设置密码";
    }else{
        self.navigationItem.title = @"修改密码";
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"下一步" handler:^(id sender) {
        [self next];
    }];
}

-(void)next {

    if ( self.messageTextField.text == nil || self.messageTextField.text.length == 0 )
    {
        [self presentFailureTips:@"请输入验证码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    SettingPasswordController * passwordVC = [SettingPasswordController spawn];
    passwordVC.popViewController = self.popViewController;
    passwordVC.messageCode = self.messageTextField.text;
    
    // 绑定用户信息
    if ( self.bindType == BIND_USER_TYPE_BIND )
    {
        passwordVC.settingType = SETTING_PASSWORD_TYPE_NEW;
        passwordVC.passwordType = PASSWORD_TYPE_SET;
    }
    else
    {
        // 忘记支付密码，重新设置支付密码
        passwordVC.settingType = SETTING_PASSWORD_TYPE_NEW;
        passwordVC.passwordType = PASSWORD_TYPE_RESET;
    }
    
    [self.navigationController pushViewController:passwordVC animated:YES];

   
}

#pragma mark-click
- (IBAction)sendButtonClick:(id)sender {
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    GetCodeAPI *getCodeApi = [[GetCodeAPI alloc]init  ];
    getCodeApi.codeType = CHECKID;
    [getCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            [self.sendButton start];
            [self presentSuccessTips:@"验证码已发送到您的手机"];
            
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


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 1 || section == 2  )
    {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 ) {
        return 26;
    }
    else{
        return 44;
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
