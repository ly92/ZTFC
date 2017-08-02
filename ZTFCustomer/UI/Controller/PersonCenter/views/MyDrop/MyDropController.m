//
//  MyDropController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyDropController.h"
#import "MealTicketToolCollectionCell.h"
#import "RechargeController.h"
#import "IncomeViewController.h"
#import "RechargeRecordViewController.h"
#import "PasswordTypeViewController.h"
#import "GiveDropController.h"
#import "ForgetPayPwdViewController.h"

@interface MyDropController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropBanlancelbl;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;



@property (nonatomic, strong) DropModel *dropModel;
@end

@implementation MyDropController
+(instancetype)spawn{
    return [MyDropController loadFromStoryBoard:@"MyDrop"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    _dataArray = [NSMutableArray array];
    
    self.dropBanlancelbl.text = [NSString stringWithFormat:@"%@余额",MyDropText];
    
    [self.collectionView registerNib:@"MealTicketToolCollectionCell"];

    [self getExpendTotla];
    [self getRedMore];
    
    
    [self registerNoti];
    
    
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"我的%@",MyDropText];
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
-(void)registerNoti{
    [self fk_observeNotifcation:@"SETPASSWORDSUCCESS" usingBlock:^(NSNotification *note) {
        [self.dataArray removeAllObjects];
        [self getRedMore];
    }];
    
    [self fk_observeNotifcation:@"GIVENSUCCESS" usingBlock:^(NSNotification *note) {
        [self getExpendTotla];
    }];
}
#pragma mark -Request
- (void)getExpendTotla {
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    GetDropAPI *getDropApi = [[GetDropAPI alloc]init];
    getDropApi.dropType = GetTotalDropType;
    [getDropApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
           
            self.dropModel = [DropModel mj_objectWithKeyValues:content[@"info"]];
            self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[self.dropModel.left floatValue]];
            self.incomeLabel.text = [NSString stringWithFormat:@"收入 %.2f |  支出 %.2f  ",[self.dropModel.income floatValue],[self.dropModel.pay floatValue]];
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}



- (void)getRedMore {
    if (_dataArray&&[_dataArray count] > 0) {
        [_dataArray removeAllObjects];
    }
    
//    RedMoreListModel *rechargeMoreList = [[RedMoreListModel alloc] init];
//    rechargeMoreList.id = [NSNumber numberWithInteger:101];
//    rechargeMoreList.title = @"充值";
//    rechargeMoreList.image = @"per_td_icon1";
//    [_dataArray addObject:rechargeMoreList];
    
    RedMoreListModel *giveMoreList = [[RedMoreListModel alloc] init];
    giveMoreList.id = [NSNumber numberWithInteger:102];
    giveMoreList.title = @"赠送";
    giveMoreList.image = @"give";
    [_dataArray addObject:giveMoreList];
    
  
    RedMoreListModel *incomeMoreList = [[RedMoreListModel alloc] init];
    incomeMoreList.id = [NSNumber numberWithInteger:103];
    incomeMoreList.title = @"收入明细";
    incomeMoreList.image = @"per_td_icon2";
    [_dataArray addObject:incomeMoreList];
    
    RedMoreListModel *expendMoreList = [[RedMoreListModel alloc] init];
    expendMoreList.id = [NSNumber numberWithInteger:104];
    expendMoreList.title = @"支出明细";
    expendMoreList.image = @"per_td_icon3";
    [_dataArray addObject:expendMoreList];
    
    
//    RedMoreListModel *rechargeRecordMoreList = [[RedMoreListModel alloc] init];
//    rechargeRecordMoreList.id = [NSNumber numberWithInteger:105];
//    rechargeRecordMoreList.title = @"充值记录";
//    rechargeRecordMoreList.image = @"per_td_icon4";
//    [_dataArray addObject:rechargeRecordMoreList];
    
    
    RedMoreListModel *paymentCodeMoreList = [[RedMoreListModel alloc] init];
    paymentCodeMoreList.id = [NSNumber numberWithInteger:106];
    paymentCodeMoreList.title = @"支付密码";
    paymentCodeMoreList.image = @"per_td_icon5";
    [_dataArray addObject:paymentCodeMoreList];
    
    [self.collectionView reloadData];
    
    [self.collectionView reloadData];
    
    
    
}
#pragma mark-collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSMutableArray * toolsArray = (NSMutableArray *)self.data;
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MealTicketToolCollectionCell" forIndexPath:indexPath];
    
    if ( _dataArray.count && indexPath.item <= (_dataArray.count - 1) )
    {
        if ([_dataArray[indexPath.item] isKindOfClass:[RedMoreListModel class]]) {
            RedMoreListModel * redMoerList = _dataArray[indexPath.item];
            cell.data = redMoerList;
            
        }

    }
    else
    {
        cell.data = nil;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.item == 0) {
//        //充值
//        RechargeController *recharegeCon = [RechargeController spawn];
//        [self.navigationController pushViewController:recharegeCon animated:YES];
//        
//    }else
        if (indexPath.item == 0){
        //赠送
        GiveDropController *giveDropCon = [GiveDropController spawn];
        
        [self.navigationController pushViewController:giveDropCon animated:YES];
        
    }else if (indexPath.item == 1){
        //收入记录
        IncomeViewController *incomeCon = [IncomeViewController spawn];
        incomeCon.incomeType = @"0";
        incomeCon.totalMoney = self.dropModel.income;
        [self.navigationController pushViewController:incomeCon animated:YES];
        
    }else if (indexPath.item == 2){
        //消费记录
        IncomeViewController *expendCon = [IncomeViewController spawn];
        expendCon.incomeType = @"1";
        expendCon.totalMoney = self.dropModel.pay;
        [self.navigationController pushViewController:expendCon animated:YES];
    }
//    else if (indexPath.item == 3){
//        //充值记录
//        RechargeRecordViewController *rechargeRecordCon = [RechargeRecordViewController spawn];
//        [self.navigationController pushViewController:rechargeRecordCon animated:YES];
//
//    }
    else if (indexPath.item == 3){
        //支付密码
        
        //判断支付密码是否存在
        
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
        GetDropAPI *existPasswordApi = [[GetDropAPI alloc]init];
        existPasswordApi.dropType = ExistPasswordType;
        [existPasswordApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSDictionary *content = result[@"content"];
            
            if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                
                NSInteger exist = [content[@"exist"] integerValue];
                //支付密码存在
                if (exist == 1) {
                    
                    ForgetPayPwdViewController *forgetPayPwd = [ForgetPayPwdViewController spawn];
                    forgetPayPwd.popViewController = self;
                    forgetPayPwd.bindType = BIND_USER_TYPE_FORGET;
                    [self.navigationController pushViewController:forgetPayPwd animated:YES];
                    
                }else{
                    ForgetPayPwdViewController *forgetPayPwd = [ForgetPayPwdViewController spawn];
                    forgetPayPwd.popViewController = self;
                    forgetPayPwd.bindType = BIND_USER_TYPE_BIND;
                    [self.navigationController pushViewController:forgetPayPwd animated:YES];
                }
                
            }else{
                [self presentFailureTips:result[@"message"]];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
        }];
        
//        PasswordTypeViewController *passwordTypeCon = [PasswordTypeViewController spawn];
//        [self.navigationController pushViewController:passwordTypeCon animated:YES];

    }
    
}

- (CGSize)itemSize
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size.width = (SCREENWIDTH - 20 ) / 3 ;
        size.height = size.width;
    });
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self itemSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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
