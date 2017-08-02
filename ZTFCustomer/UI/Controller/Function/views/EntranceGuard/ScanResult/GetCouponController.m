//
//  GetCouponController.m
//  colourlife
//
//  Created by 成运 on 16/3/3.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "GetCouponController.h"
#import "VoucherTableViewController.h"

#define kImageOriginHight 150

@interface GetCouponController ()<UIScrollViewDelegate>


//控件
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIButton *getCouponBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;


@property (weak, nonatomic) IBOutlet UIImageView *shopNameImgView;
@property (weak, nonatomic) IBOutlet UIImageView *addressImgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;



@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, strong) Businessinfo *bizInfo;
@property (nonatomic, strong) CouponModel *couponInfo;



@property (strong, nonatomic) UIImageView *icon;

@end

@implementation GetCouponController

- (id)initWithBid:(NSString *)aBid couponId:(NSString *)aCouponId
{
    if (self = [super init]) {
        
        self.bid = aBid;
        self.couponId = aCouponId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.getCouponBtn.clipsToBounds = YES;
    self.getCouponBtn.layer.cornerRadius = 5;
    
    self.shopNameImgView.clipsToBounds = self.addressImgView.clipsToBounds = self.phoneImgView.clipsToBounds = YES;
    self.shopNameImgView.layer.cornerRadius = self.addressImgView.layer.cornerRadius = self.phoneImgView.layer.cornerRadius = 5;
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    //设置导航栏的数据
    [self setupNavgationBar];
    
    //加载数据
    [self loadData];
    
}
-(void)updateViewConstraints{
    self.priceViewWidth.constant = (SCREENWIDTH -1)/2.0;
    [super updateViewConstraints];
}

//设置导航栏的数据
-(void)setupNavgationBar{
    self.navigationItem.title=@"优惠码详情";
    self.navigationItem.leftBarButtonItem=[AppTheme backItemWithHandler:^(id sender) {
        if (self.entranceGuard) {
            [self.navigationController popToViewController:self.entranceGuard animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

-(void)loadData{
    
    if (self.couponId == nil) {
         [self presentFailureTips:@"获取优惠券信息失败"];
        if (self.entranceGuard) {
            [self.navigationController popToViewController:self.entranceGuard animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    ScanGetCouponAPI *scanGetCouponApi = [[ScanGetCouponAPI alloc]initWithCouponid:self.couponId];
    
    scanGetCouponApi.couponType = COUPONINFO;
    
    [scanGetCouponApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
          
            NSDictionary *bizInfoDic = result[@"BizInfo"];
            NSDictionary *couponInfoDic = result[@"CouponInfo"];
            
            if (![ISNull isNilOfSender:bizInfoDic]) {
                self.bizInfo = [Businessinfo mj_objectWithKeyValues:bizInfoDic];
            }
            
            if (![ISNull isNilOfSender:couponInfoDic]) {
                
            }
            
            
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
    if (!_bizInfo || !_couponInfo) {
        return;
    }
    
    NSString *urlStr = self.couponInfo.imageurl;
    
    if (![ISNull isNilOfSender:urlStr]) {
        [self prepareicon];
    }
    
    if ([[urlStr lowercaseString] containsString:@".jpg"]||[[urlStr lowercaseString] containsString:@".jpeg"]||[[urlStr lowercaseString] containsString:@".png"]) {
       [self prepareicon];
    }
    
    self.titleLabel.text = self.couponInfo.title;
    
    NSString *total = self.couponInfo.nums;
    if ([total intValue] == 0 || [total intValue]>=999999999) {
        total = @"无限制";
    }
    
    self.contentlabel.text = [NSString stringWithFormat:@"名额：%@   已领：%@",total,self.couponInfo.use_nums];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.couponInfo.amount];
    self.expireLabel.text = [NSString stringWithFormat:@"%@天",self.couponInfo.expire];
    
    self.detailLabel.text = self.couponInfo.contents;
    
    CGSize size = [self.detailLabel sizeThatFits:CGSizeMake(self.detailLabel.size.width, MAXFLOAT)];
    
    self.detailLabelHeight.constant = 10+size.height;
    
    self.detailViewHeight.constant = 50+size.height;
    
    self.shopNameLabel.text = self.bizInfo.name;
    self.addressLabel.text = self.bizInfo.address;
    self.phoneLabel.text = self.bizInfo.tel;
    
    self.containerViewHeight.constant = 410-70+self.detailViewHeight.constant+10;
    
}
- (void)prepareicon{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageOriginHight, SCREENWIDTH, kImageOriginHight)];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    NSLog(@"%@",self.couponInfo.imageurl);
    self.icon.clipsToBounds = YES;
    self.sv.contentOffset = CGPointMake(0, -kImageOriginHight);
    
    @weakify(self)
    [self.icon setImageWithURL:[NSURL URLWithString:self.couponInfo.imageurl] placeholder:[UIImage imageNamed:@"b0_banner_loading"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self)
        UIImage *img = self.icon.image;
        CGFloat height = img.size.height * (_icon.w/img.size.width);
        
        self.sv.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);;
        [self.sv addSubview:self.icon];
    }];
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.couponInfo.imageurl]  placeholderImage:[UIImage imageNamed:@"b0_banner_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        UIImage *img = self.icon.image;
//        CGFloat height = img.size.height * (_icon.w/img.size.width);
//
//        self.sv.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);;
//        [self.sv addSubview:self.icon];
//
//    }];

}

#pragma mark-代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.icon.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.icon.frame = f;
        self.sv.contentOffset = CGPointMake(0, yOffset);
    }
}

#pragma mark-点击

- (IBAction)getCouponClick:(id)sender {
    if (self.couponId == nil) {
         [self presentFailureTips:@"领取失败"];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    ScanGetCouponAPI *getCounponAPi = [[ScanGetCouponAPI alloc]initWithCouponid:self.couponId];
    
    getCounponAPi.couponType = GETCOUPON;

    [getCounponAPi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            VoucherTableViewController *vouvher = [[VoucherTableViewController alloc]initWithBid:nil];
            vouvher.isCouponTicket = YES;
            vouvher.refreshBadgeBlock = ^(){
                
            };
            [self.navigationController pushViewController:vouvher animated:YES];
            
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
