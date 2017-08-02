//
//  GiveDropMainViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GiveDropMainViewController.h"
#import "SettingPasswordController.h"
#import "ForgetPayPwdViewController.h"
#import "PayPasswordView.h"
#import "MyDropController.h"


#define CONTENT @"0123456789.\n"
@interface GiveDropMainViewController ()<UITextFieldDelegate>

{
    __weak IBOutlet UIImageView *_userImageView;
    __weak IBOutlet UILabel *_userNameLabel;
    __weak IBOutlet UILabel *_userMobileLabel;
    __weak IBOutlet UITextField *_moneyTextField;
}

@property (nonatomic, strong) PayPasswordView * passwordView;
@property (nonatomic, strong) NSString * password;//密码
@property (weak, nonatomic) IBOutlet UIButton *giveButton;

@end

@implementation GiveDropMainViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.giveButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.giveButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self setToolbar];
    [self setupPasswordView];
    
    [self refreshUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBar{
    
    self.navigationItem.title = @"赠送";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark - settoolBar
-(void)setToolbar{
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    _moneyTextField.inputAccessoryView   = toobar;
    
}
-(void)resignKeyboard{
    [self.view endEditing:YES];
}


- (void)refreshUserInfo {
    
    [_userImageView setImageWithURL:[NSURL URLWithString:self.userModel.iconurl] placeholder:MemberHeadImage];
    [_userNameLabel setText:self.userModel.realname.length>0?self.userModel.realname:self.userModel.loginname];
    [_userMobileLabel setText:self.userModel.mobile];
}


#pragma mark - click

//赠送
- (IBAction)givePresson:(id)sender {
    [_moneyTextField resignFirstResponder];
    if ([_moneyTextField.text length] == 0) {
        [self presentFailureTips:@"请输入赠送金额"];
        return;
    }
    [self getIsSetPwd];
}

- (void)setupPasswordView
{
    if ( self.passwordView == nil )
    {
        PayPasswordView * passView = [PayPasswordView loadFromNib];
        
        @weakify(self);
        @weakify(passView);
        passView.confirmPay = ^(NSString * password) {
            @strongify(self);
            @strongify(passView);
            [passView endInput];
            
            [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
            [self presentLoadingTips:nil];
            GiveDropAPI *giveDropApi = [[GiveDropAPI alloc]initWithTel:self.mobile money:_moneyTextField.text password:password];
            [giveDropApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self dismissTips];
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSLog(@"%@",result);
                
                if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                    
                    [self fk_postNotification:@"GIVENSUCCESS"];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"赠送成功"];
                    
                     passView.hidden = YES;
                    
                    for (UIViewController *tempvc in self.navigationController.viewControllers) {
                        if ([tempvc isKindOfClass:[MyDropController class]]) {
                            [self.navigationController popToViewController:tempvc animated:YES];
                        }
                    }
                    
                    
                }else{
                    NSString *str = result[@"message"];
                    
                    if ([str isEqualToString:@"支付密码错误"]) {
                        passView.hidden = NO;
                        [passView clear];
                        [passView beginInput];
                    }else{
                        passView.hidden = YES;
                    }
                    
                    [self presentFailureTips:result[@"message"]];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
        };
        passView.hidden = YES;
        [self.view addSubview:passView];
        self.passwordView = passView;
    }
}

#pragma mark -Request
- (void)getIsSetPwd {
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    GetDropAPI *existPasswordApi = [[GetDropAPI alloc]init];
    existPasswordApi.dropType = ExistPasswordType;
    [existPasswordApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSNumber *state = content[@"exist"];
            if ( [state isEqualToNumber:@(1)] )
                        {
                            self.passwordView.hidden = NO;
                        }
                        else if ( [state isEqualToNumber:@(0)] )
                        {
                            
                            // 忘记密码
                            ForgetPayPwdViewController *forgetPayPwd = [ForgetPayPwdViewController spawn];
                            forgetPayPwd.popViewController = self;
                            forgetPayPwd.bindType = BIND_USER_TYPE_BIND;
                            [self.navigationController pushViewController:forgetPayPwd animated:YES];

                        }
                        else if ( [state isEqualToNumber:@(2)] )
                        {
                            SettingPasswordController * passwordVC = [SettingPasswordController spawn];
                            passwordVC.popViewController = self;
                            passwordVC.settingType = SETTING_PASSWORD_TYPE_NEW;
                            passwordVC.passwordType = PASSWORD_TYPE_SET;
                            [self.navigationController pushViewController:passwordVC animated:YES];
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

- (void)pay {
//    [MealTicketModel CreatRedPaketCarryOrderReceiverId:self.response.id Type:[NSNumber numberWithInteger:1] Amount:[NSNumber numberWithFloat:[_moneyTextField.text floatValue]] Note:nil Password:self.password Then:^(VER_REDPAKET_CARRYORDERCREATE_POST_RESPONSE *response, STIHTTPResponseError *e) {
//        self.passwordView.hidden = YES;
//        [self dismissTips];
//        if ([response.ok integerValue] == 1) {
//            //赠送成功
//            CLGiveMealTicketResultViewController *resultVC = [CLGiveMealTicketResultViewController spawn];
//            [resultVC setResultStr:@"赠送成功"];
//            [resultVC setResultImage:[UIImage imageNamed:@"f2_success"]];
//            [resultVC setResultMoneyStr:[NSString stringWithFormat:@"¥%.2f",[_moneyTextField.text floatValue]]];
//            [self.navigationController pushViewController:resultVC animated:YES];
//        } else {
//            //赠送失败
//            CLGiveMealTicketResultViewController *resultVC = [CLGiveMealTicketResultViewController spawn];
//            [resultVC setResultStr:@"赠送失败"];
//            [resultVC setResultImage:[UIImage imageNamed:@"f3_fail"]];
//            [resultVC setResultMoneyStr:[NSString stringWithFormat:@"¥%.2f",[_moneyTextField.text floatValue]]];
//            [self.navigationController pushViewController:resultVC animated:YES];
//        }
//    }];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self checkNumberTwoDecimals:textField.text string:string shouldChangeCharactersInRange:range];
}

//限制只有两位小数
- (BOOL)checkNumberTwoDecimals:(NSString *)textStr  string:(NSString *)string shouldChangeCharactersInRange:(NSRange)range
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:CONTENT] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        return NO;
    }
    
    NSString* tempStr = [NSString stringWithFormat:@"%@",textStr];
    NSRange tempRang = [tempStr rangeOfString:@"."];
    if (tempRang.length>=1&&[string isEqualToString:@"."]) {
        return NO;
    }else if(tempRang.length == 1)
    {
        if ((range.location - tempRang.location) >= 3) {
            return NO;
        }
    }
    
    return YES;
    
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
