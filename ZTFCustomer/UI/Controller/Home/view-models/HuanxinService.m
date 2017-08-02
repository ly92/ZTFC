//
//  HuanxinService.m
//  EstateBiz
//
//  Created by Ender on 4/25/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import "HuanxinService.h"

@interface HuanxinService ()

@property(nonatomic,strong) NSDate *lastPlaySoundDate;

@end

@implementation HuanxinService

+(HuanxinService *)shareInstance
{
    
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (id)initWithApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                   appkey:(NSString *)appkey
             apnsCertName:(NSString *)apnsCertName
{
    self = [super init];
    if (self) {
        [self configHuanxinApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appkey apnsCertName:apnsCertName];
    }
    return self;
}

-(void)dealloc{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)configHuanxinApplication:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                         appkey:(NSString *)appkey
                   apnsCertName:(NSString *)apnsCertName

{
    
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:appkey
                                       apnsCertName:apnsCertName
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    self.lastPlaySoundDate = [NSDate date];
    
    //更新未读信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount:) name:@"setupUnreadMessageCount" object:nil];
    
    
}

//绑定设备TOKEN
- (void)binDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}



//登录
-(void)login
{
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if(!user){
        return;
    }
    
    NSString *username = user.easemob_account;
    NSString *password=user.easemob_password;
    
//    NSString *username = @"15001102881.582DD5254304E8.53697";
//    NSString *password=@"Kakatool1234";
    
    
//    [EMClient sharedClient].options.isAutoLogin = YES;
    
//    测试
//    NSString *username = @"15079280867ppqe";
//    NSString *password=@"c1d1b55d1c73877d652df417ba486851";
    
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        if (!error)
        {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
//    }
    
}

//登出
-(void)logout
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
}

#pragma mark - notification
-(void)setupUnreadMessageCount:(NSNotification *)notification
{
//    [[AppDelegate sharedAppDelegate] setupUnreadMessageCount];
}

#pragma mark - private

//振动
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

//异步读取本地数据库
- (void)asyncConversationFromDB
{
    //    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
//                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:NO];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kHuanxinConversationChanged object:nil];
        });
    });
}

//发送本地推送
- (void)showNotificationWithMessage:(EMMessage *)message
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


#pragma mark - EMClientDelegate

//自动登录失败
- (void)didAutoLoginWithError:(EMError *)aError{
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if(!user){
        return;
    }
    NSString *username = user.loginname;
    NSString *password=user.paypsw;
    
    //测试
//    NSString *username = @"15079280867ppqe";
//    NSString *password=@"c1d1b55d1c73877d652df417ba486851";
    EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
    if (!error) {
        [self asyncConversationFromDB];
    }
}

//其他设备登录
//- (void)didLoginFromOtherDevice
//{
//
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//    
//    //重新登录
//    [self didAutoLoginWithError:nil];
//}

//服务器移除用户
- (void)didRemovedFromServer
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
   [[NSNotificationCenter defaultCenter] postNotificationName:kHuanxinConversationChanged object:nil];
}


- (void)didReceiveMessages:(NSArray *)aMessages
{
    for(EMMessage *message in aMessages){
        if (message.chatType == EMChatTypeChat) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHuanxinConversationChanged object:nil];
#if !TARGET_IPHONE_SIMULATOR
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            switch (state) {
                case UIApplicationStateActive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
//                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
    }
}

@end
