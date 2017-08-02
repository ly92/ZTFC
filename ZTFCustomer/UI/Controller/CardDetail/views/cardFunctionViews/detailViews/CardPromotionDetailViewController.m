//
//  CardPromotionDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPromotionDetailViewController.h"
#import "CardPromotionModel.h"
#import "SJAvatarBrowser.h"

@interface CardPromotionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PromotionModel *promotion;
@property (nonatomic, assign) BOOL isBigImg;

@end

@implementation CardPromotionDetailViewController

- (instancetype)initWithBusName:(NSString *)name Promotion:(PromotionModel *)promotion{
    if (self = [super init]){
        self.name = name;
        self.promotion = promotion;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"信息详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.promotion.bid) {
        
        [[LocalizePush shareLocalizePush] updateLoaclCardId:self.promotion.bid Kind:CardMsg];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    }
    
    if ([ISNull isNilOfSender:self.promotion.imageurl]){
        self.imgV.hidden = YES;
        self.imgVH.constant = 0;
    }else{
        self.imgV.hidden = NO;
        self.imgVH.constant = 200;
        [self.imgV setImageURL:[NSURL URLWithString:self.promotion.imageurl]];
        
//        UIImage *img = self.imgV.image;
//        if (img.size.width > img.size.height){
//            self.imgV.image = [UIImage imageWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationRight];
//        }
        
    }
    [self.imgV addTapAction:@selector(imgClick) forTarget:self];
    self.nameL.text = self.name;
//    self.timeL.text = [NSDate longlongToDateTime:self.promotion.creationtime];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.promotion.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    
    self.contentText.text = self.promotion.content;
}

- (void)imgClick{
    
    [SJAvatarBrowser showImage:self.imgV];
    
//    if (self.isBigImg){
//    
//        [UIView animateWithDuration:0.5f animations:^{
//            
//            self.imgV.frame = CGRectMake(30, 80, SCREENWIDTH - 60, 200);
//        }];
//        self.imgV.contentMode = UIViewContentModeScaleToFill;
//    }else{
//        
//        self.imgV.backgroundColor = [UIColor blackColor];
//        [UIView animateWithDuration:0.5f animations:^{
//                self.imgV.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//            self.imgV.contentMode = UIViewContentModeScaleAspectFit;
//        }];
//        
//    }
//    
//    self.isBigImg = !self.isBigImg;
}

@end
