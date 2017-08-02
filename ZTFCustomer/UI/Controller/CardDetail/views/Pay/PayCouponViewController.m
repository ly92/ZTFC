//
//  PayCouponViewController.m
//  WeiTown
//
//  Created by kakatool on 15/12/2.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "PayCouponViewController.h"
#import "CarCouponCell.h"
//#import "PayCarCoupon.h"

@interface PayCouponViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, retain) NSArray *carCouponList;//乘车卷

@property (nonatomic, retain) NSMutableArray *chooseSns;//选中的卷的sn

@property (retain, nonatomic) NSString *totalMoney;//

@property (assign, nonatomic) CGFloat couponMoney;//选中的优惠券总金额

@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation PayCouponViewController

- (instancetype)initWithCarCoupons:(NSArray *)carCoupons CarCouponSns:(NSMutableArray *)chooseSns TotalMoney:(NSString *)totalMoney{
    self = [super init];
    if (self){
        self.carCouponList = carCoupons;
        self.chooseSns = chooseSns;
        self.totalMoney = totalMoney;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];
    
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponMoney = 0;
    
//    [self.conpleteBtn setTitleColor:navOtherTitleColor forState:UIControlStateNormal];
    
}

#pragma mark-navibar

-(void)setNavigationBar{
    self.navigationItem.title = @"选择优惠券";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"完成" handler:^(id sender) {
         [self back];
    }];
}


#pragma mark-tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.carCouponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CarCouponCell";
    CarCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    if (_carCouponList.count != 0){
        RechargeCouponListModel *carC = self.carCouponList[indexPath.row];
        
        cell.title.text = carC.title;
        cell.amount.text = carC.amount;
        cell.end_date.text = carC.end_date;
        
        if ([self.chooseSns containsObject:carC.sn]){
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            self.couponMoney += [carC.amount floatValue];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RechargeCouponListModel *carC = self.carCouponList[indexPath.row];
    if (![self.chooseSns containsObject:carC.sn]){
        [self.chooseSns addObject:carC.sn];
        self.couponMoney += [carC.amount floatValue];
    }else{
        for (NSString *ss in self.chooseSns) {
            NSLog(@"%@",ss);
        }
        NSLog(@"------%@",carC.sn);
    }
    if (self.couponMoney > [self.totalMoney floatValue]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定使用？" message:@"优惠券金额大于总金额" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        self.selectedIndex = indexPath;
    }
 NSLog(@"%f",self.couponMoney);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.tv deselectRowAtIndexPath:self.selectedIndex animated:YES];
        [self tableView:self.tv didDeselectRowAtIndexPath:self.selectedIndex];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeCouponListModel *carC = self.carCouponList[indexPath.row];
    if ([self.chooseSns containsObject:carC.sn]){
        [self.chooseSns removeObject:carC.sn];
        NSLog(@"---------%f",[carC.amount floatValue]);
        self.couponMoney -= [carC.amount floatValue];
    }else{
        for (NSString *ss in self.chooseSns) {
            NSLog(@"%@",ss);
        }
        NSLog(@"------%@",carC.sn);
    }
     NSLog(@"%f",self.couponMoney);
}

- (IBAction)back {
    
    self.doneChoose(self.chooseSns);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done {

    [self back];
}
@end
