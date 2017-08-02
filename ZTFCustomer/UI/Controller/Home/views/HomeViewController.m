//
//  HomeViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/4/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "WeatherCell.h"
#import "HomeServiceCell.h"
#import "PropertyConsultantCell.h"
#import "HomeActivityCell.h"
#import "MemberCardCell.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"
#import "WebViewController.h"
//#import "RealReachability.h"
#import "ComingSoonController.h"
#import "ScanActivity.h"
#import "SearchMemberCardController.h"
#import "MsgAdViewController.h"
#import "SearchCommunityController.h"
#import "PropertyConstrulantDetailController.h"
#import "ChangePropertyConstrulantController.h"
#import "HandlePush.h"
#import "ChatViewController.h"
#import "NoMemberCardCell.h"
#import "MessageViewController.h"
#import "CardMsgDetailViewController.h"
#import "StewardCell.h"
#import "PropertyMessageController.h"
#import "SearchCardCell.h"
#import "HomeMemberCardCell.h"
#import "HouseDetailController.h"

static NSString *weatherIdentifier = @"WeatherCell";
static NSString *serviceIdentifier = @"HomeServiceCell";
static NSString *propertyConcultantIdentifier = @"PropertyConsultantCell";
static NSString *stewardIdentifier = @"StewardCell";
static NSString *activityIdentifier = @"HomeActivityCell";
static NSString *memberCardIdentifier = @"HomeMemberCardCell";
static NSString *recommandCardIdentifier = @"MemberCardCell";
static NSString *noMemberCardIdentifier = @"NoMemberCardCell";

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeServiceCellDelegate,HomeActivityCellDelegate,UIAlertViewDelegate,PropertyConsultantCellDelegate,StewardCellDelegate,HomeMemberCardCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray * cellIdentifiers; // 用到的cellIdentifier

@property (nonatomic, strong) NSMutableArray *adArr;
@property (nonatomic, strong) NSMutableArray *functionArr;

@property (nonatomic, strong) LimitActivityModel *limitActivityModel;

@property (nonatomic, strong) NSMutableArray *memberCardArr;
@property (nonatomic, strong) NSMutableArray *recommandCardArr;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *arrowDownIV;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PropertyConstrulantModel *propertyConstrulantModel;
@property (nonatomic, strong) PropertyConstrulantModel *stewardModel;

@property (nonatomic, strong) UIImageView *messageImg;

@end

@implementation HomeViewController

+(instancetype)spawn{
    return [HomeViewController loadFromStoryBoard:@"Home"];
}

#pragma mark-生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.view.backgroundColor = VIEW_BG_COLOR;

    //导航栏
    [self setNavigationBar];
    [self registerNoti];
    
    self.cellIdentifiers = [NSMutableArray array];
    self.adArr = [NSMutableArray array];
    self.functionArr = [NSMutableArray array];
    self.memberCardArr = [NSMutableArray array];
    self.recommandCardArr = [NSMutableArray array];
    

    [@[weatherIdentifier, serviceIdentifier,propertyConcultantIdentifier,stewardIdentifier,activityIdentifier,memberCardIdentifier,recommandCardIdentifier,noMemberCardIdentifier] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tv registerNib:obj];
    }];
    
    [self setData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
//    self.navigationItem.title = @"首页";
    
    [self setNaviTitleView];
    
    self.navigationItem.leftBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"d1_search"] handler:^(id sender) {
        
        SearchMemberCardController *searchMember = [SearchMemberCardController spawn];
        
        [self.navigationController pushViewController:searchMember animated:YES];
        
    }];
    
    UIButton *scanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanbtn.frame = CGRectMake(0, 0, 30, 34);
    [scanbtn setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [scanbtn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc]initWithCustomView:scanbtn];
    
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(0, 0, 30, 30);
    [messageBtn setImage:[UIImage imageNamed:@"home_news"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:messageBtn];
    
    
    UIImageView *messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(22, 7, 6, 6)];
    messageImg.backgroundColor = UIColorFromRGB(0xFB4850);
    messageImg.clipsToBounds = YES;
    messageImg.layer.cornerRadius = 2;
    messageImg.hidden = YES;
    _messageImg = messageImg;
    [messageView addSubview:messageImg];
    
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc]initWithCustomView:messageView];
    
    self.navigationItem.rightBarButtonItems = @[messageItem,scanItem];
    
    
    
    
}

-(void)setNaviTitleView{
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREENWIDTH-120, 40)];
    
//    self.titleView.centerX = self.view.center.x;
    
    
    self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.titleView.frame)-20, 40)];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont systemFontOfSize:17];
    self.titleLbl.textColor = NAV_TEXTCOLOR;
    self.titleLbl.hidden = YES;
    [self.titleView addSubview:self.titleLbl];
    
    UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    if (community) {
        self.titleLbl.text = community.name;
    }
    
    CGFloat titleWidth = [self.titleLbl resizeWidth];
    [self.titleLbl setAdjustsFontSizeToFitWidth:YES];
    self.titleLbl.width = titleWidth;
    
    if (titleWidth > SCREENWIDTH-140) {
        self.titleLbl.width = SCREENWIDTH - 140;
    }
    
    if (titleWidth == 0) {
        self.arrowDownIV.hidden = YES;
    }else{
        self.arrowDownIV.hidden = NO;
    }
    
    self.titleView.width = self.titleLbl.width + 20;
    
    if (self.titleView.width > SCREENWIDTH-120) {
        self.titleView.width = SCREENWIDTH-120;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCommunity)];
    [self.titleView addGestureRecognizer:tap];
    
    self.arrowDownIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLbl.frame), 12, 15,15)];
    self.arrowDownIV.image = [UIImage imageNamed:@"home_nav_DownArrow"];
    [self.titleView addSubview:self.arrowDownIV];
    
   self.navigationItem.titleView = self.titleView;
    
    self.titleLbl.hidden = NO;
    
}

