//
//  VoucherDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "VoucherDetailViewController.h"
#import "VoucherDetailCell.h"
#import "PresentView.h"
#import "VoucherHeaderView.h"
#import "CouponListModel.h"
#import "PopCouponSN.h"
#import "SendCouponAPI.h"

#define kImageOriginHight 150
//优惠码二维码
#define CARTOON_C_SN_URL @"http://www.kakatool.com/?B=%@&C=%@&SN=%@"
//优惠券二维码(门票券)
#define CARTOON_C_TICKET_URL @"http://www.kakatool.com/?B=%@&C=%@&SN=%@&TYPE=2"

@interface VoucherDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PresentViewDelegate>
//
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UITableView *tv;

@property (nonatomic, strong) NSMutableArray *sns;
@property (nonatomic,strong) VoucherHeaderView *headerView;

@property (nonatomic, strong) CouponModel *voucher;
//
@property (nonatomic, strong) PopCouponSN *popView;


@property (assign, nonatomic) NSInteger maxNum;//

@end

@implementation VoucherDetailViewController

- (NSMutableArray *)sns{
    if (!_sns){
        _sns = [NSMutableArray array];
    }
    return _sns;
}

- (instancetype)initWithVOUCHER:(CouponModel *)voucher{
    if (self = [super init]){
        [self.sns removeAllObjects];
        [self.sns addObjectsFromArray:voucher.sns];
        self.voucher = voucher;
        self.maxNum = [self.voucher.unuse intValue];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 64 - 18)];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    [self.view addSubview:self.tv];
    
    [self prepareHeaderView];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"赠送" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.title = @"我的优惠券";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.tv registerNib:[VoucherDetailCell nib] forCellReuseIdentifier:@"VoucherDetailCell"];
    self.tv.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (![ISNull isNilOfSender:self.voucher.imageurl]){
        [self prepareicon];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deductMoney:) name:@"DEDUCTMONEY" object:nil];
    
    
    
}
-(void)deductMoney:(NSNotification *)noti{
    
    
    if(self.popView){
        [self.popView hide];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareicon{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageOriginHight, SCREENWIDTH, kImageOriginHight)];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
    self.tv.contentOffset = CGPointMake(0, -kImageOriginHight);
    
    @weakify(self)
    [self.icon setImageWithURL:[NSURL URLWithString:self.voucher.imageurl] placeholder:[UIImage imageNamed:@"b0_banner_loading"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self)
        UIImage *img = self.icon.image;
        CGFloat height = img.size.height * (_icon.w/img.size.width);
        self.tv.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);;
        [self.tv addSubview:self.icon];
    }];
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.voucher.imageurl]  placeholderImage:[UIImage imageNamed:@"b0_banner_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        UIImage *img = self.icon.image;
//        CGFloat height = img.size.height * (_icon.w/img.size.width);
//        self.tv.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);;
//        [self.tv addSubview:self.icon];
//    }];
    
}

- (void)prepareHeaderView{
    self.headerView = [[VoucherHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    self.headerView.voucherTitleLbl.text = self.voucher.title;
    self.headerView.descLbl.text = self.voucher.contents;
    self.headerView.nameLbl.text = self.voucher.name;
    self.headerView.addresslbl.text = self.voucher.address;
    
    CGSize size = [self.headerView.descLbl sizeThatFits:CGSizeMake(self.headerView.descLbl.w, self.headerView.descLbl.h)];
    if (size.height > 21){
        self.headerView.descLblH.constant = size.height;
        self.headerView.height += size.height - 21;
    }
    
    CGSize size2 = [self.headerView.addresslbl sizeThatFits:CGSizeMake(self.headerView.addresslbl.w, self.headerView.addresslbl.h)];
    if (size2.height > 21){
        self.headerView.addressLblH.constant = size2.height;
        self.headerView.height += size2.height - 21;
    }
    
    self.tv.tableHeaderView = self.headerView;
}

- (void)present{
    
    if ([self.voucher.unuse intValue] <= 0 || self.maxNum <= 0){
        [self presentFailureTips:@"无可用券"];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    PresentView *presentView = [[PresentView alloc] initWithMax:self.maxNum];
    presentView.frame = window.bounds;
    presentView.delegate = self;
    [window addSubview:presentView];
}

#pragma mark - PresentViewDelegate
//发送赠送请求
- (void)didClickPresentBtn:(NSInteger)count Mobile:(NSString *)mobile{
    NSMutableArray *snArrayM = [NSMutableArray array];
    NSMutableArray *delSns = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++) {
        SnModel *sn = self.sns[i];
        [snArrayM addObject:sn.sn];
        [delSns addObject:sn];
    }
    
    NSString *sn = [snArrayM componentsJoinedByString:@","];
    NSLog(@"sn:%@",sn);
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    SendCouponAPI *sendApi = [[SendCouponAPI alloc] initWithSn:sn Mobile:mobile];
    [sendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"转赠成功！"];
            [self.sns removeObjectsInArray:delSns];
            //最多赠送数量减少
            self.maxNum -= count;
            self.reloadTable();
            [self.tv reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"givenCouponSnSuccess" object:nil];
            
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_sns.count != 0){
        return _sns.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"VoucherDetailCell";
    VoucherDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell){
        cell = [[VoucherDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.amount = self.voucher.amount;
    cell.data = [self.sns objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /**
     @interface VOUCHER_SEC : NSObject
     @property (strong, nonatomic) NSString *end_date;
     @property (strong, nonatomic) NSString *orguser;//
     @property (strong, nonatomic) NSString *sn;//
     @property (strong, nonatomic) NSString *start_date;//
     @property (strong, nonatomic) NSString *status;
     @end
     */
    NSString *bid= self.voucher.bid;
    
    if (![ISNull isNilOfSender:self.sns]) {
        SnModel *snModel = [self.sns objectAtIndex:indexPath.row];
        
        if (snModel) {
            NSString *begin = snModel.start_date;
            NSString *now = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            if ([now compare:begin] == NSOrderedAscending) {//不可使用
                //                [self presentFailureTips:@"代金券未到使用时间"];
                return;
            }
            
            NSString *endDate = snModel.end_date;
            if ([now compare:endDate] == NSOrderedDescending) {//过期
                //                [self presentFailureTips:@"代金券已过期"];
                return;
            }
            
            NSString *sn = snModel.sn;
            NSString *cid = [LocalData shareInstance].getUserAccount.cid;
            NSString *qrcode= [NSString stringWithFormat:CARTOON_C_SN_URL,bid,cid,sn];
            int isalliance = [self.voucher.isalliance intValue];
            if (isalliance == 2) {
                qrcode = [NSString stringWithFormat:CARTOON_C_TICKET_URL,bid,cid,sn];
            }
            
            if ([sn trim].length != 0) {
                if (self.popView == nil) {
                    self.popView = [[PopCouponSN alloc] initWithParentController:self.parentViewController];
                }
                
                if (self.popView) {
                    [self.popView showQR:qrcode WithSN:sn];
                }
            }
        }
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    //PRINT(@"yOffset : %f",yOffset);
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.icon.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.icon.frame = f;
        self.tv.contentOffset = CGPointMake(0, yOffset);
    }
}

@end
