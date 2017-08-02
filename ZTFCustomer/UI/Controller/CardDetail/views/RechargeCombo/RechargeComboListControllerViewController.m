//
//  RechargeComboListControllerViewController.m
//  WeiTown
//
//  Created by 李勇 on 16/3/2.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "RechargeComboListControllerViewController.h"
#import "RechargeComboCell.h"
#import "RechargeComboDetailViewController.h"
#import "PaySuccessViewController.h"

@interface RechargeComboListControllerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, retain) NSMutableArray *dataArray;//
@property (nonatomic, retain) NSString *bid;//
@property (nonatomic, retain) NSString *url;//
@property (nonatomic, retain) NSString *name;//
@end

@implementation RechargeComboListControllerViewController
- (instancetype)initWithBid:(NSString *)bid IconUrl:(NSString *)url Name:(NSString *)name{
    if (self = [super init]){
        self.bid = bid;
        self.url = url;
        self.name = name;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:self.url] placeholder:[UIImage imageNamed:@""]];
    self.nameLbl.text = self.name;
    [self prepareLayout];
    [self loadData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark-navibar

-(void)setNavigationBar{
    self.navigationItem.title = @"套餐列表";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-prepareLayout

-(void)prepareLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/2, 106);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RechargeComboCell" bundle:nil] forCellWithReuseIdentifier:@"RechargeComboCell"];
    
}


#pragma mark-loadData
-(void)loadData{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    GetRechargeComboListAPI *getRechargeCombo = [[GetRechargeComboListAPI alloc]initWithBid:self.bid skip:@"0" limit:@"30"];
    [getRechargeCombo startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            
            for (NSDictionary *dic in list) {
                [self.dataArray addObject:[RechargeComboModel mj_objectWithKeyValues:dic]];
            }
            [self.collectionView reloadData];
            
            
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

#pragma mark-collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(![ISNull isNilOfSender:self.dataArray]){
        return self.dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeComboCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RechargeComboCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RechargeComboCell" owner:nil options:nil] lastObject];
        cell = [[RechargeComboCell alloc] init];
    }
    RechargeComboModel *rechargeModel = self.dataArray[indexPath.row];
    if (rechargeModel) {
        
        cell.data = rechargeModel;
        
    }
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RechargeComboModel *dic = self.dataArray[indexPath.row];
    [self selectItem:dic];
    
}
-(void)selectItem:(RechargeComboModel *)item{
    NSLog(@"select app:%@",item);
    RechargeComboDetailViewController *comboDetailVC = [[RechargeComboDetailViewController alloc] initWithRechargeid:item.rechargeid];
    
    comboDetailVC.paySuccess = ^void(NSString *price, NSString *payway,NSString *tnum){
        
        PaySuccessViewController *paysuccessVC = [[PaySuccessViewController alloc]initWithPrice:price Payway:payway Orderid:tnum];
                
        [self.navigationController pushViewController:paysuccessVC animated:YES];
        
    };
    
    [self.navigationController pushViewController:comboDetailVC animated:YES];
    
}

@end
