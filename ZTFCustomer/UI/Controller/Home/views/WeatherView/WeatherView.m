//
//  WeatherView.m
//  EstateBiz
//
//  Created by ly on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherAPI.h"
#define WEATHERKEY  @"BAIDUWEATHERKEY"
@interface WeatherView ()

@property(nonatomic,weak) IBOutlet UIImageView *bg;
@property(nonatomic,weak) IBOutlet UILabel *lblTemperature;
@property(nonatomic,weak) IBOutlet UILabel *lblWeather;
@property(nonatomic,weak) IBOutlet UILabel *lblWind;
@property(nonatomic,weak) IBOutlet UILabel *lblPM;
@property(nonatomic,weak) IBOutlet UILabel *lblCity;


@end

@implementation WeatherView

//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil] lastObject];
        self.frame = frame;
        //获取小区编号
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBidChange:) name:@"COMMUNITYCHANGE" object:nil];
        
//        //获取小区编号,这个方法里面已经进行了通知的remove操作，解决ios8系统下的崩溃问题
        [self fk_observeNotifcation:@"COMMUNITYCHANGE" usingBlock:^(NSNotification *note) {
            [self handleBidChange:note];
        }];
    }
    return self;
}

-(void)update
{
    
    NSUInteger hour =  [[NSDate date] hour];
    
    if (hour>=7&&hour<=8) {
        //早晨
        self.bg.image = [UIImage imageNamed:@"weather_1"];
    }
    else if (hour>=9&&hour<=16)
    {
        //白天
        self.bg.image = [UIImage imageNamed:@"weather_2"];
    }
    else if (hour>=17&&hour<=18)
    {
        //傍晚
        self.bg.image = [UIImage imageNamed:@"weather_3"];
    }
    else{
        //夜晚
        self.bg.image = [UIImage imageNamed:@"weather_4"];
    }
    
    
    NSDictionary *data =[STICache.global objectForKey:WEATHERKEY];
    
    //如果本地有缓存数据，则先调用本地数据填充
    if ([ISNull isNilOfSender:data]==NO) {
        
        self.lblTemperature.text=[data objectForKey:@"temperature"];
        self.lblWeather.text=[data objectForKey:@"weather"];
        self.lblWind.text=[data objectForKey:@"wind"];
        self.lblPM.text=[NSString stringWithFormat:@"PM2.5 %@",[data objectForKey:@"pm25"]];
        self.lblCity.text = [data objectForKey:@"currentCity"];
        
    }
    else{
        
        self.lblTemperature.text=@"20 ~ 31°C";
        self.lblWeather.text=@"晴";
        self.lblWind.text=@"东北风，风力2级";
        self.lblPM.text=@"PM2.5  60";
        self.lblCity.text = @"北京";
    }
}
//根据小区编号获取天气
-(void)handleBidChange:(NSNotification *)noti
{
    if (noti) {
        NSString *bid=noti.object;
        
        if (bid) {
            [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
            WeatherAPI *weatherApi = [[WeatherAPI alloc] initWithBid:bid];
            [weatherApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0){
                    //插入缓存
                    [STICache.global setObject:result[@"weather"] forKey:WEATHERKEY];
                    
                    NSDictionary *weather = [result objectForKey:@"weather"];
                    //更新slide
                    self.lblTemperature.text=[weather objectForKey:@"temperature"];
                    self.lblWeather.text=[weather objectForKey:@"weather"];
                    self.lblWind.text=[weather objectForKey:@"wind"];
                    self.lblPM.text=[NSString stringWithFormat:@"PM2.5 %@",[weather objectForKey:@"pm25"]];
                    self.lblCity.text = [weather objectForKey:@"currentCity"];
                    
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
    }
}

@end
