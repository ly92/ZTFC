//
//  WeatherCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "WeatherCell.h"
#import "WeatherView.h"
//#import "HomeModel.h"


@interface WeatherCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIPageControl *svPageControl;
@property(strong,nonatomic) WeatherView *weatherView; //天气
@property (nonatomic, strong) WeatherView *secondWeatherView;
@property(strong,nonatomic) NSTimer *slideTimer;

@property (strong, nonatomic) NSMutableArray *adArray;//

@end

@implementation WeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sv.pagingEnabled = YES;
    
}

- (NSMutableArray *)adArray{
    if (!_adArray){
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    
    [self.sv removeAllSubviews];
    
   
    if ( [self.data isKindOfClass:[NSArray class]] )
    {
        NSArray *arr = (NSArray *)self.data;
        
        [self.adArray removeAllObjects];
        [self.adArray addObjectsFromArray:arr];
        
        if (arr.count > 0) {
            //清空所有视图

            self.svPageControl.numberOfPages = arr.count + 1;
            
            AdModel *adModel = [arr objectAtIndex:arr.count-1];
            
            NSString *imageUrl = adModel.image;
            int noticeType = [adModel.type intValue];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _sv.height)];
            imageView.tag = arr.count-1;
            
            [imageView addTapAction:@selector(slideClicked:) forTarget:self];
            
            if ([imageUrl trim].length==0) {
                
                if (noticeType==3) {
                    imageView.image=[UIImage imageNamed:@"home_notice_3.png"];
                }
                else
                {
                    imageView.image=[UIImage imageNamed:@"home_notice_1.png"];
                }
                
            }
            else{
                imageView.imageURL = [NSURL URLWithString:imageUrl];
            }
            [self.sv addSubview:imageView];
            
            
            //添加天气
//            if (!_weatherView) {
                _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, self.sv.height)];
//            }
            [_weatherView update];
            //    self.svPageControl.numberOfPages = 1;
            [self.sv addSubview:self.weatherView];
            
            
            //添加其他动态视图
            for (int i = 0; i < arr.count +1; i++) {
                
                if (i == arr.count) {
                    //添加天气
//                    if (!_secondWeatherView) {
                        _secondWeatherView = [[WeatherView alloc] initWithFrame:CGRectMake(SCREENWIDTH*(i+2), 0, SCREENWIDTH, _sv.height)];
//                    }
                    [_secondWeatherView update];
                    [self.sv addSubview:self.secondWeatherView];
                }else{
                
                AdModel *adModel = [arr objectAtIndex:i];
                
                
                NSString *imageUrl = adModel.image;
                int noticeType = [adModel.type intValue];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH*(i+2), 0, SCREENWIDTH, _sv.height)];
                imageView.tag = i;
                
                [imageView addTapAction:@selector(slideClicked:) forTarget:self];
                
                if ([imageUrl trim].length==0) {
                    
                    if (noticeType==3) {
                        imageView.image=[UIImage imageNamed:@"home_notice_3.png"];
                    }
                    else
                    {
                        imageView.image=[UIImage imageNamed:@"home_notice_1.png"];
                    }
                    
                }
                else{
                    imageView.imageURL = [NSURL URLWithString:imageUrl];
                }
                
                
                //                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _sv.height - 21, SCREENWIDTH-10, 21)];
                //
                //                titleLbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                //
                //                titleLbl.textColor = [UIColor whiteColor];
                //                titleLbl.font = [UIFont systemFontOfSize:14.0f];
                //                titleLbl.text = adModel.title;
                //                [imageView addSubview:titleLbl];
                
                [self.sv addSubview:imageView];
                }
            }
            
            self.sv.contentSize = CGSizeMake(SCREENWIDTH * (arr.count +3), 0);
            self.sv.contentOffset = CGPointMake(SCREENWIDTH, 0);
            self.svPageControl.currentPage = 0;
            //开始定时
            if (self.slideTimer&&[self.slideTimer isValid]) {
                [self.slideTimer invalidate];
            }
            if (arr.count>0) {
                self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoSlide:) userInfo:nil repeats:YES];
            }
            
        }else{
            
            //添加天气
//            if (!_weatherView) {
                _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.sv.height)];
//            }
            [_weatherView update];
            [self.sv addSubview:self.weatherView];
            
            self.svPageControl.numberOfPages = 1;
            self.sv.contentSize = CGSizeMake(0, 0);
            //开始定时
            if (self.slideTimer&&[self.slideTimer isValid]) {
                [self.slideTimer invalidate];
            }
        }
        
        
       
    }else{
        //添加天气
//        if (!_weatherView) {
            _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.sv.height)];
//        }
        [_weatherView update];
        [self.sv addSubview:self.weatherView];
        
        self.svPageControl.numberOfPages = 1;
        
        self.svPageControl.numberOfPages = 1;
        self.sv.contentSize = CGSizeMake(0, 0);
        //开始定时
        if (self.slideTimer&&[self.slideTimer isValid]) {
            [self.slideTimer invalidate];
        }
    }

}


- (void)slideClicked:(id)sender{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    
    UIImageView *imageView=(UIImageView *)recognizer.view;
    
    if (imageView) {
        NSUInteger index = imageView.tag;
        
        if (self.adArray.count > index) {
           
            AdModel *adModel =[self.adArray objectAtIndex:index];
            //NSLog(@"dic : %@",dic);
            
            if (adModel) {
                
                int noticeType = [adModel.type intValue];
                
                if (noticeType == 2) {
                    //网页
                    self.msgUrlClick(adModel);
                }else{
                    //原生
                    self.msgDetail(adModel);
                }
                
//                if (noticeType!=3) {
//                    NSLog(@"slideClicked");
//                    
//                    NSString *outerurl = adModel.url;
//                    if ([outerurl trim].length > 0) {
//                        
//                        self.msgUrlClick(adModel);
//
//                    }
//                    else {
//                        
//                        self.msgDetail(adModel);
//                    }
//                }
            }
        }
    }
}

-(void)autoSlide:(id)sender
{
    
    NSUInteger total = self.adArray.count + 1;
    NSInteger page = floor((self.sv.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
    page ++;
      NSInteger screenpage = page;
    
    
    if (page > total){
        page = 1;
    }
    
    [self.sv setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.sv.contentOffset = CGPointMake((page-1) *SCREENWIDTH, 0);
    self.svPageControl.currentPage = page - 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != self.sv) {
        return;
    }
    
    //开始拖动scrollview的时候 停止计时器控制的跳转
    if (self.slideTimer&&[self.slideTimer isValid]) {
        [self.slideTimer invalidate];
    }
    self.slideTimer=nil;
}

//slide滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger total = self.adArray.count + 1;
    
    NSInteger page = floor((scrollView.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
    
    NSInteger offset = scrollView.contentOffset.x;
    
    NSInteger offpage = offset/SCREENWIDTH;
    
    if ( offpage < 1) {
        page = total;
    }
    if (offpage > total) {
        page = 1 ;
    }

    
//    [self.sv setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.sv.contentOffset = CGPointMake(page *SCREENWIDTH, 0);
    
    self.svPageControl.currentPage = page-1 ;
    
    if (self.slideTimer&&[self.slideTimer isValid]) {
        [self.slideTimer invalidate];
    }
    
    if (self.adArray.count>0) {
        self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoSlide:) userInfo:nil repeats:YES];
    }
    
}


@end