-(void)scanClick{
    ScanActivity *scan = [ScanActivity loadFromNib];
    
    scan.whenGetScan = ^(NSString *scanValue){
    };
    
    [self.navigationController pushViewController:scan animated:YES];
}
-(void)messageClick{
    MessageViewController *message = [MessageViewController spawn];
    [self.navigationController pushViewController:message animated:YES];
}

//选择小区
-(void)clickCommunity{
    SearchCommunityController *searchCommunity = [SearchCommunityController spawn];
    
    [self.navigationController pushViewController:searchCommunity animated:YES];
}

#pragma maek-register noti
-(void)registerNoti{
    
    //从后台进入
    [self fk_observeNotifcation:@"ENTERFOREGROUND" usingBlock:^(NSNotification *note) {
         [self setData];
    }];

    //登录成功
    [self fk_observeNotifcation:@"LOGINSUCCESS" usingBlock:^(NSNotification *note) {
        [self setData];
    }];
    //添加会员卡成功
    [self fk_observeNotifcation:@"ADDMEMBERCARDSUCCESS" usingBlock:^(NSNotification *note) {
        [self loadMyMemberCardData];
    }];
    
    //选择小区,切换小区成功
    [self fk_observeNotifcation:@"SELECTCOMMUNITY" usingBlock:^(NSNotification *note) {
        
        Community *community = (Community *)note.object;
        
        UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        
        [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        
//        [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
        
        [self loadCommunityData];
        
    }];
    
    //使用余额支付
    [self fk_observeNotifcation:@"RECHARGE_PAY_SUCCESS" usingBlock:^(NSNotification *note) {
        [self loadMyMemberCardData];
    }];
    
    //推送信息到达
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushMsg:) name:@"refreshHomeBadgle" object:nil];
    
    // 开门成功切换小区
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDoorChangeCommunity:) name:@"openDoorCommunity" object:nil];
    
    //删除会员卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyMemberCardData) name:@"deleteMember" object:nil];
    
    //商户为我充值,商户给我扣款
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMyMemberCardData) name:@"chargeMoney" object:nil];
    
    //积分充值,积分消费
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMyMemberCardData) name:@"pointsTransaction" object:nil];
    
    //绑定置业顾问成功
    [self fk_observeNotifcation:@"BingingSuccess" usingBlock:^(NSNotification *note) {
      
        [self openDoorChangeCommunity:note];
        
    }];
    //取消绑定置业顾问
    [self fk_observeNotifcation:@"CANCELBINDING" usingBlock:^(NSNotification *note) {
        [self loadPropertyConstulantData];

    }];
    
    //更新消息气泡
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageCenterBubble) name:@"SETMESSAGEREADSUCCESS" object:nil];
    
}
#pragma mark - 收到推送，处理推
//收到推送，处理推送
-(void)handlePushMsg:(id)sender
{
    //根据气泡数量重新排序会员卡,如果现在没有加载数据，则进行排序
    
    if (self.memberCardArr.count > 0) {
         [self sortCardByPushMsgCount];
    }
   
    //读取消息中心未读数量
    [self updateMessageCenterBubble];
    
    //获取所有优惠券气泡数
    [self fetchAllCouponPushBubble];
}
/*
 *  根据气泡数量重新排序会员卡
 */
-(void)sortCardByPushMsgCount
{
    if ([[LocalData shareInstance]isLogin]) {
        //重新排序
        if (self.tv) {
            
            //推送到来，数据根据气泡数重新排序
            if (self.memberCardArr&&self.memberCardArr.count>0) {
                
                for (MemberCardModel *card in self.memberCardArr) {
                    
                    int count1 = [LocalData getClickCountWithBid:card.bid];
                    
                    card.clickCount = [NSString stringWithFormat:@"%d",count1];
                    int count = [[LocalizePush shareLocalizePush] getHomeBadgle:card.cardid];
                    
                    card.pushcount = [NSString stringWithFormat:@"%d",count];
                    
                    
                    if ([card.pushcount intValue] != 0) {
                        
                    }
                }
                
                if (self.memberCardArr.count > 0) {
                    NSSortDescriptor *descriptor1=[NSSortDescriptor sortDescriptorWithKey:@"clickCount" ascending:NO];
                    NSSortDescriptor *descriptor2=[NSSortDescriptor sortDescriptorWithKey:@"pushcount" ascending:NO];
                    
                    NSArray *array=@[descriptor2,descriptor1];
                    
                    NSArray *sortArray=[NSArray arrayWithArray:array];
                    
                    [self.memberCardArr sortUsingDescriptors:sortArray];
                    
                }
                for (MemberCardModel *card in self.memberCardArr) {
                    NSLog(@"%@",card.cardname);
                }
                
                [self.tv reloadData];
                
            }
            
        }
    }
}

/**
 *  更新消息中心红点
 */
