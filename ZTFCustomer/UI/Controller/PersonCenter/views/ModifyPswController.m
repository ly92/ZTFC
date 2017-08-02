//
//  ModifyPswController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyPswController.h"

@interface ModifyPswController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPswTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTextField;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation ModifyPswController

+(instancetype)spawn{
    return [ModifyPswController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.completeButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.completeButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
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
    
    self.navigationItem.title = @"修改密码";
    
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
    [self.oldPswTextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
}
#pragma marl-click

- (IBAction)completeButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *oldpsw = [self.oldPswTextField text];
    NSString *psw = [self.pswTextField text];
    NSString *confirmPsw = [self.confirmPswTextField text];
    
    if ([oldpsw trim].length==0) {
        [self presentFailureTips:@"请输入旧密码"];
       
        return;
    }
    if ([psw trim].length==0) {
         [self presentFailureTips:@"请输入新密码"];
       
        return;
    }
    if ([psw trim].length < 6) {
        [self presentFailureTips:@"新密码不能少于6位"];
        
        return;
    }
    if ([confirmPsw trim].length == 0) {
        [self presentFailureTips:@"请确认新密码"];
        
        return;

    }
  
    
    if (![[psw trim] isEqualToString:[confirmPsw trim]]) {
        [self presentFailureTips:@"确认密码与新密码输入的不一致"];
        return;
    }
    
    NSMutableDictionary *userInfo = [LocalData fetchNormalUserInfo];
    if (userInfo) {
        NSString *oldpsww = [userInfo objectForKey:@"password"];
        
        
        if (![[oldpsw trim] isEqualToString:[oldpsww trim]]) {
            [self presentFailureTips:@"旧密码输入不正确"];
            return;
        }
        
        if ([[psw trim] isEqualToString:[oldpsww trim]]) {
            [self presentFailureTips:@"新密码不能与旧密码相同"];
            return;
        }
        
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ModifyPswAPI *modifyPswApi = [[ModifyPswAPI alloc]initWithPldPsw:oldpsw newPsw:psw];
    [modifyPswApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            UserModel *user = [UserModel mj_objectWithKeyValues:result[@"user"]];
            if (user) {
                [[LocalData shareInstance] updateUserAccount:user];
                [LocalData updateAccessToken:user.access_token];
                
                
//                if ([STICache.global objectForKey:@"RemberPsw"]) {
//                    [LocalData updateNormalUserInfo:user.loginname Psw:psw];
//
//                }
                
                [LocalData updateNormalUserInfo:user.loginname Psw:psw];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                 [self presentFailureTips:result[@"reason"]];

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
    return 10;
}


#pragma mark - textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if (textField == self.pswTextField) {
        if (string.length > 0) {
            if (textField.text.length >=16) {
                [self presentFailureTips:@"密码不能超过16位"];
                return NO;
            }
        }
//    }
    
    
    return YES;
}


@end
