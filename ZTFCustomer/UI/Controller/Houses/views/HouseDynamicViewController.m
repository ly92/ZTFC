//
//  HouseDynamicViewController.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HouseDynamicViewController.h"
#import "HouseDynamicModel.h"
#import "MWPhotoBrowser.h"


@interface HouseDynamicViewController ()<UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (weak, nonatomic) IBOutlet UIView *pageControlView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *dynamicTitleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblH;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblH;

@property (nonatomic, strong) HouseDynamicModel *houseDynamicModel;
@property (nonatomic, strong) NSMutableArray *mwPhotoArray;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation HouseDynamicViewController
+(instancetype)spawn{
    return [HouseDynamicViewController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"楼盘动态";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.headViewHeight.constant = (SCREENWIDTH *450)/750;
    //未选中的点颜色
    self.pageControl.pageIndicatorTintColor = PAGECONTROL_UNSELECT_COLOR;
    //当前选中的点的颜色
    self.pageControl.currentPageIndicatorTintColor = PAGECONTROL_SELECT_COLOR;
    //加载详情数据
    [self loadDetailData];
}

#pragma mark - 初始化
-(NSMutableArray *)mwPhotoArray{
    if (!_mwPhotoArray) {
        _mwPhotoArray = [NSMutableArray array];
    }
    return _mwPhotoArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDetailData{
    HouseDynamicDetailApi *dynamicDetailApi = [[HouseDynamicDetailApi alloc] initWithProjectProgressId:self.projectProgressId];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    [dynamicDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            self.houseDynamicModel = [HouseDynamicModel mj_objectWithKeyValues:[content objectForKey:@"progressDetail"]];
            self.dynamicTitleLbl.text = self.houseDynamicModel.progress_title;
            self.timeLbl.text = self.houseDynamicModel.create_at;
            self.contentLbl.text = self.houseDynamicModel.progress_content;
            
            CGFloat titleHeight = [self.dynamicTitleLbl resizeHeight];
            if (titleHeight > 20) {
                self.titleLblH.constant = titleHeight;
            }else{
                self.titleLblH.constant = 20;
            }
            
            CGFloat contentHeight = [self.contentLbl resizeHeight];
            if (contentHeight > 20) {
                self.contentLblH.constant = contentHeight;
            }else{
                self.contentLblH.constant = 20;
            }
            
            
            self.containerViewHeight.constant = self.headViewHeight.constant + 55 + self.titleLblH.constant + self.contentLblH.constant + 20;
            
            
            [self setHeadScroolView];
           
        }else{
            [self presentFailureTips:result[@"message"]];
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

-(void)setHeadScroolView{
    if (self.houseDynamicModel.progress_imgs.count > 0 ) {
        
        NSString *url = self.houseDynamicModel.progress_imgs[self.houseDynamicModel.progress_imgs.count-1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.tag = 100+self.houseDynamicModel.progress_imgs.count -1;
        imageView.userInteractionEnabled = YES;
        
        //        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        //        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //        imageView.clipsToBounds = YES;
        
        [self.headScrollView addSubview:imageView];
    }
    
    for (int i=0; i<self.houseDynamicModel.progress_imgs.count; i++) {
        NSString *url = self.houseDynamicModel.progress_imgs[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*(i+1), 0, SCREENWIDTH, self.headViewHeight.constant)];
        imageView.tag = 100+i;
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        
        
        //        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        //        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvClick:)];
        [imageView addGestureRecognizer:tap];
        [self.headScrollView addSubview:imageView];
        
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        [self.mwPhotoArray addObject:photo];
        
    }
    if (self.houseDynamicModel.progress_imgs.count > 0) {
        
        NSString *url = self.houseDynamicModel.progress_imgs[0];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.houseDynamicModel.progress_imgs.count + 1)*SCREENWIDTH , 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100;
        
        [self.headScrollView addSubview:imageView];
        
    }
    self.headScrollView.contentSize = CGSizeMake(SCREENWIDTH*(self.houseDynamicModel.progress_imgs.count+2), 0);
    self.headScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    self.pageControl.numberOfPages = self.houseDynamicModel.progress_imgs.count;
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
    
    NSInteger total = self.houseDynamicModel.progress_imgs.count;
    
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
    if (self.houseDynamicModel.progress_imgs.count>0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoSlide:) userInfo:nil repeats:YES];
    }
}

-(void)autoSlide:(id)sender
{
    
    NSUInteger total = self.houseDynamicModel.progress_imgs.count;
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

@end