- (void)updateMessageCenterBubble
{
    if ([[LocalData shareInstance]isLogin]==NO) {
        return;
    }
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    GetMessageUnreadAPI *getMessageUnreadApi = [[GetMessageUnreadAPI alloc]init];
    
    [getMessageUnreadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            //            [self dismissTips];
            if (![ISNull isNilOfSender:[result objectForKey:@"unreadcount"]]) {
                
                int unreadcount = [[result objectForKey:@"unreadcount"] intValue];
                if (unreadcount > 0) {
                    self.messageImg.hidden = NO;
                }else{
                    self.messageImg.hidden = YES;
                }
            }
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

#pragma mark - 所有优惠券推送处理
//优惠券推送获取入口
- (void)fetchAllCouponPushBubble
{
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    
    if (amount != 0) {
        [[AppDelegate sharedAppDelegate] setBadgeValue:amount foeIndex:3];
    }else{
    
        [[AppDelegate sharedAppDelegate] setBadgeValue:0 foeIndex:3];
    }
    
}

#pragma mark - 开门切换小区
//开门切换小区
-(void)openDoorChangeCommunity:(NSNotification *)noti{
    NSString *communityid = (NSString *)noti.object;
    BOOL shouldChange=NO;
    if (communityid) {
        
        
        UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        Community *selectedCommunity = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        if (selectedCommunity) {
            
            if ([communityid isEqualToString:selectedCommunity.bid]==NO) {
                shouldChange=YES;
            }else{
                [self loadPropertyConstulantData];
            }
            

        }
        else{
            shouldChange=YES;
            
        }
        
        if (shouldChange) {
            
            [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
            
            SearchCommunityAPI *searchCommunityApi = [[SearchCommunityAPI alloc]initWithKeyword:communityid];
            [searchCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    
                    id remoteCommunity = [result objectForKey:@"community"];
                    if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *firstCommunity = (NSDictionary *)remoteCommunity;
                        
                        Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                        [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
//                        [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                        [self loadCommunityData];
                        
                    }
                    else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                        
                        NSArray *remotCommunity = (NSArray *)remoteCommunity;
                        
                        if ([remotCommunity count]>0) {
                            NSDictionary *firstCommunity = [remotCommunity objectAtIndex:0];
                            Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                             UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
//                            [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                            [self loadCommunityData];
                            
                            
                        }
                    }
                }
                
            } failure:^(__kindof YTKBaseRequest *request) {
                
                if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                    [[AppDelegate sharedAppDelegate]showLogin];
                }
                if (request.responseStatusCode == 0) {
                    [self presentFailureTips:@"网络不可用，请检查网络链接"];
                }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                }
            }];
            
        }
    }
}

#pragma mark - 加载数据

-(void)setData{
    
    if ([[LocalData shareInstance] isLogin]){
        
        //加载小区
        [self loadCommunityData];
        //功能栏数据
        [self loadFunction];
        
        //会员卡数据
        [self loadMyMemberCardData];
       
        [HandlePush fetchPushAmounts];
        
    }
}


#pragma mark - 加载小区数据
//加载小区数据
-(void)loadCommunityData{
    
     UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    //判断是否有缓存
    if ([STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]]) {
        
        //显示当前小区
        [self handelSelectedCommunity];
        //加载小区公告和广告
        [self loadNotice];
        [self loadPropertyConstulantData];
        
    }else{
        //没有缓存，加载授权小区
        [self loadMyOwnCommunityList];
    }
    
}

//加载已授权小区
- (void)loadMyOwnCommunityList{
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if (!user) {
        return;
    }
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    AuthoriseCommunityAPI *authoriseCommunityApi = [AuthoriseCommunityAPI alloc];
    
    [authoriseCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        
        AuthoriseCommunityResultModel *result = [AuthoriseCommunityResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            if (![ISNull isNilOfSender:result.list]) {
                Community *community = result.list[0];
                
                 UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
//                [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                //处理默认小区
                [self handelSelectedCommunity];
                
                [self loadPropertyConstulantData];
                
                [self loadNotice];
                
            }else{
                //加载附近小区
                [self loadNearCommunity];
            }
        }else{
            //加载附近小区
            [self loadNearCommunity];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        //加载附近小区
        [self loadNearCommunity];
        
    }];
}
//加载附近小区
-(void)loadNearCommunity{
    
    //获取当前位置
    Location *location = [AppLocation sharedInstance].location;
    NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
    NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    NearCommunityAPI *nearCommunityApi = [[NearCommunityAPI alloc]initWithLongitude:lon latitude:lat];
    
    [nearCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSDictionary *nearCommunity = result[@"community"];
            
            if (![ISNull isNilOfSender:nearCommunity]) {
                Community *community = [Community mj_objectWithKeyValues:nearCommunity];
                  UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
//                [self fk_postNotification:@"COMMUNITYCHANGE" object:community.bid];
                [self handelSelectedCommunity];
                
                [self loadNotice];
                [self loadPropertyConstulantData];
            }
            
        }else{
            
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
        }

    } failure:^(__kindof YTKBaseRequest *request) {
       
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

//处理默认选择的小区
-(void)handelSelectedCommunity
{
    
    UserModel *userModel = [[LocalData shareInstance]getUserAccount];
   Community *selectedCommunity = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    
    //存在已选择的，则判断
    if (selectedCommunity) {
        
        
        //切换小区通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMECHANGECOMMUNITY" object:nil];
        
//        [self setNaviTitleView];
        
        [self setNavigationBar];
    }
    
    
}

#pragma mark - 小区广告和活动广告
-(void)loadNotice{
   
     UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    if (community) {
        NSString *bid = community.bid;
        if (!bid) {
            return;
        }
        
        [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
        LoadNoticeAPI *loadNoticeApi = [[LoadNoticeAPI alloc]initWithOwnerId:bid];
        loadNoticeApi.noticeType = BannerType;
       
        [loadNoticeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"COMMUNITYCHANGE" object:bid];
            
            [self fk_postNotification:@"COMMUNITYCHANGE" object:bid];
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:content] && [result[@"result"] intValue] == 0) {
                
                 // 小区广告
                NSArray *adv = content[@"bannerList"];
                [self.adArr removeAllObjects];
                for (NSDictionary *dic in adv) {
                    [self.adArr addObject:[AdModel mj_objectWithKeyValues:dic]];
                }

                [self.tv reloadData];
                
            }else{
                if ([result[@"code"] intValue] == 9001 || [result[@"code"] intValue] == 9006 ||[result[@"code"] intValue] == 16||[result[@"code"] intValue] == 9004) {
                    [[AppDelegate sharedAppDelegate]showLogin];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"message"]];
                }else{
                    [self.adArr removeAllObjects];
                    [self.tv reloadData];
                    if ([result[@"code"] intValue] != 1023) {
                        [self presentFailureTips:result[@"message"]];
                    }
                }
                
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            
            [self.adArr removeAllObjects];
            [self.tv reloadData];

            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
        }];
        
        
        
        [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
        LoadNoticeAPI *activityApi = [[LoadNoticeAPI alloc]initWithOwnerId:bid];
        activityApi.noticeType = ActitvityType;
        
        [activityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"COMMUNITYCHANGE" object:bid];
            [self fk_postNotification:@"COMMUNITYCHANGE" object:bid];
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:content] && [result[@"result"] intValue] == 0) {
              
                //活动
                id dadv = content[@"activityInfo"];
                
                if ([ISNull isNilOfSender:dadv]) {
                    
                }else{
                    
                    if ([dadv isKindOfClass:[NSString class]]) {
                        NSString *adv = (NSString *)dadv;
                        if ([adv integerValue] == 0) {
                            
                        }
                    }else if([dadv isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *ndadv = (NSDictionary *)dadv;
                        self.limitActivityModel = [LimitActivityModel mj_objectWithKeyValues:ndadv];
//                        if (self.limitActivityModel) {
//                            [self.tv reloadData];
//                        }
                    }
                }
                [self.tv reloadData];
            }else{
                if ([result[@"code"] intValue] == 9001 || [result[@"code"] intValue] == 9006 ||[result[@"code"] intValue] == 16||[result[@"code"] intValue] == 9004) {
                    [[AppDelegate sharedAppDelegate]showLogin];
                     [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"message"]];
                }else{
                    self.limitActivityModel = nil;
                    [self.tv reloadData];
                    if ([result[@"code"] intValue] != 1023) {
                        [self presentFailureTips:result[@"message"]];
                    }

                }
               
            }
            
            
            
        } failure:^(__kindof YTKBaseRequest *request) {
            if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                [[AppDelegate sharedAppDelegate]showLogin];
            }
            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
            self.limitActivityModel = nil;
            [self.tv reloadData];
        }];
    }
    
   
}

