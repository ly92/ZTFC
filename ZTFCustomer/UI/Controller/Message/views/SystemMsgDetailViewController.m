//
//  SystemMsgDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SystemMsgDetailViewController.h"
#import "SystemMsgDetailCell.h"

static NSString *identifier = @"SystemMsgDetailCell";

@interface SystemMsgDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;



@end

@implementation SystemMsgDetailViewController

+(instancetype)spawn{
    return [SystemMsgDetailViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
     [self.tv registerNib:[UINib nibWithNibName:@"SystemMsgDetailCell" bundle:nil] forCellReuseIdentifier:identifier];
    
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

#pragma mark-navibar

-(void)setNavigationBar{
    
    self.navigationItem.title = self.titleStr;
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.systemMsgModel) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemMsgDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell.titleLbl setText:self.systemMsgModel.name];
    [cell.contentLbl setText:self.systemMsgModel.content];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [cell.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.systemMsgModel.creationtime intValue]]]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tv cellHeightForIndexPath:indexPath model:self.systemMsgModel keyPath:@"data" cellClass:[SystemMsgDetailCell class] contentViewWidth:SCREENWIDTH];
    
//    return 0;
    
    
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
