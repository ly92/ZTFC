//
//  PropertyOrderInfoCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  预缴物业费详细信息

#import "PropertyOrderInfoCell.h"
#import "PropertyCategoryCell.h"

@interface PropertyOrderInfoCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PropertyOrderInfoCell

+ (CGFloat)heightForData:(NSArray *)data
{
    return 35 * data.count;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.rowHeight = 35;
    self.tableView.separatorColor = [AppTheme lineColor];
    
    [self.tableView registerNib:[PropertyCategoryCell nib] forCellReuseIdentifier:@"PropertyCategoryCell"];
}

- (void)dataDidChange
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * dataArray = self.data;
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCategoryCell" forIndexPath:indexPath];
    NSArray * dataArray = self.data;
    cell.data = dataArray[indexPath.row];
    return cell;
}

@end
