//
//  AccessDetailViewController.m
//  colourlife
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "AccessDetailViewController.h"
//#import "CancelAuthrozationModel.h"
#import "AuthrozationDetailViewController.h"

//通过
#define PASSCOLOR RGBACOLOR(25, 177, 13, 1.0)
//拒绝
#define REFUSECOLOR RGBACOLOR(191, 199, 204, 1.0)

@interface AccessDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *authAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelAuthBtn;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *authTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *memoLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoLabelHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

//取消授权
//@property (strong, nonatomic) CancelAuthrozationModel *cancelAuthModel;

@end

@implementation AccessDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if ( GT_IOS7 )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //设置导航栏的数据
    [self setupNavgationBar];
    
    //准备数据
    [self prepareData];
}
//设置导航栏的数据
-(void)setupNavgationBar{
    self.navigationItem.title=@"授权详情";
    self.navigationItem.leftBarButtonItem=[AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
//准备数据
-(void)prepareData{
    
    
    //判断状态
    //未批复
        int type = [self.apply.type intValue];
    if (type == 1) {
        //未批复
        if (self.apply.isdeleted == 0) {
            
        }else{
            
        }
    }
    //通过
    else{
        int usertype = [self.apply.usertype intValue];

        if ([self.apply.isdeleted intValue] == 1) {
            //已失效
            
            self.detailLabel.text = @"已失效";
            self.detailLabel.textColor = [UIColor blackColor];
            
            self.authAgainBtn.hidden = NO;
            self.cancelAuthBtn.hidden = YES;
            
        }
        else{
            
            self.detailLabel.text = @"通过";
            self.detailLabel.textColor = PASSCOLOR;
            self.cancelAuthBtn.hidden = NO;
            self.authAgainBtn.hidden = YES;
        }
        
        switch (usertype) {
            case 1:
                self.authTimeLabel.text = @"永久";
                break;
            case 2:
                self.authTimeLabel.text = @"7天";
                break;
            case 3:
                self.authTimeLabel.text = @"1天";
                break;
            case 4:
                self.authTimeLabel.text = @"2小时";
                break;
            case 5:
                self.authTimeLabel.text = @"1年";
                break;
                
            default:
                break;
        }

        
    }
  
//    NSDate *applyDate=[NSDate dateWithTimeIntervalSince1970:[self.apply.creationtime intValue]];
//    NSString *applyTime = [NSDate stringFromDate:applyDate withFormat:@"yyyy-MM-dd HH:mm"];
//    self.applyTimeLabel.text = applyTime;
    
    
    self.memoLabel.text = self.apply.memo;
    
    CGFloat memoHeight = [self.memoLabel resizeHeight];
    
    if (memoHeight > 20) {
          self.memoLabelHeight.constant = memoHeight;
    }else{
        self.memoLabelHeight.constant = 20;
    }
  
    self.memoViewHeight.constant=20+self.memoLabelHeight.constant;
    
    self.containerViewHeight.constant=200-40+self.memoViewHeight.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击方法

//再次授权，已失效的情况
- (IBAction)authAgainClick:(id)sender {
    
    AuthrozationDetailViewController *detailController = [[AuthrozationDetailViewController alloc]init];
    
    
    detailController.allowAuthArr = self.allowAuthArr;
    
    detailController.apply = self.apply;
    detailController.authController = self.authController;
    [self.navigationController pushViewController:detailController animated:YES];
    
}

//取消授权，授权成功未失效的情况
- (IBAction)cancelAuthClick:(id)sender {
    
    NSString *aid = self.apply.id;
    
    [self presentLoadingTips:nil];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    CancelAuthAPI *cancelAuthApi = [[CancelAuthAPI alloc]initWithId:aid];
    
    [cancelAuthApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            self.refreshBlock();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
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
