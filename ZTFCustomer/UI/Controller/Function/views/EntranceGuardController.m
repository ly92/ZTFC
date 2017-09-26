//
//  EntranceGuardController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "EntranceGuardController.h"

#import "EntranceGuardHeaderView.h"

#import "EntranceGuardCell.h"
#import "NoCommonGuardCell.h"

#import "OpenSuccessViewController.h"
#import "ScanActivity.h"

//#import "ApplyCell.h"
//
#import "ApplyViewController.h"
#import "AuthrozationViewController.h"


static NSString *entranceGuardIdentifier = @"EntranceGuardCell";
static NSString *noCommonGuardIdentifier = @"NoCommonGuardCell";

@interface EntranceGuardController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *authView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn3Leading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;


@property (nonatomic, strong) NSMutableArray *commonEntranceData;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger isgranted;

//@property (weak, nonatomic) IBOutlet UIButton *applyButton;
//@property (weak, nonatomic) IBOutlet UIButton *authButton;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *applyClickButton;
//@property (weak, nonatomic) IBOutlet UILabel *applyLbl;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *authClickButton;
//@property (weak, nonatomic) IBOutlet UILabel *authLbl;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
//
////无授权权限的button
//@property (weak, nonatomic) IBOutlet UIButton *noGrantApplyClickButton;
//
//
//@property (weak, nonatomic) IBOutlet UITableView *tv;
//
//
//@property (nonatomic, assign) NSInteger entranceGuardType;
//@property (nonatomic, strong) NSMutableArray *dataList;
//
//@property (nonatomic,strong) NSMutableArray *communityArr;


@end

@implementation EntranceGuardController

+(instancetype)spawn{
    return [EntranceGuardController loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self navigationBar];
    
//    self.dataList = [NSMutableArray array];
//    self.communityArr = [NSMutableArray array];
//    
//    self.btnWidth.constant = SCREENWIDTH/2.0;
    
    
    [self registerNoti];
    
    //获取常用门禁数据
    [self getCommonEntranceGuard];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:[UINib nibWithNibName:entranceGuardIdentifier bundle:nil] forCellReuseIdentifier:entranceGuardIdentifier];
    [self.tv registerNib:[UINib nibWithNibName:noCommonGuardIdentifier bundle:nil] forCellReuseIdentifier:noCommonGuardIdentifier];
    
    //判断是否有授权权限
    [self checkAuthGranted];
    
    //统计数据
    [self statisticsAction];
    
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


//统计数据
- (void)statisticsAction{
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",user.mobile]];
    StatisticsGlobalAPI *statisticsApi = [[StatisticsGlobalAPI alloc] initWithtypeId:@"1" communityId:community.bid];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    [statisticsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}



-(void)updateViewConstraints{
    [self autoArrangeBoxWithConstraints:@[self.btn1Leading,self.btn2Leading,self.btn3Leading] width:self.btnWidth.constant];
    
    [super updateViewConstraints];
}
-(void)autoArrangeBoxWithConstraints:(NSArray *)constraintsArray width:(CGFloat)width{
    CGFloat step=(SCREENWIDTH-80-(width * constraintsArray.count))/(constraintsArray.count-1);
    for (int i=0; i<constraintsArray.count; i++) {
        if (i==0) {
            NSLayoutConstraint *constraint=constraintsArray[i];
            constraint.constant = 40+width*i;
        }else{
            
            NSLayoutConstraint *constraint=constraintsArray[i];
            constraint.constant=step *i+width*i;
        }
    }
}

#pragma mark-navibar
-(void)navigationBar{
    
    self.titleName = (NSString *)self.data;
    
    self.navigationItem.title = self.titleName;
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-register Noti
-(void)registerNoti{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"COLLECTSUCCESS" object:nil];
}


-(void)refreshData:(NSNotification *)noti{
    [self getCommonEntranceGuard];

}

#pragma mark-获取常用门禁数据
//获取常用门禁数据
-(void)getCommonEntranceGuard{
    self.commonEntranceData = [NSMutableArray arrayWithArray:[LocalData getLockBookmark]];
    [self.tv reloadData];
}

#pragma mark-判断是否有授权权限

- (void)checkAuthGranted{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ApplyListAPI *checkGrandApi = [[ApplyListAPI alloc]init];
    
    checkGrandApi.entranceGuardType = CHECKGRANTED;
    
    [checkGrandApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
             self.isgranted = [result[@"isgranted"] intValue];
            

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




#pragma mark-click
- (IBAction)scanClick:(id)sender {
    
    ScanActivity *scan = [[ScanActivity alloc]init];
    
    scan.whenGetScan = ^(NSString *scanValue){
        
    };
    
    [self.navigationController pushViewController:scan animated:YES];
}

//申请
- (IBAction)applyClick:(id)sender {
    ApplyViewController *apply = [ApplyViewController spawn];
    
//    apply.refreshBlock = ^(){
//        
//        
//        [self applyListClick:nil];
////        self.entranceGuardType = 0;
////        [self loadData];
//        
//    };
    
    [self.navigationController pushViewController:apply animated:YES];
    
}
//授权
- (IBAction)authClick:(id)sender {
    
    if (self.isgranted == 1) {
        AuthrozationViewController *auth = [AuthrozationViewController spawn];
        
        [self.navigationController pushViewController:auth animated:YES];
    }else{
         [self presentFailureTips:@"无权限"];
    }
    
    
}


#pragma mark-tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.commonEntranceData.count > 0) {
        return self.commonEntranceData.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.commonEntranceData.count == 0) {
        
        NoCommonGuardCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommonGuardIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }else{
        
        EntranceGuardCell *cell = [tableView dequeueReusableCellWithIdentifier:entranceGuardIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.commonEntranceData.count>0) {
            cell.number = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            cell.data = self.commonEntranceData[indexPath.row];
        }
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.commonEntranceData.count == 0) {
        
        return 140;
        
    }else{
        
        return 65;
        
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.commonEntranceData.count == 0) {
        
        
    }else{
        
        NSDictionary *door = self.commonEntranceData[indexPath.row];
        
        NSString *wifienable = [door objectForKey:@"wifienable"];
        if ([wifienable intValue] == 1){//蓝牙开门
            OpenSuccessViewController *open = [[OpenSuccessViewController alloc]initWithQrcodebyBle:[door objectForKey:@"qrcode"]];
//            open.entranceGuard = self;
            [self.navigationController pushViewController:open animated:YES];
        }else{//普通开门
            OpenSuccessViewController *open = [[OpenSuccessViewController alloc]initWithQrcodeByNet:[door objectForKey:@"qrcode"]];
//            open.entranceGuard = self;
            [self.navigationController pushViewController:open animated:YES];
        }
        
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commonEntranceData.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.selectedIndex = indexPath.row;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        //删除常用门禁
        NSDictionary *door = self.commonEntranceData[self.selectedIndex];
        
        [LocalData removeLock:door];
        
        [self getCommonEntranceGuard];
        
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
