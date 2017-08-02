//
//  VoucherExpireController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "VoucherExpireController.h"
#import "voucherTableViewCell.h"
#import "VoucherDetailViewController.h"

@interface VoucherExpireController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *voucherExpireArr;

@end

@implementation VoucherExpireController


+(instancetype)spawn{
    return [VoucherExpireController  loadFromStoryBoard:@"CardDetail"];
}

-(NSMutableArray *)voucherExpireArr{
    if (!_voucherExpireArr) {
        _voucherExpireArr = [NSMutableArray array];
    }
    return _voucherExpireArr;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:@"voucherTableViewCell" identifier:@"voucherTableViewCell"];
    
    [self setNavigationBar];
    [self setHeaderAndFooter];
    [self initloading];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"过期优惠券";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark-load data
-(void)loadNewData{
    [self.voucherExpireArr removeAllObjects];
    [self loadData];
}
-(void)loadMoreData{
    [self loadData];
}

-(void)loadData{
    
    if (!self.bid) {
        self.bid = @"";
    }
    
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.voucherExpireArr.count];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    CouponListAPI *couponApi = [[CouponListAPI alloc] initWithBid:self.bid Count:count Limit:@"10"];
    couponApi.couponType = COUPONEXPIRELIST;
    
    [couponApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        CouponListModel *result = (CouponListModel *)[CouponListModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] ==0) {
            [self.voucherExpireArr addObjectsFromArray:result.List];
            
            if (result.List.count == 0) {
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }
            
            if (result.List.count < 10) {
                [self loadAll];
            }
            
            [self.tv reloadData];
            
            
        }else{
             [self presentFailureTips:result.reason];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

#pragma mark-tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voucherExpireArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"voucherTableViewCell";
    voucherTableViewCell *cell = [self.tv dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (self.voucherExpireArr.count > indexPath.row){
        cell.data = [self.voucherExpireArr objectAtIndex:indexPath.row];
    }
    return cell;
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CouponModel *voucher = [self.voucherExpireArr objectAtIndex:indexPath.row];
    
    VoucherDetailViewController *detailViewController = [[VoucherDetailViewController alloc] initWithVOUCHER:voucher];
    detailViewController.reloadTable = ^{
        [self.voucherExpireArr removeAllObjects];
//        [self loadData];
    };
    [self.navigationController pushViewController:detailViewController animated:YES];
}




@end
