//
//  SettingController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SettingController.h"
#import "AboutViewController.h"
#import "ModifyPswController.h"
#import "HuanxinService.h"

@interface SettingController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@end

@implementation SettingController

+(instancetype)spawn{
    return [SettingController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.logoutBtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.logoutBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self.tableView tableViewRemoveExcessLine];
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
    
    self.navigationItem.title = @"设置";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
#pragma mark-click
- (IBAction)logoutClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark-UIalertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        
        NSString *token = [LocalData getDeviceToken];
        if (user && token) {
            [self presentLoadingTips:nil];
            [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
            UnRegisterDeviceAPI *unregisterDeviceApi = [[UnRegisterDeviceAPI alloc]initWithMemberIDType:@"cid" objid:user.cid];
            
            [unregisterDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                [self dismissTips];
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
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
        
        
        [[LocalData shareInstance] removeUserAccount];
        [LocalData updateAccessToken:nil];
        [STICache.global setObject:@"YES" forKey:@"LOGOUT"];
        [[HuanxinService shareInstance]logout];
        //弹出登录页面
        [[AppDelegate sharedAppDelegate] setupRootViewController];
        
    }
}


#pragma mark-delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改密码";
        
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"关于APP";
       
    }else if (indexPath.row == 2){
         cell.textLabel.text = @"服务协议";
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //修改密码
        ModifyPswController *modifyPsw = [ModifyPswController spawn];
        
        [self.navigationController pushViewController:modifyPsw animated:YES];
    }
    
       if (indexPath.row == 1) {
           
           //关于微Town
           AboutViewController *about = [AboutViewController spawn];
           [self.navigationController pushViewController:about animated:YES];
           
        }
        
        if (indexPath.row == 2) {

            //服务条款
            WebViewController *web = [WebViewController spawn];
            web.webURL = [NSString stringWithFormat:@"http://app.kakatool.cn/policy.php?appid=%@",APP_ID ];
            web.webTitle = @"服务条款";
            [self.navigationController pushViewController:web animated:YES];
            
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
