//
//  FindPswController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FindPswController.h"

@interface FindPswController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileInout;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeInout;

@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet CountdownButton *sendVerifyCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation FindPswController

+(instancetype)spawn{
    return [FindPswController loadFromStoryBoard:@"Login"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.sureButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.sureButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.sendVerifyCodeButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self hideKeyBoard];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar{
    
    self.navigationItem.title = @"找回密码";
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
    [self.mobileInout resignFirstResponder];
    [self.verifyCodeInout resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}


#pragma mark-click
//发送验证码
- (IBAction)sendVerifyCodeButtonClick:(id)sender {
    
    NSString *mobile = [self.mobileInout.text trim];
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入手机号码"];
        return;
    }
    
    if (mobile.length != 11) {
         [self presentFailureTips:@"请输入正确的手机号码"];
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    
    GetCodeAPI *getCodeApi = [[GetCodeAPI alloc]initWithMoblie:mobile];
    
    getCodeApi.codeType = FINDPSWTYPE;
    
    [getCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
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
//确定
- (IBAction)sureButtonClick:(id)sender {
    
    NSString *mobile = [self.mobileInout.text trim];
    NSString *code = [self.verifyCodeInout.text trim];
    NSString *password = [self.passwordInput.text trim];
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入手机号码"];
        return;
    }
    
    if (mobile.length != 11) {
         [self presentFailureTips:@"请输入正确的手机号码"];
        return;
    }
    
    if (code.length == 0) {
         [self presentFailureTips:@"请输入验证码"];
        return;
    }
    if (password.length == 0) {
         [self presentFailureTips:@"请输入新密码"];
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    
    if(password.length < 6){
         [self presentFailureTips:@"密码不能少于6位"];
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    FindPswAPI *findPswApi = [[FindPswAPI alloc]initWithMobile:mobile checkCode:code newPassword:password];
    [findPswApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            [LocalData updateNormalUserInfo:mobile Psw:password];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FINDPSWSUCCESS" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
