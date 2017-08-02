//
//  GiveDropController.m
//  ZTFCustomer
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GiveDropController.h"
#import "GiveDropMainViewController.h"
#import "AddressBookViewController.h"

@interface GiveDropController ()<AddressBookViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation GiveDropController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.nextButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
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


#pragma mark -Event
//通讯录
- (IBAction)addressBookPresson:(id)sender {
    AddressBookViewController *addressBookVC = [AddressBookViewController spawn];
    [addressBookVC setDelegate:self];
    [self.navigationController pushViewController:addressBookVC animated:YES];
}

//下一步
- (IBAction)nextPresson:(id)sender {
    [self resignKeyboard];
    
    NSString *mobile = _phoneTextField.text;
    
    if ([mobile containsString:@"-"]) {
        NSArray *arr = [mobile componentsSeparatedByString:@"-"];
        mobile = [arr componentsJoinedByString:@""];
    }
    
    if ([mobile hasPrefix:@"+86"]) {
        NSArray *arr = [mobile componentsSeparatedByString:@"+86"];
        mobile = [arr componentsJoinedByString:@""];
    }
    
    if ([ISNull isNilOfSender:mobile]) {
        [self presentFailureTips:@"手机号码不能为空"];
        return;
    }
    if (mobile.length!=11) {
        [self presentFailureTips:@"请输入正确的手机号码"];
        return;
    }
    
    
    UserModel *currentuser = [[LocalData shareInstance]getUserAccount];
    if ([mobile isEqualToString:currentuser.mobile]) {
        [self presentFailureTips:@"不能赠送给自己"];
        return;
    }
    
    [self presentLoadingTips:nil];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
    GetUserInfoAPI *getUserInfoApi = [[GetUserInfoAPI alloc]initWithMobile:mobile];
    [getUserInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"%@",result);
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            UserModel *user =[UserModel mj_objectWithKeyValues:[content objectForKey:@"userinfo"]];
            
            GiveDropMainViewController *giveDropMainCon = [GiveDropMainViewController spawn];
            giveDropMainCon.userModel = user;
            giveDropMainCon.mobile = mobile;
            [self.navigationController pushViewController:giveDropMainCon animated:YES];
            
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
    
    
//    [self dismissTips];
    
//    [self presentLoadingTips:@"正在加载"];
//    [MealTicketModel redPaketGetCustomerInfoMobile:_phoneTextField.text Then:^(VER_REDPAKET_GETCUSTOMERINFO_POST_RESPONSE *response, STIHTTPResponseError *e) {
//        [self dismissTips];
//        if (e) {
//            //请求失败
//        } else {
//            //请求成功
//            if ([response.ok integerValue] == 1) {
//                CLGiveMealTicketMainViewController *giveMainVC = [CLGiveMealTicketMainViewController spawn];
//                [giveMainVC setResponse:response];
//                [self.navigationController pushViewController:giveMainVC animated:YES];
//            } else {
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"该手机号尚未注册彩之云，是否邀请注册？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"邀请", nil];
//                [alter show];
//            }
//        }
//        
//    }];
}

- (void)resignKeyboard {
    [_phoneTextField resignFirstResponder];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self presentLoadingTips:@"正在发送邀请信息"];
//        [InviteModel getInviteMobile:_phoneTextField.text Then:^(INVITE_GET_RESPONSE *response, STIHTTPResponseError *e) {
//            [self dismissTips];
//            if (response) {
//                //请求成功
//                if ([response.ok integerValue] == 1) {
//                    [self presentFailureTips:@"已发送邀请信息到好友手机"];
//                }
//            }
//            
//        }];
    }
}

#pragma mark -BookAddressViewDelegate
- (void)passValue:(NSString *)phoneNum KeyName:(NSString *)keyName {
    [_phoneTextField setText:phoneNum];
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