#pragma mark - function
-(void)loadFunction{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    FunctionAPI *functionApi = [[FunctionAPI alloc]initWithLimit:@"4"];
    functionApi.functionType = HOME_FUNCTION;
    [functionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self.functionArr removeAllObjects];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.functionArr addObject:[FunctionModel mj_objectWithKeyValues:dic]];
            }
            [self.tv reloadData];
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16 ||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                  [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                  [self presentFailureTips:result[@"reason"]];
            }
            
            
        }

        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

#pragma mark - 获取置业顾问数据(
-(void)loadPropertyConstulantData{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
     UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    
    PropertyConstulantAPI *propertyConstulantApi = [[PropertyConstulantAPI alloc]initWithProjectId:@"" communityId:community.bid key:@"" skip:@"0" limit:@"10000"];
    propertyConstulantApi.propertyType = ISBINDPROPERTY;
    [propertyConstulantApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            
            NSArray *arr = content[@"employee"];
            if (arr.count > 0) {
                NSDictionary *dic = arr[0];
                self.propertyConstrulantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
                
            }else{
                
                self.propertyConstrulantModel = nil;
                
            }
            
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result[@"message"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
    
}

#pragma mark - 我的会员卡列表
-(void)loadMyMemberCardData{
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    MemberCardAPI *memberCardApi = [[MemberCardAPI alloc]init];
    memberCardApi.memberCardType = memberCardType;
    [memberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        MemberCardResultModel *result = [MemberCardResultModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            
            self.memberCardArr = [NSMutableArray arrayWithArray:result.CardList];
            if (self.memberCardArr.count > 0) {
                //按照点击顺序和推送数量排序
                [self.tv reloadData];
//                [self sortCardByPushMsgCount];
            }else{
                [self loadRecommangList];
            }
            
            
        }else{
            if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result.reason];
            }else{
                [self loadRecommangList];
                [self presentFailureTips:result.reason];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }else{
             [self loadRecommangList];
            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
        }
        
    }];
}
//获取推荐卡列表
-(void)loadRecommangList{
   
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    MemberCardAPI *memberCardApi = [[MemberCardAPI alloc]init];
    memberCardApi.memberCardType = recommandCardType;
    [memberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self.recommandCardArr removeAllObjects];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.recommandCardArr addObject:[NoMemberCardInfo mj_objectWithKeyValues:dic]];
            }
            [self.tv reloadData];
            
        }else{
            if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
            [[AppDelegate sharedAppDelegate]showLogin];
        }
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
    
}

#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self.cellIdentifiers removeAllObjects];
    
    //天气
    [self.cellIdentifiers addObject:weatherIdentifier];
    
    //功能栏
    if (self.functionArr.count > 0) {
        [self.cellIdentifiers addObject:serviceIdentifier];
    }
    //添加只有顾问无管家
    [self.cellIdentifiers addObject:propertyConcultantIdentifier];
    //添加有管家，顾问不确定的情况
