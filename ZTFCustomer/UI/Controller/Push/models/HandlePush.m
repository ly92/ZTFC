//
//  HandlePush.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HandlePush.h"


@implementation HandlePush

+(void)handelPushMessage:(NSDictionary *)userinfo
{
    if (userinfo) {
        
        NSDictionary *aps = [userinfo objectForKey:@"aps"];
        if (aps==nil) {
            return ;
            
        }
        
        NSString *msg = [aps objectForKey:@"alert"];
        
        if (msg==nil) {
            return ;
        }
        
        NSString *paramStr = [userinfo objectForKey:@"m"];
        if (paramStr) {
            NSArray *param = [paramStr componentsSeparatedByString:@"|"];
            //            NSLog(@"param.count = %d",(int)param.count);
            if (param&&param.count>0) {
                
                NSString *cmd = [param objectAtIndex:0];
                //                NSLog(@"param = %@",param);
                //                NSLog(@"cmd = %@",cmd);
                if (cmd) {
                    
                    NSString *cardId = @"";
                    if (param.count > 1) {
                        cardId = [param objectAtIndex:1];
                    }
                    
                    //为软卡会员的商户信息到达
                    if ([cmd isEqualToString:@"c1"]) {
                        
                        
                        //弹出提示信息
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        [self fetchPushAmounts:CardMsg CardID:cardId];
                        //[[LocalizePush shareLocalizePush] updateCardId:cardId Kind:CardMsg Amounts:@"1"];
                        
                    }
                    
                    //为硬卡会员的商户信息到达
                    /*
                     else if ([cmd isEqualToString:@"c2"])
                     {
                     [[AppPlusAppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushAdMessage" object:nil userInfo:nil];
                     
                     }
                     */
                    //商户为我充值
                    else if ([cmd isEqualToString:@"c3"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:ChargeMoney CardID:cardId];
                        
                    }
                    //商户给我扣款
                    else if ([cmd isEqualToString:@"c4"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DEDUCTMONEY" object:nil];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:DeductMoney CardID:cardId];
                        
                    }
                    //预约确认
                    else if ([cmd isEqualToString:@"c5"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        
                        [self fetchPushAmounts:BookConfirm CardID:cardId];
                        
                    }
                    //重复登录
                    else if ([cmd isEqualToString:@"c6"])
                    {
                        
                        [[LocalizePush shareLocalizePush] relogin];
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        
                    }
                    //反馈回复
                    else if ([cmd isEqualToString:@"c7"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:FeedbackReturn CardID:cardId];
                        
                        
                    }
                    //删除会员
                    else if ([cmd isEqualToString:@"c8"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //[[LocalizePush shareLocalizePush] deleteMember];
                        NSLog(@"cardId = %@",cardId);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMember" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    //积分充值
                    else if ([cmd isEqualToString:@"c9"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:ChargePoints CardID:cardId];
                        
                        
                    }
                    //积分消费
                    else if ([cmd isEqualToString:@"c10"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        
                        
                        
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:DeductPoints CardID:cardId];
                        
                        
                    }
                    //卡交易取消
                    else if ([cmd isEqualToString:@"c11"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:CancelMoney CardID:cardId];
                        
                        
                    }
                    //积分交易取消
                    else if ([cmd isEqualToString:@"c12"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:CancelPoints CardID:cardId];
                        
                        
                    }
                    
                    //接收优惠券
                    else if ([cmd isEqualToString:@"c13"]) {
                        
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:GetCoupon CardID:cardId];
                        
                    }
                    
                    //活动到达
                    else if ([cmd isEqualToString:@"c14"])
                    {
                        
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:Events CardID:cardId];
                        
                    }
                    
                    //投票到达
                    else if ([cmd isEqualToString:@"c15"])
                    {
                        
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:Votes CardID:cardId];
                        
                        
                    }
                    //订单
                    else if ([cmd isEqualToString:@"c16"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        //                        [self fetchPushAmounts];
                        [self fetchPushAmounts:GetOrder CardID:cardId];
                        
                    }
                    //在线支付
                    else if ([cmd isEqualToString:@"c17"])
                    {
                        
                        
                        
                    }
                    //小区公告
                    else if ([cmd isEqualToString:@"c18"])
                    {
                        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        NSString *bid = [param objectAtIndex:1];
                        [dic setObject:msg forKey:@"msg"];
                        [dic setObject:bid forKey:@"bid"];
                        
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Community_Notice" object:nil userInfo:dic];
                        
                        //                        [self fetchPushAmounts:CommunityNotice CardID:cardId];
                        
                        
                    }
                    //开门送优惠券
                    else if ([cmd isEqualToString:@"c19"])
                    {
                        
                        //优惠码id
                        NSString *snid = @"";
                        if (param.count > 2) {
                            snid = [param objectAtIndex:2];
                        }
                        
                        [[AppDelegate sharedAppDelegate] popOpenDoorCoupon:msg SnID:snid Cmd:cmd];
                        [self fetchPushAmounts:OpenCoupon CardID:cardId];
                        
                    }
                    //开门送钱
                    else if ([cmd isEqualToString:@"c20"])
                    {
                        //优惠码id
                        NSString *snid = @"";
                        if (param.count > 2) {
                            snid = [param objectAtIndex:2];
                        }
                        
                        [[AppDelegate sharedAppDelegate] popOpenDoorCoupon:msg SnID:snid Cmd:cmd];
                        [self fetchPushAmounts:OpenMoney CardID:cardId];
                        
                    }
                    
                    //w90 申请通知
                    else if ([cmd isEqualToString:@"w90"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        
                        
                    }
                    //w91 授权通知
                    else if ([cmd isEqualToString:@"w91"])
                    {
                        [[AppDelegate sharedAppDelegate] showNoticeMsg:msg WithInterval:2.5f];
                        
                        //刷新首页数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DOORAUTHORITY" object:nil];
                        
                        
                    }
                    
                    //第三方推送模块 c111
                    else if ([cmd isEqualToString:@"c111"]){
                        
                        NSString *pushid = @"";
                        NSString *subcmd = @"";
                        
                        if (param.count > 2) {
                            pushid = [param objectAtIndex:1];
                            subcmd = [param objectAtIndex:2];
                            if (subcmd.length==0) {
                                subcmd = @"home";
                            }
                        }
                        
                        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        [dic setObject:msg forKey:@"msg"];
                        [dic setObject:pushid forKey:@"id"];
                        [dic setObject:subcmd forKey:@"subcmd"];
                        
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"THIRDPARTYPUSH" object:nil userInfo:dic];
                    }
                    
                }
                
            }
            
        }
        
    }
}



//获取推送计数器
+(void)fetchPushAmounts
{
    
    FetchPushAmountsAPI *fetchPushAmountsApi = [[FetchPushAmountsAPI alloc]init];
     [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    [fetchPushAmountsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [[AppDelegate sharedAppDelegate].window.rootViewController dismissTips];
            
            NSDictionary *msgs = [result objectForKey:@"msgs"];
            
            if ([ISNull isNilOfSender:msgs]==NO) {
                
                NSMutableArray *pushArray = [NSMutableArray arrayWithCapacity:16];
                
                for (NSString *card in [msgs allKeys]) {
                    
                    NSLog(@"card key:%@",card);
                    
                    if ([ISNull isNilOfSender:card]) {
                        continue;
                    }
                    
                    //防止有非法数据
                    if ([card isEqualToString:@"duplicate"]) {
                        continue;
                    }
                    
                    NSDictionary *subDic = [msgs objectForKey:card];
                    
                    PushModel *item = [PushModel mj_objectWithKeyValues:subDic];
                    item.cardid = card;
                    
                    [pushArray addObject:item];
                    
                    NSLog(@"%@",item.c13);
                }
                
                NSData *data=[NSKeyedArchiver archivedDataWithRootObject:pushArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:PUSHDATA];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                for (PushModel *item in pushArray) {
//                    if (item.c1) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid forKey:@"cardId"]];
//                    }
//                    else if (item.c3){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c4){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c5){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmBook" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c5){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackReply" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    
//                    else if (item.c7){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackReply" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    
//                    else if (item.c9){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c10){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c11){
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c12)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c13)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCoupon" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c14)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    
//                    else if (item.c15)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c16)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetOrderDetail" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
//                    else if (item.c19)
//                    {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCoupon" object:nil userInfo:[NSDictionary dictionaryWithObject:item.cardid  forKey:@"cardId"]];
//                    }
                    
//                }
                
                
                //发送通知到首页，刷新界面
                
                //刷新首页气泡
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
                
                //刷新消息中心气泡
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgCenterBadgle" object:nil];
            }

            
        }else{
            
            [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
       
    }];
    
}

+(void)fetchPushAmounts:(NSString *)pushType CardID:(NSString *)cardId
{
    
    if (!pushType||!cardId||[cardId trim].length==0) {
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    FetchPushAmountsAPI *fetchPushAmountsApi = [[FetchPushAmountsAPI alloc]init];
    [fetchPushAmountsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [[AppDelegate sharedAppDelegate].window.rootViewController dismissTips];
            NSDictionary *msgs = [result objectForKey:@"msgs"];
            
            
            if ([ISNull isNilOfSender:msgs]==NO) {
                
                NSMutableArray *pushArray = [NSMutableArray arrayWithCapacity:16];
                
                for (NSString *card in [msgs allKeys]) {
                    
                    NSLog(@"card key:%@",card);
                    
                    if ([ISNull isNilOfSender:card]) {
                        continue;
                    }
                    
                    //防止有非法数据
                    if ([card isEqualToString:@"duplicate"]) {
                        continue;
                    }
                    
                    NSDictionary *subDic = [msgs objectForKey:card];
                    
                    //                    NSLog(@"sub:%@",subDic);
                    
                    PushModel *item = [PushModel mj_objectWithKeyValues:subDic];
                    item.cardid = card;
                    
                    [pushArray addObject:item];
                    
                }
                
                NSData *data=[NSKeyedArchiver archivedDataWithRootObject:pushArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:PUSHDATA];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                if (pushType&&cardId) {
                    
                    
                    if ([pushType isEqualToString:CardMsg]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:ChargeMoney]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:DeductMoney]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:BookConfirm]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmBook" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:BookConfirm]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackReply" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    
                    else if ([pushType isEqualToString:FeedbackReturn]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackReply" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    
                    else if ([pushType isEqualToString:ChargePoints]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:DeductPoints]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:CancelMoney]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:CancelPoints])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsTransaction" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:GetCoupon])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCoupon" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:Events])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    
                    else if ([pushType isEqualToString:Votes])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsgCardAd" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                        
                    }
                    else if ([pushType isEqualToString:GetOrder])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetOrderDetail" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    
                    else if ([pushType isEqualToString:OpenCoupon])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCoupon" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    else if ([pushType isEqualToString:OpenMoney])
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getMoney" object:nil userInfo:[NSDictionary dictionaryWithObject:cardId forKey:@"cardId"]];
                    }
                    
                    
                }
                
                
                //发送通知到首页，刷新界面
                
                //刷新首页气泡
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
                
                //刷新消息中心气泡
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgCenterBadgle" object:nil];
            }
            
            
        }else{
             [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
    
}
@end
