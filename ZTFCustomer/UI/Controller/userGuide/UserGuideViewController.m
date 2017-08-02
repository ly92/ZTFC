//
//  UserGuideViewController.m
//  colourlife
//
//  Created by liuyadi on 16/1/5.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * guideScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@end

@implementation UserGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollViewUI];
    [self createPageControl];
    [self setupButtonUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)setupScrollViewUI
{
    self.guideScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.guideScrollView.showsHorizontalScrollIndicator = NO;
    self.guideScrollView.showsVerticalScrollIndicator = NO;
    self.guideScrollView.contentSize = CGSizeMake(self.view.width * 3, self.view.height);
    
    self.guideScrollView.pagingEnabled = YES;
    self.guideScrollView.userInteractionEnabled = YES;
    self.guideScrollView.delegate = self;
    self.guideScrollView.bounces = NO;
    
    for ( int i = 0; i < 3; i++)
    {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.width, 0, self.view.width, self.view.height)];
        NSString * imageName = [NSString stringWithFormat:@"guide%d.jpg", i + 1];
//        if ( [SDiOSVersion deviceSize] == Screen3Dot5inch )
//        {
//            imageName = [NSString stringWithFormat:@"guide%d_1.jpg", i + 1];
//        }
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:imageName];
    
        [self.guideScrollView addSubview:imgView];
        
        
        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        skipBtn.frame = CGRectMake(self.view.width * i +SCREENWIDTH-65, 15, 50, 30);
        [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [skipBtn setTitleColor:UIColorFromRGB(0xDCDCDC) forState:UIControlStateNormal];
        skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        skipBtn.clipsToBounds = YES;
        skipBtn.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
        
        skipBtn.layer.borderWidth = 1;
        skipBtn.layer.cornerRadius = 10;
        
        [skipBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.guideScrollView addSubview:skipBtn];
        
    }
    
    [self.view addSubview:self.guideScrollView];
    
//    [self.guideScrollView autoFillSuperView];
}

- (void)createPageControl
{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.width / 2-25, self.view.height - 40, 50, 20)];
    self.pageControl.numberOfPages =3;
    self.pageControl.currentPage = 0;
//    self.pageControl.currentPageIndicatorTintColor = [AppTheme mainColor];
//    self.pageControl.pageIndicatorTintColor = [AppTheme titleColor];
//    [self.view addSubview:self.pageControl];
}

- (void)setupButtonUI
{
    
    
    
    
    
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(self.view.width * 2 , 0, self.view.width, self.view.height);
    
    if (kScreenWidth <=320) {
        
        btn.frame = CGRectMake(self.view.width * 2 +(self.view.width/2-100) , self.view.height-120, 200, 100);
    }else{
    
        btn.frame = CGRectMake(self.view.width * 2 +(self.view.width/2-100) , self.view.height-150, 200, 100);
    }
    
//    btn.backgroundColor = [UIColor redColor];
    
//    NSString *localversion = (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    localversion = [localversion handleVersionName];
//    [btn setTitle:[NSString stringWithFormat:@"开启东阿%@",localversion] forState:UIControlStateNormal];
//    btn.layer.borderColor = UIColorFromRGB(0x4cbaff).CGColor;
//    btn.layer.borderWidth = 1;
//    btn.layer.cornerRadius = 4;
//    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.guideScrollView addSubview:btn];
}

-(void)buttonClick:(UIButton *)button
{

    
    [[AppDelegate sharedAppDelegate]setupRootViewController];
    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:KMainStoryBoard bundle:nil];
//    UIViewController * vc = [story instantiateViewControllerWithIdentifier:@"navigationControlelr"];
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController = vc;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.pageControl.currentPage = scrollView.contentOffset.x / self.view.bounds.size.width;
    
}

@end

