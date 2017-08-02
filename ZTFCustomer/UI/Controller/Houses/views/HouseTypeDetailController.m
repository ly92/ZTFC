//
//  HouseTypeDetailController.m
//  ztfCustomer
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseTypeDetailController.h"
#import "MWPhotoBrowser.h"

@interface HouseTypeDetailController ()<UIAlertViewDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (weak, nonatomic) IBOutlet UIView *pageControlView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaLblWidth;

@property (weak, nonatomic) IBOutlet UILabel *orientationLbl;
@property (weak, nonatomic) IBOutlet UILabel *downPaymentLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthPaymentLbl;

@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UIButton *callButton;


@property (weak, nonatomic) IBOutlet UILabel *introductionLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionLblHeight;
@property (weak, nonatomic) IBOutlet UIView *introductionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionViewHeight;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *clickBtn;

@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) NSMutableArray *mwPhotoArray;

@property (nonatomic, assign) NSInteger cancelInt;

@end

@implementation HouseTypeDetailController

+(instancetype)spawn{
    return [HouseTypeDetailController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.callButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
//    self.pageControlView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    //未选中的点颜色
    self.pageControl.pageIndicatorTintColor = PAGECONTROL_UNSELECT_COLOR;
    //当前选中的点的颜色
    self.pageControl.currentPageIndicatorTintColor = PAGECONTROL_SELECT_COLOR;
    
    self.headViewHeight.constant = (SCREENWIDTH *450)/750;
    self.areaLblWidth.constant = (SCREENWIDTH-20)/2.0;
    
    [self prepareData];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HIDETABBAR;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"户型详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        if (self.isCollect ) {
            
            if (self.cancelInt == 2) {
                //取消收藏
                [self fk_postNotification:@"CANCELCOLLECTHOUSETYPESUCCESS" object:self.houseTypeModel];
            }else if(self.cancelInt == 1){
                //重新收藏
                 [self fk_postNotification:@"COLLECTHOUSETYPESUCCESS" object:self.houseTypeModel];
                
            }
            
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
        
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 24);
    [button setImage:[UIImage imageNamed:@"house_collect"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_collect_pre"] forState:UIControlStateSelected];
    self.rightBtn = button;
    [rightView addSubview:button];
    
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, 40, 20)];
    lbl.text = @"收藏";
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14];
    [rightView addSubview:lbl];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(0, 0, 40, 44);
    [clickButton setTitle:@"" forState:UIControlStateNormal];
    self.clickBtn = clickButton;
    [rightView addSubview:clickButton];
    
    [clickButton addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}
-(void)collectClick:(UIButton *)btn{
    self.clickBtn.selected =!self.clickBtn.selected;
    self.rightBtn.selected = self.clickBtn.selected;
    
    
    self.rightBtn.userInteractionEnabled = self.clickBtn.userInteractionEnabled = NO;
    
    NSInteger status = [self.houseTypeModel.is_favorite integerValue];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    HouseTypeCollectAPI *housetypecollectApi = [[HouseTypeCollectAPI alloc]initWithProjectId:self.projectId housetypeId:self.houseTypeModel.id];
    
    if (status == 0) {
        //收藏
        housetypecollectApi.housetypeCollectType = housetypeCollectType;
    }else{
        //取消收藏
        housetypecollectApi.housetypeCollectType = housetypeCancelCollectType;
    }
    
    
    [housetypecollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        self.rightBtn.userInteractionEnabled = self.clickBtn.userInteractionEnabled = YES;
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"%@",result);
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            if (status == 0) {
                
                [self presentSuccessTips:@"收藏户型成功"];

                self.cancelInt = 1;
                //收藏
                self.houseTypeModel.is_favorite = @"1";
                self.clickBtn.selected = YES;
                self.rightBtn.selected = self.clickBtn.selected;

            }else{
               [self presentSuccessTips:@"取消收藏户型"];
                
                self.cancelInt = 2;
                //取消收藏
                self.houseTypeModel.is_favorite = @"0";
                self.clickBtn.selected = NO;
                self.rightBtn.selected = self.clickBtn.selected;

            }
            [self fk_postNotification:@"OPERATEHOUSETYPESUCCESS" object:self.houseTypeModel];
            
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.rightBtn.userInteractionEnabled = self.clickBtn.userInteractionEnabled = YES;
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
    
    
}

