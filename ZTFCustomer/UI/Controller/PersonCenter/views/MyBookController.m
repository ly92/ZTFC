//
//  MyBookController.m
//  ztfCustomer
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MyBookController.h"
#import "MyBookRootController.h"
#import "SubscribeDetailViewController.h"

@interface MyBookController ()<ViewPagerDataSource,ViewPagerDelegate,MyBookRootControllerDelegate>
{
    NSArray *_titleArray;
}
@end

@implementation MyBookController
+(instancetype)spawn{
    return [MyBookController loadFromStoryBoard:@"PersonalCenter"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    
    _titleArray = @[@"预约商家",@"预约看房"];
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self reloadData];

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
-(void)setNavigationBar{
    self.navigationItem.title = @"我的预约";
    
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _titleArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = [NSString stringWithFormat:@"%@", _titleArray[index]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x333B46);
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //    MessageRootViewController *message = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageRootViewController"];
    MyBookRootController *message = [MyBookRootController spawn];
    [message setBookType:index];
    [message setDelegate:self];
    return message;
}

#pragma mark - ViewPagerDelegate
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return UIColorFromRGB(0x27A2F0);
            break;
        case ViewPagerContent:
            return UIColorFromRGB(0xf2f3f4);
            break;
        default:
            break;
    }
    
    return color;
}

#pragma mark-MyBookRootControllerDelegate

- (void)didSelectRowAtIndexPathTag:(NSInteger)tag ListData:(id)listData{
    
    
    SubscribeRecordModel *subscribe = (SubscribeRecordModel *)listData;
    
    SubscribeDetailViewController *detailViewController = [[SubscribeDetailViewController alloc] initWithSubscribe:subscribe];
    [self.navigationController pushViewController:detailViewController animated:YES];

    
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
