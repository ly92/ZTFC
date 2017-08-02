//
//  CardSubBranchViewController.m
//  colourlife
//
//  Created by ly on 16/1/15.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardSubBranchViewController.h"
#import "CardSubbranchTableViewCell.h"
#import "MemberCardDetailModel.h"

@interface CardSubBranchViewController ()
@property (nonatomic, strong) NSArray *branches;
@property (nonatomic, strong) NSURL *callUrl;

@end

@implementation CardSubBranchViewController

- (instancetype)initWithBranchArray:(NSArray *)branches{
    if (self = [super init]){
        self.branches = branches;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }

    self.navigationItem.title = @"全部分店";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBCOLOR(240, 240, 240);
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![ISNull isNilOfSender:self.branches]){
        return self.branches.count;
    }
    return 0;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.branches.count != 0){
         static NSString *ID = @"CardSubbranchTableViewCell";
         CardSubbranchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
         if (!cell){
             cell = [[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil].firstObject;
         }
         cell.data = [self.branches objectAtIndex:indexPath.row];
         
         cell.call = ^{
             Branch *branch = [self.branches objectAtIndex:indexPath.row];
             if (!branch) return;
             NSString *tel = branch.tel;
             
             if (tel!=nil&&[tel trim].length>0) {
                 
                 if ([tel containsString:@"-"]) {
                     tel=[tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 }
                 tel=[tel trim];
                 
                 NSString *realnum = [NSString stringWithFormat:@"tel://%@",tel];
                 self.callUrl = [NSURL URLWithString:realnum];
                 
                 if (self.callUrl) {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
                     [alert show];
                     
                 }
             }

         };
         return cell;
     }
     return nil;
 }

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    view.backgroundColor = RGBCOLOR(240, 240, 240);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardSubbranchTableViewCell *cell = (CardSubbranchTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        if ([[UIApplication sharedApplication] openURL:self.callUrl]) {
            [[UIApplication sharedApplication] openURL:self.callUrl];
        }
        else
        {
             [self presentFailureTips:@"此设备无法拨打电话"];
        }
    }
}


@end
