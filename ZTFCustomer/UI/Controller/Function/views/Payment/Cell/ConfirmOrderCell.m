//
//  ConfirmOrderCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/9.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  缴费信息c

#import "ConfirmOrderCell.h"
#import "ConfirmOrderListCell.h"

@interface ConfirmOrderCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation ConfirmOrderCell

+ (CGFloat)heightForConfirmCell:(NSArray *)data
{
    CGFloat constantHeight = 40 + 40;
    
    return constantHeight + data.count * 42;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.rowHeight = 42;
    self.tableView.separatorColor = [AppTheme lineColor];
    [self.tableView registerNib:[ConfirmOrderListCell nib] forCellReuseIdentifier:@"ConfirmOrderListCell"];
}

- (void)dataDidChange
{
    NSArray * dataArray = self.data;
    
    if ( dataArray.count )
    {
//        id data = dataArray[0];
//        if ( [data isKindOfClass:[PARKINGINFO class]] )
//        {
//            PARKINGINFO * info = (PARKINGINFO *)data;
//            self.totalLabel.text = info.fees;
//        }
//        else
//        {
//            float totalMoney = 0;
//            for (ORDERINFO * orderInfo in dataArray)
//            {
//                totalMoney += orderInfo.totalMoney.floatValue;
//            }
//            self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];
//        }
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * dataArray = self.data;
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderListCell" forIndexPath:indexPath];
    NSArray * dataArray = self.data;
    cell.data = dataArray[indexPath.row];
    return cell;
}

@end
