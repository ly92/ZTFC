//
//  MsgAdViewController.m
//  EstateBiz
//
//  Created by ly on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MsgAdViewController.h"

@interface MsgAdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;

@property (weak, nonatomic) IBOutlet UIImageView *bigImgV;
@property (copy, nonatomic) NSString *titleText;//
@property (copy, nonatomic) NSString *imgUrl;//
@property (copy, nonatomic) NSString *timeStr;//
@property (copy, nonatomic) NSString *content;//
@end

@implementation MsgAdViewController
- (instancetype)initWithImgUrl:(NSString *)imgUrl Title:(NSString *)title Time:(NSString *)time Content:(NSString *)content{
    if (self = [super init]){
        self.titleText = title;
        self.imgUrl = imgUrl;
        self.timeStr = time;
        self.content = content;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"广告详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    if ([ISNull isNilOfSender:self.imgUrl]){
        self.imgVH.constant = 0;
    }else{
    [self.imgV setImageURL:[NSURL URLWithString:self.imgUrl]];
        [self.imgV addTapAction:@selector(bigImg) forTarget:self];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.timeStr longLongValue]];
    self.timeLbl.text = [date stringWithFormat:@"yyyy-MM-dd"];
    
//    self.timeLbl.text = [NSDate longlongToDate:self.timeStr];
    self.titleLbl.text = self.titleText;
    self.contentLbl.text = self.content;
    [self.contentLbl autoCalculateTextViewFrame];
}

- (void)bigImg{
    self.bigImgV.hidden = NO;
    
    [self.bigImgV setImageURL:[NSURL URLWithString:self.imgUrl]];
    
    [self.bigImgV addTapAction:@selector(hideBigImgV) forTarget:self];
}

- (void)hideBigImgV{
    self.bigImgV.hidden = YES;
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
