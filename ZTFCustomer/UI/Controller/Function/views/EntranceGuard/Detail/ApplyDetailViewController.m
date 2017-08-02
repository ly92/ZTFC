//
//  ApplyDetailViewController.m
//  colourlife
//
//  Created by mac on 16/1/6.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "ApplyDetailViewController.h"
//#import "ApplyAuthrozationAgainModel.h"
//未批复颜色
#define UNAPPROVECOLOR RGBACOLOR(253, 61, 65, 1.0)

//通过
#define PASSCOLOR RGBACOLOR(25, 177, 13, 1.0)
//拒绝
#define REFUSECOLOR RGBACOLOR(191, 199, 204, 1.0)

@interface ApplyDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyAgainBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;

//@property (strong, nonatomic) ApplyAuthrozationAgainModel *applyAuthAgainModel;

@end

@implementation ApplyDetailViewController

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
    self.navigationItem.title=@"申请详情";
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
        if ([self.apply.isdeleted intValue] == 0) {
            self.statusLabel.text = @"未批复";
            self.statusLabel.textColor = UNAPPROVECOLOR;
            self.scrollViewBottom.constant = 0;
        }else{
            self.statusLabel.text = @"拒绝";
            self.statusLabel.textColor = REFUSECOLOR;
            self.applyAgainBtn.hidden = NO;
            self.scrollViewBottom.constant = 40;
        }
    }
    //通过
    else{
        int usertype = [self.apply.usertype intValue];
        if ([self.apply.isdeleted intValue] == 1) {
            self.statusLabel.text = @"已失效";
            self.statusLabel.textColor = [UIColor blackColor];
            self.applyAgainBtn.hidden = NO;
            self.scrollViewBottom.constant = 40;
        }
        else{
            switch (usertype) {
                case 0:
                    self.statusLabel.text = @"未处理";
                    break;
                case 1:
                    self.statusLabel.text = @"永久";
                    break;
                case 2:
                    self.statusLabel.text = @"7天";
                    break;
                case 3:
                    self.statusLabel.text = @"1天";
                    break;
                case 4:
                    self.statusLabel.text = @"2小时";
                    break;
                case 5:
                    self.statusLabel.text = @"1年";
                    break;
                
                default:
                    break;
            }
            self.statusLabel.textColor=PASSCOLOR;
        }
    }
    self.phoneLabel.text = self.apply.mobile;
    self.remarkLabel.text = self.apply.memo;
    //计算高度
    CGSize size=[self.remarkLabel sizeThatFits:CGSizeMake(self.remarkLabel.frame.size.width, MAXFLOAT)];
    if (size.height==0) {
        size.height = 20;
    }
    self.remarkViewHeight.constant=20+size.height;
    self.containerViewHeight.constant=215-40+20+self.remarkViewHeight.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-点击方法
//再次申请
- (IBAction)applyAgainClick:(id)sender {
    
    NSString *fromid = self.apply.cid;
    
    if (fromid.length==0||[fromid isEqualToString:@"0"]) {
        fromid =self.apply.fromid;
    }
    
    NSString *memo = self.apply.memo;

    [self presentLoadingTips:nil];
    ApplyAgainAPI *applyAgainApi = [[ApplyAgainAPI alloc]initWithCid:fromid memo:memo];
    
    [applyAgainApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYSUCCESS" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
        }

        
    } failure:^(__kindof YTKBaseRequest *request) {
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
