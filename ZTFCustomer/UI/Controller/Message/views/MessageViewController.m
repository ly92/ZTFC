//
//  MessageViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/24.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageRootViewController.h"

#import "SystemMsgDetailViewController.h"
#import "CardMsgDetailViewController.h"
#import "ActivityMsgDetailViewController.h"
#import "VoteMsgDetailViewController.h"
#import "VoucherDetailViewController.h"
#import "FeedbackDetailViewController.h"
#import "SubscribeDetailViewController.h"

@interface MessageViewController ()<ViewPagerDataSource,ViewPagerDelegate,MessageRootViewControllerDelegate>
{
    NSArray *_titleArray;
}

@end

@implementation MessageViewController

+(instancetype)spawn{
    return [MessageViewController loadFromStoryBoard:@"Message"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    //设置导航栏
    [self setNavigationBar];
    
    
    _titleArray = @[@"商家信息",@"个人信息"];
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self reloadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    self.navigationItem.title = @"信息";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"全部已读" handler:^(id sender) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGESETRED" object:nil userInfo:nil];
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
    MessageRootViewController *message = [MessageRootViewController spawn];
    [message setMessageType:index];
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

#pragma mark-

- (void)didSelectRowAtIndexPathTag:(NSInteger)tag ListData:(id)listData {
    if (tag == 0) {
        //商家消息详情
        MessageModel *shopMsg = (MessageModel *)listData;
        
        if (shopMsg.subtype == nil) {
            return;
        }
        
        int subtype = [shopMsg.subtype intValue];
        
        //消息中心：消费，充值，积分均不可见
        
        switch (subtype) {
                //现金消费
            case 1:
            {
                //现金消费详情
                
                break;
            }
                //现金充值
            case 2:
            {
                //现金充值详情
                
                break;
            }
                //优惠券
            case 3:
            {
                //跳转优惠券详情
                
                break;
            }
                //优惠券到期
            case 4:
            {
                //跳转优惠券详情
                [self goToCouponDetails:shopMsg];
                
                break;
            }
                //系统公告
            case 5:
            {
                
                break;
            }
                //预约
            case 6:
            {
                //跳转预约详情
                [self goToBookDetail:shopMsg];
                
                break;
            }
                //反馈
            case 7:
            {
                //跳转反馈详情
                [self goToFeedbackDetail:shopMsg];
                
                break;
            }
                //消息
            case 8:
            {
                //卡消息详情
                [self goToCardMsgDetail:shopMsg];
                
                break;
            }
                //活动
            case 9:
            {
                //活动详情
                [self goToActivityDetail:shopMsg];
                
                break;
            }
                //投票
            case 10:
            {
                //投票详情
                [self goToVoteDetail:shopMsg];
                
                break;
            }
            case 11:
            {
                //积分充值
                
                break;
            }
            case 12:
            {
                //积分消费
                
                break;
            }
                
            default:
                break;
        }
        
       
    } else {
        //系统通知详情
        MessageModel *shopMsg = (MessageModel *)listData;
        
        if (shopMsg.subtype == nil) {
            return;
        }
        
        int subtype = [shopMsg.subtype intValue];
        
        switch (subtype) {
            case 6:
                [self goToBookDetail:shopMsg];
                break;
            case 7:
                [self goToFeedbackDetail:shopMsg];
                break;
                
            default:
                break;
        }
    }
    
}

//跳转优惠券详情
-(void)goToCouponDetails:(MessageModel *)message{
    if (message.relatedid == nil) {
        return;
    }
    
//    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    CouponOverdueAPI *couponOverdueApi = [[CouponOverdueAPI alloc]initWithSnid:message.relatedid];
    
    [couponOverdueApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
//            [self dismissTips];
            NSDictionary *info = [result objectForKey:@"info"];
            if ([ISNull isNilOfSender:info]) {
//                [self presentFailureTips:@"优惠券无效"];
                return ;
            }
            CouponModel *couponModel = [CouponModel mj_objectWithKeyValues:info];
            
            VoucherDetailViewController *voucherDetail = [[VoucherDetailViewController alloc]initWithVOUCHER:couponModel];
            
            [self.navigationController pushViewController:voucherDetail animated:YES];
            
        }else{
//            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
//        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

//跳转预约详情
-(void)goToBookDetail:(MessageModel *)message{
    
    SubscribeDetailViewController *appointmentDetailVc = [[SubscribeDetailViewController alloc]init];
    appointmentDetailVc.relatedId = message.relatedid;
    [self.navigationController pushViewController:appointmentDetailVc animated:YES];

//    SystemMsgDetailViewController *systemMsgDetailVC = [SystemMsgDetailViewController spawn];
//    systemMsgDetailVC.titleStr = @"预约详情";
//    [systemMsgDetailVC setSystemMsgModel:(MessageModel *)message];
//    [self.navigationController pushViewController:systemMsgDetailVC animated:YES];
    
    
    //消息中心跳转详情，本地气泡减1
    if (message.cardid) {
        
        
        [[LocalizePush shareLocalizePush] updateLoaclCardId:message.cardid Kind:BookConfirm];
        
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
}

//跳转反馈详情
-(void)goToFeedbackDetail:(MessageModel *)message{
    
    FeedbackDetailViewController *feedBackDetailVC = [[FeedbackDetailViewController alloc]init];
    feedBackDetailVC.relatedId = message.relatedid ;
    [self.navigationController pushViewController:feedBackDetailVC animated:YES];
//    SystemMsgDetailViewController *systemMsgDetailVC = [SystemMsgDetailViewController spawn];
//    systemMsgDetailVC.titleStr = @"反馈详情";
//    [systemMsgDetailVC setSystemMsgModel:(MessageModel *)message];
//    [self.navigationController pushViewController:systemMsgDetailVC animated:YES];
    
    
    
    //消息中心跳转详情，本地气泡减1
    if (message.cardid) {
        //        int count = [[LocalizePush shareLocalizePush] updataMessageCountCardId:message.cardid Kind:BookConfirm];
        //
        //        [[AppDelegate sharedAppDelegate]setBadgeValue:count foeIndex:1];
        [[LocalizePush shareLocalizePush] updateLoaclCardId:message.cardid Kind:FeedbackReturn];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
}

//卡消息详情
-(void)goToCardMsgDetail:(MessageModel *)message{
    
    CardMsgDetailViewController *cardMsg = [CardMsgDetailViewController spawn];
    
    cardMsg.relatedId = message.relatedid;
    
    [self.navigationController pushViewController:cardMsg animated:YES];
    //消息中心跳转详情，本地气泡减1
    if (message.cardid) {
        //        int count = [[LocalizePush shareLocalizePush] updataMessageCountCardId:message.cardid Kind:BookConfirm];
        //
        //        [[AppDelegate sharedAppDelegate]setBadgeValue:count foeIndex:1];
        [[LocalizePush shareLocalizePush] updateLoaclCardId:message.cardid Kind:CardMsg];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
}

//活动详情
-(void)goToActivityDetail:(MessageModel *)message{
    
    ActivityMsgDetailViewController *activity = [ActivityMsgDetailViewController spawn];
    activity.relatedId = message.relatedid;
    
    [self.navigationController pushViewController:activity animated:YES];
    
    //消息中心跳转详情，本地气泡减1
    if (message.cardid) {
        //        int count = [[LocalizePush shareLocalizePush] updataMessageCountCardId:message.cardid Kind:BookConfirm];
        //
        //        [[AppDelegate sharedAppDelegate]setBadgeValue:count foeIndex:1];
        [[LocalizePush shareLocalizePush] updateLoaclCardId:message.cardid Kind:Events];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    
}

//投票详情
-(void)goToVoteDetail:(MessageModel *)message{
    
    VoteMsgDetailViewController *vote = [VoteMsgDetailViewController spawn];
    
    vote.relatedId = message.relatedid;
    
    [self.navigationController pushViewController:vote animated:YES];
    
    //消息中心跳转详情，本地气泡减1
    if (message.cardid) {
        
        //        int count = [[LocalizePush shareLocalizePush] updataMessageCountCardId:message.cardid Kind:BookConfirm];
        
        //        [[AppDelegate sharedAppDelegate]setBadgeValue:count foeIndex:1];
        [[LocalizePush shareLocalizePush] updateLoaclCardId:message.cardid Kind:Votes];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    
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
