//
//  ShareViewController.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewheight;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareContent;

@end

@implementation ShareViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    self.shareBgHeight.constant = SCREENWIDTH *458/375;
    
    self.containerViewheight.constant = self.shareBgHeight.constant + 150;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HIDETABBAR;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBar{
    self.navigationItem.title = @"分享";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - click
- (IBAction)shareBtnClick:(id)sender {
    [self myShare];
}


-(void)myShare{
    
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance]getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *name = @"";
    if ([tUserDetail.realname trim].length>0) {
        name = tUserDetail.realname;
    }
    else{
        name = tUserDetail.loginname;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *cShareTitle = [NSString stringWithFormat:@"%@邀请您立刻加入%@",name,appName];
    
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *cShareContent =[NSString stringWithFormat:@"下载安装‘慧生活’，体验快捷看房买房，还有铁豆赠送"];
    
    //http://app.kakatool.cn/app.php?appid=%@
    //http://crcc.kakatool.cn:2016/share/register.html?appid=%@&userid=%@
    NSString *cShareurl = [NSString stringWithFormat:@"http://crcc.kakatool.cn:2016/share/register.html?appid=%@&userid=%@&platform=%@",APP_ID,tUserDetail.cid,APP_PLATFORM];
    NSURL *shareUrl = [NSURL URLWithString:cShareurl];
    
    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,shareUrl];
    NSString *cShareAllContent = [NSString stringWithFormat:@"%@",cShareTheme];
    
    //构造分享内容
    //常见分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //允许使用客户端分享
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:cShareAllContent
                                     images:[UIImage imageNamed:@"appicon"]
                                        url:shareUrl
                                      title:cShareTitle
                                       type:SSDKContentTypeAuto];
    
    //定义菜单分享列表
    [ShareSDK showShareActionSheet:nil
                             items:@[
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   if (state == SSDKResponseStateSuccess)
                   {
                       [self presentSuccessTips:@"分享成功"];
                   }
                   else if (state == SSDKResponseStateFail)
                   {
                       [self presentFailureTips:@"分享失败,请重试"];
                       
                   }
                   
               }];
    
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
