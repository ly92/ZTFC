//
//  CLMealTicketPaySuccessViewController.m
//  colourlife
//
//  Created by 李勇 on 16/1/1.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "CLMealTicketPaySuccessViewController.h"

@interface CLMealTicketPaySuccessViewController ()
@property (nonatomic, retain) NSString *orderid;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *payWayLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
- (IBAction)payClick;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;



@end

@implementation CLMealTicketPaySuccessViewController

- (instancetype)initWithOrderid:(NSString *)orderid{

    if (self = [super init]){
        self.orderid = orderid;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.payBtn.clipsToBounds = YES;
    self.payBtn.layer.cornerRadius = 5;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"地方饭票支付";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
         self.backWithPay();
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.balanceLab.text = @"";
    self.orderNoLab.text = @"";
    self.payWayLab.text = @"";
    self.amountLab.text = @"";
    self.createTimeLab.text = @"";
    self.payBtn.enabled = YES;
    self.payBtn.layer.cornerRadius = 5;
    [self loadPreOrderInfo];
}

-(void)loadPreOrderInfo{

   }

- (IBAction)payClick {
//
    self.payBtn.enabled = NO;
    }
@end
