//
//  VoucherTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/6.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoucherTableViewController.h"
#import "voucherTableViewCell.h"
#import "VoucherDetailViewController.h"
#import "CouponListAPI.h"
#import "CouponListModel.h"
#import "VoucherExpireController.h"
@interface VoucherTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic,strong) NSString *bid;//用户ID
@property (strong, nonatomic) NSMutableArray *voucherList;//
@property(nonatomic,retain) UIView *footerView;

@end

@implementation VoucherTableViewController
- (NSMutableArray *)voucherList{
    if (!_voucherList){
        _voucherList = [NSMutableArray array];
    }
    return _voucherList;
}

- (instancetype)initWithBid:(NSString *)bid{
    if (self = [super init]){
        self.bid = bid;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    [self registerNoti];
    self.navigationItem.title = @"我的优惠券";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        if (self.isCouponTicket) {
            self.refreshBadgeBlock();
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            self.refreshBadgeBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self.tv registerNib:[voucherTableViewCell nib] forCellReuseIdentifier:@"voucherTableViewCell"];
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
     self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setHeaderAndFooter];

    [self setFooterView];
    
    [self initloading];
    
}
#pragma mark-registerNoti
-(void)registerNoti{
    
    //获取优惠券
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVoucher) name:@"getCoupon" object:nil];
    
    //扫码消费
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVoucher) name:@"DEDUCTMONEY" object:nil];
    
    //优惠券转赠成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVoucher) name:@"givenCouponSnSuccess" object:nil];
    
    //添加会员（领卡）成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVoucher) name:@"addMemberSuccess" object:nil];
    
    
}

-(void)refreshVoucher{
    [self initloading];
}
#pragma mark-loadData
-(void)loadNewData{
    [self.voucherList removeAllObjects];
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

- (void)loadData{
    
    if (!self.bid) {
        self.bid = @"";
    }
    
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.voucherList.count];
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    CouponListAPI *couponApi = [[CouponListAPI alloc] initWithBid:self.bid Count:count Limit:@"10"];
    couponApi.couponType = COUPONLIST;
    
    [couponApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //停止刷新
        [self doneLoadingTableViewData];
        CouponListModel *couponListModel = [CouponListModel mj_objectWithKeyValues:request.responseJSONObject];
        if (couponListModel && [couponListModel.result intValue] == 0) {
            [self dismissTips];
            [self.voucherList addObjectsFromArray:couponListModel.List];
            
            
            if (couponListModel.List.count < 10) {
                self.tv.tableFooterView = self.footerView;
                [self loadAll];
            }
            
            if (self.voucherList.count == 0) {
                self.tv.tableFooterView = self.footerView;
            }
            
            [self.tv reloadData];
            
        }
        else{
            [self doneLoadingTableViewData];
             [self presentFailureTips:couponListModel.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

#pragma mark-tablefooter
- (void)setFooterView{
    
    //如果已经加载完全，则显示出查看过期卷
    _footerView = [[UIView alloc] initWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 35)];
    
    //没有更多优惠券了，查看过期券>>
    CGFloat W = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat H = 35;
    UILabel *preLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W + 10, H)];
    preLabel.text = @"没有更多优惠券了，";
    preLabel.font = [UIFont systemFontOfSize:13];
    preLabel.textAlignment = NSTextAlignmentRight;
    preLabel.backgroundColor = [UIColor whiteColor];
    
    [_footerView addSubview:preLabel];
    
    UILabel *expireCouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(W +10, 0, W - 10, H)];
    expireCouponLabel.backgroundColor = [UIColor whiteColor];
    expireCouponLabel.text = @"查看过期券>>";
    expireCouponLabel.font = [UIFont systemFontOfSize:13];
    expireCouponLabel.textAlignment = NSTextAlignmentLeft;
    expireCouponLabel.textColor = [UIColor redColor];
    [_footerView addSubview:expireCouponLabel];
    
    //添加点击进入过期卷方法
    [expireCouponLabel addTapAction:@selector(clickToExpireCoupon) forTarget:self];
   
    _footerView.backgroundColor = [UIColor whiteColor];
    
}

-(void)clickToExpireCoupon{
    VoucherExpireController *voucherExpire = [VoucherExpireController spawn];
    voucherExpire.bid = self.bid;
    [self.navigationController pushViewController:voucherExpire animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.voucherList.count != 0 )
    {
        return self.voucherList.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"voucherTableViewCell";
    voucherTableViewCell *cell = [self.tv dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (self.voucherList.count > indexPath.row){
        cell.data = [self.voucherList objectAtIndex:indexPath.row];
    }
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.voucherList.count > indexPath.row) {
        CouponModel *voucher = [self.voucherList objectAtIndex:indexPath.row];
        
        VoucherDetailViewController *detailViewController = [[VoucherDetailViewController alloc] initWithVOUCHER:voucher];
        detailViewController.reloadTable = ^{
            [self.voucherList removeAllObjects];
            [self initloading];
        };
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}


@end
