//
//  CardMsgDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardMsgDetailViewController.h"
#import "SJAvatarBrowser.h"
#import "SDPhotoBrowser.h"


@interface CardMsgDetailViewController ()<SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblTop;

@property (weak, nonatomic) IBOutlet UILabel *msgTypeLbl;



@property (nonatomic, strong) CardMsgDetailModel *cardMsgDetail;
@property (nonatomic, assign) BOOL isBigImg;

//@property (nonatomic, assign) CGFloat imgHeight;
//@property (nonatomic, assign) CGFloat imgWidth;

@property (nonatomic, copy) NSString *imgUrl;

@end

@implementation CardMsgDetailViewController

+(instancetype)spawn{
    return [CardMsgDetailViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    if (self.isAd) {
        self.msgTypeLbl.text = @"广告信息";
        [self prepareAdData];
    }else{
        self.msgTypeLbl.text = @"促销信息";
        //加载数据
        [self loadData];
    }
    
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
    if (self.isAd) {
    self.navigationItem.title = @"广告详情";
    }else{
        self.navigationItem.title = @"信息详情";
    }
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
-(void)prepareAdData{
    self.titleLbl.text = self.adModel.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.adModel.creationtime intValue]]]];
    
    self.contentLbl.text = self.adModel.content;
    
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    
    if (self.adModel.image.length == 0) {
        self.contentImageView.hidden = YES;
        
        self.imgHeight.constant = 0;
        self.contentLblTop.constant = 0;
        
    }else{
        self.contentImageView.hidden = NO;
        
        self.imgUrl = self.adModel.image;
        
        [self.contentImageView setImageWithURL:[NSURL URLWithString:self.adModel.image] placeholder:[UIImage imageNamed:@""]];
        
        UIImage *img = self.contentImageView.image;
        
        if (img.size.width > (SCREENWIDTH-20)) {
            self.imgWidth.constant = SCREENWIDTH-20;
            self.imgHeight.constant = img.size.height * (self.imgWidth.constant/ img.size.width);
            
        }else{
            self.imgWidth.constant = img.size.width;
            self.imgHeight.constant = img.size.height;
        }
        
        
        [self.contentImageView addTapAction:@selector(browseImage) forTarget:self];
        
    }
    
    
    CGFloat height = 231-100+self.imgHeight.constant - 20 + contentHeight;
    
    self.containerViewheight.constant = height;
}

#pragma mark-加载数据
-(void)loadData{
    if (!self.relatedId) {
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    MerchantMsgDetailAPI *merchantMsgDetailApi = [[MerchantMsgDetailAPI alloc]initWithMsgId:self.relatedId];
    
    [merchantMsgDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            self.cardMsgDetail = [CardMsgDetailModel mj_objectWithKeyValues:result[@"Msg"]];
            [self prepareData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
    
    
}

-(void)prepareData{
 
    self.titleLbl.text = self.cardMsgDetail.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.cardMsgDetail.creationtime intValue]]]];
    
    self.contentLbl.text = self.cardMsgDetail.content;
    
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    
    if (self.cardMsgDetail.imageurl.length == 0) {
        self.contentImageView.hidden = YES;
        
        self.imgHeight.constant = 0;
        self.contentLblTop.constant = 0;
        
        CGFloat height = 231-100+self.imgHeight.constant - 20 + contentHeight;
        
        self.containerViewheight.constant = height;

        
    }else{
        self.contentImageView.hidden = NO;
        
        self.imgUrl = self.cardMsgDetail.imageurl;
        
//        [self.contentImageView setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholder:[UIImage imageNamed:@""]];
        
        [self.contentImageView setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholder:[UIImage imageNamed:@""] options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            UIImage *img = self.contentImageView.image;
            
            if (img.size.width > (SCREENWIDTH-20)) {
                self.imgWidth.constant = SCREENWIDTH-20;
                self.imgHeight.constant = img.size.height * (self.imgWidth.constant/ img.size.width);
                
            }else{
                self.imgWidth.constant = img.size.width;
                self.imgHeight.constant = img.size.height;
            }
            CGFloat height = 231-100+self.imgHeight.constant - 20 + contentHeight;
            
            self.containerViewheight.constant = height;
        }];
        
         [self.contentImageView addTapAction:@selector(browseImage) forTarget:self];
    }
}

-(void)browseImage{
    
//    [SJAvatarBrowser
//     showImage:self.contentImageView];
    
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.sourceImagesContainerView = self.view;
    browser.imageCount = 1;
    browser.delegate = self;
    [browser show];
    
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.imgUrl withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.contentImageView.image;
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