#pragma mark - 初始化
-(NSMutableArray *)mwPhotoArray{
    if (!_mwPhotoArray) {
        _mwPhotoArray = [NSMutableArray array];
    }
    return _mwPhotoArray;
}

#pragma mark - loadData

-(void)prepareData{
    if (self.houseTypeModel) {
        
        [self setHeadScroolView];
        
        NSInteger status = [self.houseTypeModel.is_favorite integerValue];
        
        if (status == 0) {
            self.clickBtn.selected = NO;
            
        }else{
            self.clickBtn.selected = YES;
        }
        self.rightBtn.selected = self.clickBtn.selected;
        
        self.nameLbl.text = self.houseTypeModel.name;
        self.areaLbl.text = [NSString stringWithFormat:@"面积  %@㎡",self.houseTypeModel.covered_area];
        self.orientationLbl.text = [NSString stringWithFormat:@"朝向  %@",self.houseTypeModel.orientation];
        
        
        NSString *downPaymentStr = @"";
        CGFloat downPayment = [self.houseTypeModel.downpayment floatValue];
        
        if (downPayment > 10000) {
            
            
            downPayment = downPayment / 10000;
            
            downPaymentStr = [NSString stringWithFormat:@"%.2f万",downPayment];
            
        }else{
            downPaymentStr = [NSString stringWithFormat:@"%.2f",downPayment];
        }
        
        self.downPaymentLbl.text = [NSString stringWithFormat:@"首付  %@元",downPaymentStr];
        
        NSString *monthPaymentStr = @"";
        CGFloat monthPayment = [self.houseTypeModel.monthly_payment floatValue];
        
        if (monthPayment > 10000) {
            
            monthPayment = monthPayment / 10000;
            
            monthPaymentStr = [NSString stringWithFormat:@"%.2f万",monthPayment];
            
        }else{
            monthPaymentStr = [NSString stringWithFormat:@"%.2f",monthPayment];
        }
        
        self.monthPaymentLbl.text = [NSString stringWithFormat:@"月供  %@元",monthPaymentStr];
        
        self.mobileLbl.text = self.houseTypeModel.mobile;
        
        self.introductionLbl.text = self.houseTypeModel.intro;
        
        CGFloat introductionHeight = [self.introductionLbl resizeHeight];
        
        if (introductionHeight > 20) {
            self.introductionLblHeight.constant = introductionHeight;
        }else{
            self.introductionLblHeight.constant = 20;
        }
        
        
        self.introductionViewHeight.constant = 70 -20 + self.introductionLblHeight.constant;
        
        self.containerViewHeight.constant = 450 -160+self.headViewHeight.constant- 70 + self.introductionViewHeight.constant;
        
    }
}

-(void)setHeadScroolView{
    if (self.houseTypeModel.album.resources.count > 0 ) {
        
        ResourceModel *resourceModel = self.houseTypeModel.album.resources[self.houseTypeModel.album.resources.count-1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.tag = 100+self.houseTypeModel.album.resources.count -1;
        imageView.userInteractionEnabled = YES;
        
//        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        imageView.contentMode =  UIViewContentModeScaleAspectFill;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        imageView.clipsToBounds = YES;
        
        [self.headScrollView addSubview:imageView];
    }
    
    for (int i=0; i<self.houseTypeModel.album.resources.count; i++) {
        ResourceModel *resourceModel = self.houseTypeModel.album.resources[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*(i+1), 0, SCREENWIDTH, self.headViewHeight.constant)];
        imageView.tag = 100+i;
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        
        
//        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        imageView.contentMode =  UIViewContentModeScaleAspectFill;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvClick:)];
        [imageView addGestureRecognizer:tap];
        [self.headScrollView addSubview:imageView];
        
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:resourceModel.url]];
        [self.mwPhotoArray addObject:photo];
        
    }
    if (self.houseTypeModel.album.resources.count > 0) {
        
        ResourceModel *resourceModel = self.houseTypeModel.album.resources[0];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.houseTypeModel.album.resources.count + 1)*SCREENWIDTH , 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100;

        [self.headScrollView addSubview:imageView];
        
    }
    self.headScrollView.contentSize = CGSizeMake(SCREENWIDTH*(self.houseTypeModel.album.resources.count+2), 0);
    self.headScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    self.pageControl.numberOfPages = self.houseTypeModel.album.resources.count;
    [self setupTimer];
}

