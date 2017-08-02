//
//  PaymentMonthView.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预缴物业费，点击立即缴费弹出的view

#import "PaymentMonthView.h"
#import "PaymentMonthCell.h"

@interface PaymentMonthView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyButton;

@property (nonatomic, strong) NSMutableArray * monthArray;

@end

@implementation PaymentMonthView

@synthesize container = _container;
@synthesize whenSeleced = _whenSeleced;
@synthesize whenRegistered = _whenRegistered;
@synthesize whenHide = _whenHide;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.monthArray = [NSMutableArray array];
    
    self.height = [UIScreen mainScreen].bounds.size.height * 0.6;
    [self.collectionView registerNib:[PaymentMonthCell nib] forCellWithReuseIdentifier:@"PaymentMonthCell"];
    self.payMoneyButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.payMoneyButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
}

- (void)dataDidChange
{

    [self.collectionView reloadData];
    [self.monthArray removeAllObjects];
    [self setLabel];
}

#pragma mark - collectionView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * orderInfoArray = self.data;
    return orderInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaymentMonthCell" forIndexPath:indexPath];
    NSArray * orderInfoArray = self.data;
    cell.data = orderInfoArray[indexPath.row];
    return cell;
}

#pragma mark - collectionView flowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self itemSize];
}

- (CGSize)itemSize
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size.width = floor(([UIScreen mainScreen].bounds.size.width - 40) / 3);
        size.height = size.width * 0.5;
    });
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * orderInfoArray = self.data;
    OrderInfoModel * orderInfo = orderInfoArray[indexPath.row];
    orderInfo.isSelected = !orderInfo.isSelected;
    
    if ( orderInfo.isSelected )
    {
        [self.monthArray addObject:orderInfo];
    }
    else
    {
        [self.monthArray removeObject:orderInfo];
    }
    
    [self setLabel];
    
    [collectionView reloadData];
}

- (void)setLabel
{
    self.monthLabel.text = [NSString stringWithFormat:@"已选择%lu个月", (unsigned long)self.monthArray.count];
    
    CGFloat totalMoney = 0;
    for (OrderInfoModel * orderInfo in self.monthArray)
    {
        totalMoney += orderInfo.totalMoney.floatValue;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", totalMoney];
}

//handleSignal(confirmOrder, click)
//{
//    if ( self.confirmOrder )
//    {
//        self.confirmOrder(self.monthArray);
//    }
//}
- (IBAction)confirmClick:(id)sender {
    if ( self.confirmOrder )
    {
        self.confirmOrder(self.monthArray);
    }
}

@end
