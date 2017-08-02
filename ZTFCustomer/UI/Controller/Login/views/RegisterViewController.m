//
//  RegisterViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/27.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterInfoController.h"

@interface RegisterViewController ()
{
    __block int _timeout;
    dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UITextField *mobileInput;
@property (weak, nonatomic) IBOutlet UITextField *passwprdInput;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet CountdownButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *gotoLoginBtn;


@end

@implementation RegisterViewController

+(instancetype)spawn{
    return [RegisterViewController loadFromStoryBoard:@"Login"];
}

#pragma mark-生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self setNavigationBar];
    self.nextButton.layer.cornerRadius = 4;
    self.nextButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.nextButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self.sendButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.gotoLoginBtn setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    //隐藏键盘
    [self hideKeyBoard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar

-(void)setNavigationBar{
    
        self.navigationItem.title = @"注册";
        self.navigationItem.leftBarButtonItem = [AppTheme itemWithContent:@"" handler:nil];
   

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
    [self.passwprdInput resignFirstResponder];
}

#pragma mark-click
 //去登录
- (IBAction)gotoLoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//发送验证码
- (IBAction)sendButtonClick:(id)sender {
    
    NSString *mobile = [self.mobileInput.text trim];
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入手机号码"];
        return;
    }
    //获取验证码
    [self getCheckCode];
}
//发送验证码
- (void)getCheckCode
{
    NSString *mobile = [self.mobileInput.text trim];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    
    GetCodeAPI *getCodeApi = [[GetCodeAPI alloc]initWithMoblie:mobile];
    
    getCodeApi.codeType = REGISTERTYPE;
    
    [getCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *) request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"已发送至您的手机，请注意查收"];
            //验证码倒计时操作
            [self.sendButton start];
        }else{
            [self.sendButton stop];
             [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.sendButton stop];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

//下一步
- (IBAction)nextButtonClick:(id)sender {
    NSString *mobile = [self.mobileInput.text trim];
    NSString *code = [self.passwprdInput.text trim];
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入手机号"];
        return;
    }
    
    if (mobile.length != 11) {
         [self presentFailureTips:@"请输入正确的手机号"];
        return;
    }
    
    if (code.length == 0) {
         [self presentFailureTips:@"请输入验证码"];
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    CheckCodeAPI *checkCodeApi = [[CheckCodeAPI alloc]initWithCheckCode:code mobile:mobile];
    checkCodeApi.checkCodeType = CHECKCODE_REGISTERTYPE;
    [checkCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self.sendButton stop];
            
            //注册
            RegisterInfoController *registerInfo = [RegisterInfoController spawn];
            
            registerInfo.mobile = mobile;
            
            [self.navigationController pushViewController:registerInfo animated:YES];
                        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
       
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
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
    if (section == 2) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
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
