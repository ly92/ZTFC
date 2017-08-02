//
//  PasswordTypeViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PasswordTypeViewController.h"
#import "SettingPasswordController.h"
#import "ForgetPayPwdViewController.h"

@interface PasswordTypeViewController ()

@end

@implementation PasswordTypeViewController
+(instancetype)spawn{
    return [PasswordTypeViewController loadFromStoryBoard:@"MyDrop"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}
#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"支付密码";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        // 修改密码
        SettingPasswordController * settingPassword = [SettingPasswordController spawn];
        settingPassword.popViewController = self;
        settingPassword.passwordType = PASSWORD_TYPE_RESET;
        settingPassword.settingType = SETTING_PASSWORD_TYPE_OLD;
        [self.navigationController pushViewController:settingPassword animated:YES];
    }
    else
    {
//        // 忘记密码
        ForgetPayPwdViewController *forgetPayPwd = [ForgetPayPwdViewController spawn];
        forgetPayPwd.popViewController = self;
        forgetPayPwd.bindType = BIND_USER_TYPE_FORGET;
        [self.navigationController pushViewController:forgetPayPwd animated:YES];
//        BindUserController * bindUser = [BindUserController spawn];
//        bindUser.popViewController = self;
//        bindUser.bindType = BIND_USER_TYPE_FORGET;
//        [self.navigationController pushViewController:bindUser animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
