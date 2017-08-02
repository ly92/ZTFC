//
//  RegisterInfoController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "RegisterInfoController.h"


@interface RegisterInfoController ()<UIDatePickerSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *realnameInput;
@property (weak, nonatomic) IBOutlet UITextField *birthdayInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderInput;

@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@property (weak, nonatomic) IBOutlet UIButton *eyeButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (retain, nonatomic)UIDatePickerSheetController *datePicker;

@end

@implementation RegisterInfoController

+(instancetype)spawn{
    return [RegisterInfoController loadFromStoryBoard:@"Login"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    self.completeButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.completeButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self hideKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-navibar

-(void)setNavigationBar{
    
    self.navigationItem.title = @"注册";
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
    [self.realnameInput resignFirstResponder];
    [self.birthdayInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

#pragma mark-click

//查看密码
- (IBAction)eyeButtonClick:(id)sender {
    if (self.passwordInput.secureTextEntry == YES)
    {
        self.passwordInput.secureTextEntry = NO;
        [self.eyeButton setImage:[UIImage imageNamed:@"a1_eyes"] forState:UIControlStateNormal];
    }
    else{
        self.passwordInput.secureTextEntry = YES;
        [self.eyeButton setImage:[UIImage imageNamed:@"a1_eye_closed"] forState:UIControlStateNormal];
    }
    
}
//协议
- (IBAction)agreeButtonClick:(id)sender {
    
    WebViewController *web = [WebViewController spawn];
    
    [self.navigationController pushViewController:web animated:YES];
    
}



//完成
- (IBAction)completeButtonClick:(id)sender {
    
    NSString *realname = [self.realnameInput.text trim];
    NSString *birthday = [self.birthdayInput.text trim];
    NSString *password = [self.passwordInput.text trim];
    
    NSString *gender = self.genderInput.selectedSegmentIndex == 0 ? @"1" : @"2";
    
    
    if (realname.length == 0) { //姓名
         [self presentFailureTips:@"姓名不能为空"];
        return;
    }
    
    if (birthday.length == 0) {    //生日
        birthday = @"";
    }
    
    if (password.length == 0) {  //密码
         [self presentFailureTips:@"密码不能为空"];
        return;
    }
    else if (password.length < 6) {
         [self presentFailureTips:@"密码不能少于6位"];
        return;
    }
    
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    RegisterAPI *registerApi = [[RegisterAPI alloc]initWithRealname:realname mobile:self.mobile gender:gender psw:password birthday:birthday];
    [registerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSDictionary *userInfo = result[@"user"];
            if (![ISNull isNilOfSender:userInfo]) {
                
                UserModel *user = [UserModel mj_objectWithKeyValues:userInfo];
                
                [[LocalData shareInstance]updateUserAccount:user];
                [LocalData updateAccessToken:user.access_token];
                [LocalData updateNormalUserInfo:user.mobile Psw:password];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERSUCCESS" object:nil];
            
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

//注册协议
- (IBAction)AgreeButtonClick:(id)sender {
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectZero];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self showDatePicker];
        }
    }
}
#pragma mark-生日

-(void)showDatePicker{
    [self.view endEditing:YES];
    if (_datePicker==nil) {
        _datePicker = [[UIDatePickerSheetController alloc] initWithDefaultNibName];
        //        _datePicker.dateMode=1;
        _datePicker.delegate = self;
        [_datePicker setDateTimeMode:UIDatePickerModeDate];
    }
    [_datePicker setDate:[NSDate date]  animated:NO];
    [_datePicker showInViewController:self animated:YES];
    [_datePicker setMaxmunDate:[NSDate date]];
    
}

- (void)datePickerSheet:(UIDatePickerSheetController *)datePickerSheet didFinishWithDate:(NSDate *)date
{
    
    self.birthdayInput.text = [date stringWithFormat:@"yyyy-MM-dd"];
    
}
- (void)datePickerSheetDidCancel:(UIDatePickerSheetController *)datePickerSheet
{
    
}


#pragma mark - textfieldDelegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.realnameInput) {
        if (string.length > 0) {
            if (textField.text.length >=10) {
                [self presentFailureTips:@"名字不能超过10个字符"];
                return NO;
            }
        }
    }
    if (textField == self.passwordInput) {
        if (string.length > 0) {
            if (textField.text.length >=16) {
                [self presentFailureTips:@"密码不能超过16位"];
                return NO;
            }
        }
    }
    
    
    
    return YES;
    
    
}


@end