//    [self.cellIdentifiers addObject:stewardIdentifier];
    //活动栏
    if (self.limitActivityModel) {
        [self.cellIdentifiers addObject:activityIdentifier];
    }
    
    if (self.memberCardArr.count > 0) {
        //添加会员卡
        [self.cellIdentifiers addObject:memberCardIdentifier];
    }else{
        //添加推荐卡
        [self.cellIdentifiers addObject:recommandCardIdentifier];
    }
    
    return self.cellIdentifiers.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString * identifier = self.cellIdentifiers[section];
    if ([identifier isEqualToString:memberCardIdentifier]) {
        //会员卡列表
        return self.memberCardArr.count;
//        return 1;
    }else if ([identifier isEqualToString:recommandCardIdentifier]){
        
        if (self.recommandCardArr.count >0){
            //推荐卡
            return self.recommandCardArr.count;
        }
        else{
            //无会员卡，无推荐卡
            return 1;
        }
    }
    else{
        //天气，功能栏，活动广告
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    
    UITableViewCell * cell = nil;
    
    if ([identifier isEqualToString:weatherIdentifier]) {
        //天气
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        WeatherCell *weatherCell = (WeatherCell *)cell;
        
        weatherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        weatherCell.msgDetail = ^(AdModel *adModel){
                
            CardMsgDetailViewController *msgAd = [CardMsgDetailViewController spawn];
            msgAd.isAd = YES;
            msgAd.adModel = adModel;
            [self.navigationController pushViewController:msgAd animated:YES];
         
        };
        weatherCell.msgUrlClick = ^(AdModel *messageModel){
            
            WebViewController *web = [WebViewController spawn];
            web.webURL = messageModel.url;
            web.webTitle = messageModel.title;
            
            [self.navigationController pushViewController:web animated:YES];
            
        };
        
        weatherCell.data = self.adArr;
        
        return weatherCell;
        
    }else if ([identifier isEqualToString:serviceIdentifier]){
        //功能栏
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        HomeServiceCell *serviceCell = (HomeServiceCell *)cell;
        serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        serviceCell.delegate = self;
        serviceCell.data = self.functionArr;
        
        return serviceCell;
    }else if ([identifier isEqualToString:stewardIdentifier]){
        //置业专员和管家
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        StewardCell *stewardCell =(StewardCell *)cell;
        stewardCell.selectionStyle = UITableViewCellSelectionStyleNone;
        stewardCell.delegate = self;
        stewardCell.data = self.propertyConstrulantModel;
        
//        propertyConsultantCell.delegate = self;
//        propertyConsultantCell.data = self.propertyConstrulantModel;
        
        return stewardCell;
        
    }
    else if ([identifier isEqualToString:propertyConcultantIdentifier]){
        //置业专员
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        PropertyConsultantCell *propertyConsultantCell =(PropertyConsultantCell *)cell;;
        propertyConsultantCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        propertyConsultantCell.delegate = self;
        
        propertyConsultantCell.data = self.propertyConstrulantModel;
        
        return propertyConsultantCell;
        
    }
    else if ([identifier isEqualToString:activityIdentifier]){
        //活动栏
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        HomeActivityCell *activityCell = (HomeActivityCell *)cell;
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        activityCell.delegate = self;
        LimitActivityModel * limitActivity = self.limitActivityModel;

        activityCell.data = limitActivity;
        
        return activityCell;
        
    }else if ([identifier isEqualToString:memberCardIdentifier]) {
        //会员卡
        if (self.memberCardArr.count > 0) {
            
//            cell = [tableView dequeueReusableCellWithIdentifier:memberCardIdentifier forIndexPath:indexPath];
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            HomeMemberCardCell *memberCardCell = (HomeMemberCardCell *)cell;
//            memberCardCell.delegate = self;
//            memberCardCell.data = self.memberCardArr;
//
//            return memberCardCell;
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:recommandCardIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MemberCardCell *memberCardCell = (MemberCardCell *)cell;
//            memberCardCell.cardBottom.constant = 5;
            if (self.memberCardArr.count > indexPath.row) {
                memberCardCell.data = self.memberCardArr[indexPath.row];
            }
            cell.contentView.x = 0;
            cell.contentView.w = SCREENWIDTH;
            return memberCardCell;
        }

    }else if ([identifier isEqualToString:recommandCardIdentifier]){
       
        
       if (self.recommandCardArr.count > 0){
            //推荐卡
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MemberCardCell *memberCardCell = (MemberCardCell *)cell;
//           memberCardCell.cardBottom.constant = 5;
            if (self.recommandCardArr.count > indexPath.row) {
                memberCardCell.recommandCard = self.recommandCardArr[indexPath.row];
            }
            
            return memberCardCell;
        }else{
            //无会员卡和推荐卡
            cell = [tableView dequeueReusableCellWithIdentifier:noMemberCardIdentifier forIndexPath:indexPath];
            NoMemberCardCell *noMemberCardCell = (NoMemberCardCell *)cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return noMemberCardCell;
            
        }
        
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString * identifier = self.cellIdentifiers[indexPath.section];
    
    if ([identifier isEqualToString:weatherIdentifier]){
        return SCREENWIDTH *140/375.0;
    }else if ([identifier isEqualToString:serviceIdentifier]){
        if (self.functionArr.count <= 4) {
            return ((SCREENWIDTH-16)/4.0);
        }else if(self.functionArr.count >= 5){
            return ((SCREENWIDTH-16)/4.0)*2;
        }
    }else if ([identifier isEqualToString:stewardIdentifier]){
        return 70;
    }
    else if ([identifier isEqualToString:propertyConcultantIdentifier]){
        return 100;
        
    }else if ([identifier isEqualToString:activityIdentifier]){
        
//        self.limitActivityModel.style_num = 5;
         LimitActivityModel * limitActivity = self.limitActivityModel;
        return [HomeActivityCell heightForHomeActivityWithDataCount:limitActivity.list.count cardStyle:limitActivity.style_num];
//        return [HomeActivityCell heightForHomeActivityWithDataCount:3 cardStyle:self.limitActivityModel.style_num];
    }
    else if ([identifier isEqualToString:memberCardIdentifier]) {
//        if (self.memberCardArr.count > 0) {
//            return self.memberCardArr.count *130;
//        }
        return 130;
        
    }else if ([identifier isEqualToString:recommandCardIdentifier]) {
        return 130;
    }
    return 0;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
     NSString * identifier = self.cellIdentifiers[section];
    
    if ([identifier isEqualToString:memberCardIdentifier]) {
        return 28;
    }
    if ([identifier isEqualToString:recommandCardIdentifier]) {
        return 28;
    }
    if ([identifier isEqualToString:serviceIdentifier]) {
        return 1;
    }
    if ([identifier isEqualToString:weatherIdentifier]) {
        return 0;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = self.cellIdentifiers[section];
    
    if([identifier isEqualToString:memberCardIdentifier]||[identifier isEqualToString:recommandCardIdentifier]){
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 28)];
        sectionView.clipsToBounds = YES;
        sectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UILabel *sectionTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, SCREENWIDTH-20, 20)];
        sectionTitleLbl.backgroundColor = [UIColor clearColor];
        sectionTitleLbl.textColor = HOMEMEMBERCARDCOLOR;
        sectionTitleLbl.font = [UIFont systemFontOfSize:14];
        if (self.memberCardArr.count > 0) {
            sectionTitleLbl.text = @"我的会员卡";
        }else{
            sectionTitleLbl.text = @"我的推荐卡";
        }

        [sectionView addSubview:sectionTitleLbl];
        return sectionView;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 5)];
        sectionView.clipsToBounds = YES;
        sectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        return sectionView;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    
    if([identifier isEqualToString:memberCardIdentifier]){
        if (self.memberCardArr.count > 0) {
            return YES;
        }
    }
    return NO;
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [UIAlertView bk_showAlertViewWithTitle:@"是否确认删除" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //删除会员卡
                [self presentLoadingTips:nil];
                [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                DeleteMemberCardAPI *deleteMemberCardApi = [[DeleteMemberCardAPI alloc]initWithCardID:memberCard.cardid];
                [deleteMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                    NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                    if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                        [self dismissTips];
                        
                         [self.memberCardArr removeObjectAtIndex:indexPath.row];
                        if (self.memberCardArr.count > 0) {
                            
                            [self.tv deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationRight];
                           
                        }
                        if (self.memberCardArr.count ==0) {
                            [self loadMyMemberCardData];
                        }
                        
                        
                    }else{
                        if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                            [[AppDelegate sharedAppDelegate]showLogin];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
                        }else{
                            [self presentFailureTips:result[@"reason"]];
                        }
                       
                    }
                    
                } failure:^(__kindof YTKBaseRequest *request) {
                  
                    if (request.responseStatusCode == 0) {
                        [self presentFailureTips:@"网络不可用，请检查网络链接"];
                    }else{
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }
                }];
            }
        }];
        
    }];
    
    
    
    UITableViewRowAction *editAction = nil;
    
    if ([memberCard.isfav intValue] == 0) {
        
        //添加
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
                    // 收藏会员卡
                    [self presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = collectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            memberCard.isfav = @"1";
                            
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.memberCardArr];
                            [arr replaceObjectAtIndex:indexPath.row withObject:memberCard];
                            self.memberCardArr = arr;
                           
                            [self.tv reloadData];
                            
                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                    
                    
                    
                }
            }];
            
        }];
    }
    else {
        //移除
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认取消收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    // 收藏会员卡
                    [self presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = cancnelCollectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            
                            memberCard.isfav = @"0";
                            [self.memberCardArr replaceObjectAtIndex:indexPath.row withObject:memberCard];
                            [self.tv reloadData];

                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                }
            }];
            
        }];
    }
    
    return @[deleteAction,editAction];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    if ([identifier isEqualToString:weatherIdentifier]) {
        //天气
        
    }else if ([identifier isEqualToString:serviceIdentifier]){
         //功能栏
        
    }else if ([identifier isEqualToString:propertyConcultantIdentifier]){
        
        if (self.propertyConstrulantModel) {
            
            PropertyMessageController *propertyMessageCon = [PropertyMessageController spawn];
            propertyMessageCon.propertyModel = self.propertyConstrulantModel;
            [self.navigationController pushViewController:propertyMessageCon animated:YES];
            
        }
        
    }else if ([identifier isEqualToString:activityIdentifier]){
        //活动
        
    }else if ([identifier isEqualToString:memberCardIdentifier]) {
        //会员卡列表

        if (self.memberCardArr.count > indexPath.row) {
            MemberCardModel *memberCardModel = self.memberCardArr[indexPath.row];
            [self goToCardDetail:memberCardModel];
            
        }
        
        
    }else if ([identifier isEqualToString:recommandCardIdentifier]){
        if (self.recommandCardArr.count > indexPath.row){
            //推荐列表
            NoMemberCardInfo *memberCard = self.recommandCardArr[indexPath.row];
            [self goToRecommandCardDetail:memberCard];
        }else {
            SearchMemberCardController *searchMember = [SearchMemberCardController spawn];
            
            [self.navigationController pushViewController:searchMember animated:YES];
        }
    }
   
    
}
//跳转会员卡详情
-(void)goToCardDetail:(MemberCardModel *)surrounding{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    if (surrounding) {
        
        int count=[LocalData getClickCountWithBid:surrounding.bid];
        count+=1;
        NSDictionary *homeCard = [NSDictionary dictionaryWithObjectsAndKeys:surrounding.bid,@"bid",[NSString stringWithFormat:@"%d",count],@"clickCount", nil];
        [LocalData updateHomeCard:homeCard];
        
        NSString *cardnum = surrounding.cardnum;
        NSString *cardtype = surrounding.cardtype;
        NSString *extra = surrounding.extra;
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([surrounding.cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[surrounding.extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }else if ([surrounding.cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            
                             UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
                            
                            NSString *urlstring = surrounding.extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:surrounding.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:surrounding.bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:community.bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = surrounding.cardname;
                                [self.navigationController pushViewController:web animated:YES];
                                
                              
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = surrounding.bid;
                memberCardDetail.cardId = surrounding.cardid;
                memberCardDetail.cardType = surrounding.cardtypes;
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                noMemberCardDetail.reloadData = ^{
                    [self.memberCardArr removeAllObjects];
                    [self loadMyMemberCardData];
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}
//跳转非会员卡详情
-(void)goToRecommandCardDetail:(NoMemberCardInfo *)surrounding{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    if (surrounding) {
        
        NSString *cardnum = surrounding.cardnum;
        NSString *cardtype = surrounding.cardtype;
        NSString *extra = surrounding.extra;
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([surrounding.cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[surrounding.extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                            }
                        }else if ([surrounding.cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            UserModel *user = [[LocalData shareInstance]getUserAccount];
                            UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
                            
                            NSString *urlstring = surrounding.extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:user.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:surrounding.bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:community.bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = surrounding.name;
                                [self.navigationController pushViewController:web animated:YES];
                                
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = surrounding.bid;
                memberCardDetail.cardId = surrounding.bizcard.cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                
                noMemberCardDetail.reloadData = ^(){
                    [self initloading];
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}
#pragma mark - HomeServiceCellDelegate
-(void)functionDidSelectCell:(id)data{
    FunctionModel *functionModel = (FunctionModel *)data;
    if (functionModel) {
        NSString *act = functionModel.actiontype;
        if ([act isEqualToString:@"1"]) {
            NSString *proto = functionModel.actionios;
            if (![ISNull isNilOfSender:proto]) {
                //跳转到原生界面
                @try {
                    
                    id myObj = [NSClassFromString(proto) spawn];
                    
                    if ([myObj isKindOfClass:[UIViewController class]]) {
                        
                    
                        UIViewController *con = (UIViewController *)myObj;
                        
                      
                        con.data = functionModel.name;
                        
                        [self.navigationController pushViewController:con animated:YES];
                        
                    }else{
                         [self presentFailureTips:@"该功能暂时未开放"];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }else{
                //跳转到未建设界面
                ComingSoonController *comingSoon = [ComingSoonController spawn];
                
                comingSoon.data = functionModel.name;
                
                [self.navigationController pushViewController:comingSoon animated:YES];
            }
        }else if ([act isEqualToString:@"0"]){
//            RealReachability *reachability = [RealReachability sharedInstance];
//            if ([reachability currentReachabilityStatus]){
                NSString *outerurl = functionModel.actionurl;
                 outerurl =  [WebViewController pingUrlWithUrl:outerurl pushCmd:nil];
                if ([outerurl trim].length>0) {
                    
                    WebViewController *web = [WebViewController spawn];
                    web.webURL = outerurl;
                    web.webTitle = functionModel.name;
                    [self.navigationController pushViewController:web animated:YES];
                    
                }
//            }
        }else if ([act isEqualToString:@"3"]){
            NSString *proto = functionModel.actionios;
            
            //跳转到特定卡详情
            if([proto isEqualToString:@"JumpBizInfo"]){
                
                id extra = functionModel.extra;
                
                if ([extra isKindOfClass:[NSString class]]) {
                    
                    NSString *extraString = (NSString *)extra;
                    NSDictionary *data =(NSDictionary *) [extraString mj_JSONObject];
                    
                    if (![ISNull isNilOfSender:data]) {
                        NSString *bid = [data objectForKey:@"bid"];
                        if (bid) {
                            [self JumpBizInfo:bid];
                        }
                    }
                    
                }
                else if ([extra isKindOfClass:[NSDictionary class]]){
                    NSDictionary *data = (NSDictionary *)extra;
                    
                    if (![ISNull isNilOfSender:data]) {
                        NSString *bid = [data objectForKey:@"bid"];
                        if (bid) {
                            [self JumpBizInfo:bid];
                        }
                    }
                    
                }
                
            }
            
        }
    }
}
//跳转到会员卡
-(void)JumpBizInfo:(NSString *)bid
{
    
    UserModel *user=[[LocalData shareInstance]getUserAccount];
    if (!user) {
        return;
    }
    
    NSString *cid = user.cid;
    
    if (cid&&bid) {
        
        [self presentLoadingTips:nil];
        
        [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
        GetMemberCardAPI *getMemberCardApi =[[GetMemberCardAPI alloc]initWithBid:bid];
        [getMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                NSDictionary *info = [result objectForKey:@"info"];
                
                [self functionGoToCardDetail:info];
                
                
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];
        
    }
    
}


-(void)functionGoToCardDetail:(NSDictionary *)info{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    
    
    if (![ISNull isNilOfSender:info]) {
        NSString *cardnum = [info objectForKey:@"cardnum"];
        
        NSString *bid = [info objectForKey:@"bid"];
        
        NSString *cardtype = [[info objectForKey:@"bizcard"] objectForKey:@"cardtype"];
        NSString *extra = [[info objectForKey:@"bizcard"] objectForKey:@"extra"];
        
        NSString *cardid = [[info objectForKey:@"bizcard"] objectForKey:@"cardid"];
        
        NSString *cardname = [[info objectForKey:@"bizcard"] objectForKey:@"cardname"];
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }else if ([cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            UserModel *user=[[LocalData shareInstance]getUserAccount];
                            NSString *urlstring = extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:user.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = cardname;
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = bid;
                memberCardDetail.cardId = cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = bid;
                noMemberCardDetail.reloadData = ^{
                    
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}
#pragma mark - HomeActivityCellDelegate
-(void)activityDidSelectCell:(id)data{
     AttrModel * attr = (AttrModel *)data;
    if (attr) {
        NSString *act = attr.type;
        if ([act isEqualToString:@"1"]) {
            NSString *proto = attr.ios_controller;
            if (![ISNull isNilOfSender:proto]) {
                //跳转到原生界面
                @try {
                    
                    id myObj = [NSClassFromString(proto) spawn];
                    
                    if ([myObj isKindOfClass:[UIViewController class]]) {
                    
                        UIViewController *con = (UIViewController *)myObj;
                    
                        NSDictionary *param =(NSDictionary *) [attr.param mj_JSONObject];
                        
                        if (![ISNull isNilOfSender:param]) {
                            con.data = [param objectForKey:@"project_id"];
                        }
                        
                        [self.navigationController pushViewController:con animated:YES];
                        
                    }else{
                        [self presentFailureTips:@"该功能暂时未开放"];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }else{
                //跳转到未建设界面
                ComingSoonController *comingSoon = [ComingSoonController spawn];
                
                comingSoon.data = attr.title;
                
                [self.navigationController pushViewController:comingSoon animated:YES];
            }
        }else if ([act isEqualToString:@"2"]){
           
            NSString *url = attr.url;
            url =  [WebViewController pingUrlWithUrl:url pushCmd:nil];
            if (url.length == 0) {
                
                ComingSoonController *comingSoon = [ComingSoonController spawn];
                [self.navigationController pushViewController:comingSoon animated:YES];
                
            }else{
                
                WebViewController *web = [WebViewController spawn];
                web.webURL = url;
                web.webTitle = attr.title;
                [self.navigationController pushViewController:web animated:YES];
                
            }
            
        }
    }
}

#pragma mark - PropertyConsultantCellDelegate

-(void)chatClick{
    
    if (![EMClient sharedClient].isLoggedIn){
        [[HuanxinService shareInstance] login];
    }
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.propertyConstrulantModel.easemob conversationType:EMConversationTypeChat FromOther:YES];
    chatController.title = self.propertyConstrulantModel.name;
    
    [self.navigationController pushViewController:chatController animated:YES];
    
}

-(void)bindingClick{
    ChangePropertyConstrulantController *change = [ChangePropertyConstrulantController spawn];
    [self.navigationController pushViewController:change animated:YES];
}

-(void)iconImgClick{
    if (self.propertyConstrulantModel) {
        //顾问详情
        PropertyConstrulantDetailController *propertyConsultantDetainCon = [PropertyConstrulantDetailController spawn];
        propertyConsultantDetainCon.propertyModel = self.propertyConstrulantModel;
        //取消绑定置业顾问成功
        propertyConsultantDetainCon.cancelBindingBlock = ^(){
            //获取置业顾问数据，刷新列表
            
            [self loadPropertyConstulantData];
            
        };
        [self.navigationController pushViewController:propertyConsultantDetainCon animated:YES];
    }
}

#pragma mark - stewardCelldelegate

-(void)clickWithTag:(NSInteger)tag{
    
    if (tag == 1) {
      //顾问消息列表
        PropertyMessageController *propertyMessageCon = [PropertyMessageController spawn];
         propertyMessageCon.propertyModel = self.propertyConstrulantModel;
        [self.navigationController pushViewController:propertyMessageCon animated:YES];
    }else if (tag == 2){
        if (self.propertyConstrulantModel) {
            //顾问详情
            PropertyConstrulantDetailController *propertyConsultantDetainCon = [PropertyConstrulantDetailController spawn];
            propertyConsultantDetainCon.propertyModel = self.propertyConstrulantModel;
            //取消绑定置业顾问成功
            propertyConsultantDetainCon.cancelBindingBlock = ^(){
                //获取置业顾问数据，刷新列表
                [self loadPropertyConstulantData];

            };
            [self.navigationController pushViewController:propertyConsultantDetainCon animated:YES];
        }
    }else if (tag == 3){
        //管家消息列表
        if (self.stewardModel) {
            PropertyMessageController *propertyMessageCon = [PropertyMessageController spawn];
            propertyMessageCon.isSteward = YES;
            propertyMessageCon.propertyModel = self.stewardModel;
            [self.navigationController pushViewController:propertyMessageCon animated:YES];
        }
    }else if (tag == 4){
        //管家详情
        if (self.stewardModel) {
            PropertyConstrulantDetailController *propertyConsultantDetainCon = [PropertyConstrulantDetailController spawn];
            propertyConsultantDetainCon.propertyModel = self.stewardModel;
            propertyConsultantDetainCon.isSteward = YES;
            [self.navigationController pushViewController:propertyConsultantDetainCon animated:YES];
        }
        
    }else if (tag == 5){
        //顾问聊天
        if (![EMClient sharedClient].isLoggedIn){
            [[HuanxinService shareInstance] login];
        }
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.propertyConstrulantModel.easemob conversationType:EMConversationTypeChat FromOther:YES];
        chatController.title = self.propertyConstrulantModel.name;
        
        [self.navigationController pushViewController:chatController animated:YES];
    }else if (tag == 6){
        //管家聊天
        
        if (![EMClient sharedClient].isLoggedIn){
            [[HuanxinService shareInstance] login];
        }
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.stewardModel.easemob conversationType:EMConversationTypeChat FromOther:YES];
        chatController.title = self.stewardModel.name;
        
        [self.navigationController pushViewController:chatController animated:YES];
    }else if (tag == 7){
        ChangePropertyConstrulantController *change = [ChangePropertyConstrulantController spawn];
        [self.navigationController pushViewController:change animated:YES];

    }

}

#pragma mark - homeMemberCardDelegate
//会员卡点击跳转详情
-(void)didselectMemberCardWithData:(id)data{
    if (data) {
        MemberCardModel *model = (MemberCardModel *)data;
        [self goToCardDetail:model];
    }
}

//删除会员卡
-(void)didDeleteMemberCardwithArr:(NSMutableArray *)arr{
    if (arr.count ==0) {
        [self loadMyMemberCardData];
    }else{
        self.memberCardArr = arr;
        [self.tv reloadData];
    }
}
//收藏会员卡
-(void)didCollectMemberCardWithArr:(NSMutableArray *)arr{
    if (arr) {
        self.memberCardArr = arr;
        [self.tv reloadData];
    }
}
@end
