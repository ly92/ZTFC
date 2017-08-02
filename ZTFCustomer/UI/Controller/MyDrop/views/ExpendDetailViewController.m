//
//  ExpendDetailViewController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ExpendDetailViewController.h"

@interface ExpendDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLblHeight;


@end

@implementation ExpendDetailViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    [self prepareData];
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
    
    self.navigationItem.title = @"支出详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

-(void)prepareData{
    [_moneyLabel setText:[NSString stringWithFormat:@"%@",self.expendModel.money]];
    if (![ISNull isNilOfSender:self.expendModel.content]) {
        [_typeLabel setText:self.expendModel.content];
        
        self.typeLblHeight.constant = [_typeLabel resizeHeight]>16?[_typeLabel resizeHeight]:16;
        
    }
    _timerLabel.text = self.expendModel.create_time;
    [_snLabel setText:self.expendModel.sn];

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