//图片点击
-(void)imgvClick:(UITapGestureRecognizer *)tap{

    // 预览照片

    MWPhotoBrowser *mwPhoto = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    mwPhoto.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    mwPhoto.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    mwPhoto.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    mwPhoto.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    mwPhoto.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    mwPhoto.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    mwPhoto.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//    mwPhoto.autoPlayOnAppear = NO;
    
    [mwPhoto setCurrentPhotoIndex:self.pageControl.currentPage];
    
    [self.navigationController pushViewController:mwPhoto animated:YES];
}

#pragma mark - click

//计算机点击
- (IBAction)calcutorClick:(id)sender {
    
    WebViewController *webView = [WebViewController spawn];
    webView.webTitle = @"房贷计算器";
    webView.webURL = @"http://fdzj.999ccc.cn/mob/html/fangdaijisuanqi/fangdaijisuanqi.html";
    [self.navigationController pushViewController:webView animated:YES];
}

//贷款点击
- (IBAction)loanClick:(id)sender {
    
}

- (IBAction)mobileClick:(id)sender {
    
    [UIAlertView bk_showAlertViewWithTitle:@"确定拨打电话" message:self.houseTypeModel.mobile cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //拨打电话
            NSString *tel = [NSString stringWithFormat:@"tel://%@",self.houseTypeModel.mobile];
            NSURL *callUrl = [NSURL URLWithString:tel];
            
            if ([[UIApplication sharedApplication]canOpenURL:callUrl]) {
                
            }else{
                
                [self presentFailureTips:@"不支持此功能"];
            }
        }
       

    }];
    
}
#pragma mark - uiscrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != self.headScrollView) {
        return;
    }
    
    //开始拖动scrollview的时候 停止计时器控制的跳转
    if (self.timer&&[self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer=nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger total = self.houseTypeModel.album.resources.count;
    
    NSInteger page = floor((scrollView.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
//    NSInteger screenpage = page;
    NSInteger offset = scrollView.contentOffset.x;
    
    NSInteger offpage = offset/SCREENWIDTH;
    
    if ( offpage < 1) {
        page = total;
    }
    if (offpage > total) {
        page = 1 ;
    }
//    [self.headScrollView setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.headScrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    self.pageControl.currentPage = page-1 ;
    
    
}

#pragma mark - 轮播
- (void)setupTimer{
    //开始定时
    if (self.timer&&[self.timer isValid]) {
        [self.timer invalidate];
    }
    if (self.houseTypeModel.album.resources.count>0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoSlide:) userInfo:nil repeats:YES];
    }
}

-(void)autoSlide:(id)sender
{
    
    NSUInteger total = self.houseTypeModel.album.resources.count;
    int page = floor((self.headScrollView.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
    
    page ++;
    NSInteger screenpage = page;
    if (page > total){
        page = 1;
    }
    [self.headScrollView setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.headScrollView.contentOffset = CGPointMake((page-1) * SCREENWIDTH, 0);
    self.pageControl.currentPage = page - 1;
    
}

#pragma mark - MWPhotoDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mwPhotoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mwPhotoArray.count) {
        return [self.mwPhotoArray objectAtIndex:index];
    }
    return nil;
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
