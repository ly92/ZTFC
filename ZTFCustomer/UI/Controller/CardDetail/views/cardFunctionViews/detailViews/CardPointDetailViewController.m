//
//  CardPointDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPointDetailViewController.h"
#import "CardPointModel.h"
@interface CardPointDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (nonatomic, strong) CardPointData *point;
@property (nonatomic, strong) NSString *name;

@end

@implementation CardPointDetailViewController

- (instancetype)initWithPoint:(CardPointData *)point Name:(NSString *)name{
    if (self = [super init]) {
        self.point = point;
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"交易详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.shopName.text = self.name;
    int state = [self.point.status intValue];
    if (state == 1) {
        self.stateL.text = @"交易成功";
        if ([self.point.cptypes intValue] == 1 && [self.point.subtype intValue] == 4){
            self.typeL.text = @"充值积分";
            self.navigationItem.title = @"积分充值";
        }else if ([self.point.cptypes intValue] == 2 && [self.point.subtype intValue] == 4){
            self.typeL.text = @"奖励消费";
            self.navigationItem.title = @"积分消费";
        }else{
            self.typeL.text = @"奖励积分";
            self.navigationItem.title = @"积分奖励";
        }
        
    }
    else {
        self.stateL.text = @"交易取消";
    }
    
//    self.timeL.text = [NSDate longlongToDate:self.point.creationtime];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.point.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.amountL.text = self.point.points;
    self.orderNo.text = self.point.clientpointsid;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
