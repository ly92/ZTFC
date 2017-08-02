//
//  SurroundingViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/24.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SurroundingViewController.h"
#import "MenuTable.h"
#import "SurroundingCell.h"
#import "SearchSurroundingViewController.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"

@interface SurroundingViewController ()<MenuTableDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UIButton *communityButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *communityBtn;

@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *communityLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;

@property (weak, nonatomic) IBOutlet UIImageView *distanceArrow;
@property (weak, nonatomic) IBOutlet UIImageView *communityArrow;
@property (weak, nonatomic) IBOutlet UIImageView *categoryArrow;

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;


@property (nonatomic, strong) MenuTable *menuTable;

@property (nonatomic, strong) Community *community;
@property (nonatomic, retain) NSString *radius;
@property (nonatomic, retain) NSString *total;//总数
@property (nonatomic, retain) NSString *industryid;//分类
@property (nonatomic, retain) NSString *districtid;//区域号
@property (nonatomic, retain) NSString *bid;

@property (nonatomic, copy) NSString *lon;//经度
@property (nonatomic, copy) NSString *lat;//纬度

@property (nonatomic, assign) BOOL search;//当前数据是搜索数据还是默认周边数据

@property (nonatomic, strong) NSMutableArray *surroundingArray;

@property (nonatomic,assign) BOOL isHomeCommunityChange; //首页是否切换小区

@end

@implementation SurroundingViewController

+(instancetype)spawn{
    return [SurroundingViewController loadFromStoryBoard:@"Surrounding"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.btnWidth.constant = (SCREENWIDTH-2)/3.0;
    
    //设置导航栏
    [self setNavigationBar];
    
    [self registerNoti];
    
    [self setHeaderAndFooter];
    if (self.communityId) {
        //从楼盘详情跳转进入周边
        self.communityBtn.userInteractionEnabled = NO;
        [self loadSorroundingWithCommunity];
    
    }else{
        //tab进入周边
        //初始化信息
        self.communityBtn.userInteractionEnabled = YES;
        [self setInformation];
    }
    
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isHouseDetail) {
        
        HIDETABBAR;
     
    }
    else{
        
        SHOWTABBAR;
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        
        _menuTable.contentView.height = 0;
        
        
    } completion:^(BOOL finished) {
        
        _menuTable.hidden = YES;
        
        _menuTable.openContentView = NO;
        
        [self didHide];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"周边";
    
    //搜索
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"d1_search"] handler:^(id sender) {
        
        SearchSurroundingViewController *searchSurrounding = [SearchSurroundingViewController spawn];
        
        searchSurrounding.bid = self.bid;
        searchSurrounding.radius = self.radius;
        searchSurrounding.industryid = self.industryid;
        
        [self.navigationController pushViewController:searchSurrounding animated:YES];
        
    }];

    if (self.isHouseDetail) {
        self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}


#pragma mark-registerNoti
-(void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeChangeCommunity) name:@"HOMECHANGECOMMUNITY" object:nil];
}

-(void)homeChangeCommunity{
    
    self.isHomeCommunityChange = YES;
    [self reloadCommunity];
}

#pragma mark-reloadCommunity
-(void)reloadCommunity{
    //默认没有切换
    if (self.isHomeCommunityChange) {
         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        Community *homeCommunity =[STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        if (homeCommunity) {
            
            if (self.community) {
                NSString *bid = homeCommunity.bid;
                if (bid&&[bid isEqualToString:self.bid]==NO) {
                    self.community = homeCommunity;
                    [self loadSurroundingDefaultInfomation];
                    self.search = YES;
                    [self initloading];
                    self.isHomeCommunityChange=NO;
                    
                }
            }
            
        }
        else{
            self.isHomeCommunityChange=NO;
        }
    }
}

#pragma mark-information

-(void)loadSorroundingWithCommunity{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    
    SearchCommunityAPI *searchCommunityApi = [[SearchCommunityAPI alloc]initWithKeyword:self.communityId];
    [searchCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            id remoteCommunity = [result objectForKey:@"community"];
            if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *firstCommunity = (NSDictionary *)remoteCommunity;
                
                Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                self.community = community;
                
                self.radius = @"1000";
                self.bid=self.communityId;
                self.total=@"0";
                self.districtid=@"0";
                self.industryid = @"0";
                [self prepareLayout];
                self.search = YES;
                
                //加载周边的默认信息（距离，小区，类别)
                [self loadSurroundingDefaultInfomation];
                
                [self initloading];
                
            }
            else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                
                NSArray *remotCommunity = (NSArray *)remoteCommunity;
                
                if ([remotCommunity count]>0) {
                    NSDictionary *firstCommunity = [remotCommunity objectAtIndex:0];
                    Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                    self.community = community;
                    self.surroundingArray = [NSMutableArray array];
                    
                    self.search = YES;
                }else{
                    self.search = NO;
                }
                
                self.radius = @"1000";
                self.bid=self.communityId;
                self.total=@"0";
                self.districtid=@"0";
                self.industryid = @"0";
                [self prepareLayout];
                
                
                //加载周边的默认信息（距离，小区，类别)
                [self loadSurroundingDefaultInfomation];
                
                [self initloading];

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


-(void)setInformation{
    
    self.surroundingArray = [NSMutableArray array];
    
    self.radius = @"1000";
    self.bid=@"0;";
    self.total=@"0";
    self.districtid=@"0";
    self.industryid = @"0";
    [self prepareLayout];
    
     UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    if ([STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]]) {
        //如果首页有缓存小区，则显示该缓存小区
        self.community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        
        //加载周边的默认信息（距离，小区，类别)
        [self loadSurroundingDefaultInfomation];
        
        self.search = YES;
        [self initloading];


    }else{
        //根据经纬度加载小区和商户列表
        self.search = NO;
        [self initloading];
    }
    
}
//创建下拉菜单
-(void)prepareLayout{
    if (!self.menuTable) {
        self.menuTable = [[MenuTable alloc] initWithFrame:CGRectMake(0, 41,SCREENWIDTH, SCREENHEIGHT-40)];
        self.menuTable.delegate = self;
        [self.view addSubview:_menuTable];
    }
}

//加载周边的默认信息（距离，小区，类别)
- (void)loadSurroundingDefaultInfomation
{
    //半径
    NSString *distance = self.radius;
    if ([distance judgePositiveIntegerNumberOfDigits] == 3) {
        distance = [NSString stringWithFormat:@"%@m",distance];
    }
    else if ([distance judgePositiveIntegerNumberOfDigits] >= 4) {
        distance = [NSString stringWithFormat:@"%dkm",[distance intValue]/1000];
    }
    NSLog(@"distance : %@",distance);
    
    self.distanceLbl.text = distance;
    
    //小区名
    self.communityLbl.text = [NSString stringWithFormat:@"%@",self.community.name.length>0?self.community.name:@""];
//
//    //区域号
    self.districtid = [NSString stringWithFormat:@"%@",self.community.districtid];
//
//    //小区编号
    self.bid = [NSString stringWithFormat:@"%@",self.community.bid];

//
//    //小区省份
    NSString *provinceid = [NSString stringWithFormat:@"%@",self.community.provinceid];
//
//    //小区城市
    NSString *cityid = [NSString stringWithFormat:@"%@",self.community.cityid];
    
    //获得小区信息
  
    [self districtInfomation:provinceid cityid:cityid districtid:_districtid];
    
    
//    [self districtInfomation:provinceid cityid:cityid];
}

#pragma mark-加载数据

-(void)loadNewData{
    
    if (self.search) {
        [self.surroundingArray removeAllObjects];
        [self surroundingSearch];
    }else{
        [self.surroundingArray removeAllObjects];
        [self surroundingCommunity];
    }
}

-(void)loadMoreData{
    if (self.search) {
        [self surroundingSearch];
    }else{
        [self surroundingCommunity];
    }
}

/**
 *  按照搜索加载商户列表
 */
-(void)surroundingSearch{
    //搜索为YES
  
    if ([_radius trim].length == 0) {
        _radius = @"1000";
    }
    NSString *skip = [NSString stringWithFormat:@"%lu",(unsigned long)_surroundingArray.count];
    
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    SurroundingListAPI *surroundingListApi = [[SurroundingListAPI alloc]initWithBid:self.bid radius:self.radius limit:@"10" skip:skip industryid:self.industryid];
    
    [surroundingListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        [self dismissTips];
        SurroundingListResultModel *result = [SurroundingListResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            for (Shop *shop in result.shoplist) {
                [self.surroundingArray addObject:shop];
            }
            
            if (self.surroundingArray.count == 0) {
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }
            
            if (result.shoplist.count < 10) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }
            
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result.reason];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

/**
 *  按照经纬度加载附近小区和商户列表
 */
-(void)surroundingCommunity{
    
    [self getLocation];
    
    if (!_lat || [_lat doubleValue] == 0 || !_lon || [_lon doubleValue] == 0) {
        return;
    }
    
    NSString *skip = [NSString stringWithFormat:@"%ld",self.surroundingArray.count];
    
     [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    
    SurroundingCommunityAPI *surroundingCommunityApi = [[SurroundingCommunityAPI alloc]initWithLongitude:self.lon latitude:self.lat limit:@"20" skip:skip];
    
    [surroundingCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        [self dismissTips];
        SurroundingCommunityResultModel *result = [SurroundingCommunityResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            //获取小区
            self.community = result.community;
            
            self.radius = result.radius;
            
            for (Shop *shop in result.shoplist) {
                [self.surroundingArray addObject:shop];
            }
            
            if (self.surroundingArray.count == 0) {
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }
            if (result.shoplist.count < 10) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }

            [self loadSurroundingDefaultInfomation];
            
            
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result.reason];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];

}
#pragma mark-获取当前位置
//获取当前位置
-(void)getLocation{
    Location *location = [AppLocation sharedInstance].location;
    self.lon = [NSString stringWithFormat:@"%@",location.lon];
    self.lat = [NSString stringWithFormat:@"%@",location.lat];
}



#pragma mark -- 下拉框菜单
//根据省份城市获取小区信息
- (void)districtInfomation:(NSString *)provinceid cityid:(NSString *)cityid districtid:(NSString *)districtid
{
    if ([provinceid trim].length == 0 || [cityid trim].length == 0) {
        return;
    }
    
    if (_menuTable) {
        
        [_menuTable loadCommunityInfomationOfDistrict:provinceid cityid:cityid districtid:districtid];
    }
}

//选择半径
- (void)didSelectRadius:(NSDictionary *)radius
{
    //半径
    self.radius = [NSString stringWithFormat:@"%@",[radius objectForKey:@"radius"]];
    
    NSString *radiusStr = self.radius;
    if ([radiusStr judgePositiveIntegerNumberOfDigits] == 3) {
        radiusStr = [NSString stringWithFormat:@"%@m",radiusStr];
    }
    else if ([radiusStr judgePositiveIntegerNumberOfDigits] >= 4) {
        radiusStr = [NSString stringWithFormat:@"%dkm",[radiusStr intValue]/1000];
    }
    self.distanceLbl.text = [NSString stringWithFormat:@"%@",radiusStr];
    
    //关闭筛选菜单
    [self distanceButtonClick:nil];
    self.search = YES;
    [self initloading];
//    [self surroundingSearch];
}

-(void)didSelectArea:(NSString *)area{
    self.menuTable.districtid = self.districtid;
    [self.menuTable tableViewWithDistrictid:self.menuTable.districtid];
}

// 选择分类
- (void)didSelectCategory:(NSDictionary *)category
{
    self.categoryLbl.text = [NSString stringWithFormat:@"%@",[category objectForKey:@"name"]];
    self.industryid  = [NSString stringWithFormat:@"%@",[category objectForKey:@"id"]];
    
    //关闭筛选菜单
    [self categoryButtonClick:nil];
    
    self.search = YES;
    [self initloading];
//    [self surroundingSearch];
}

//选择区域和小区
- (void)didSelectCommunity:(Community *)community district:(NSString *)districtid
{
    
    self.districtid = [NSString stringWithFormat:@"%@",districtid];
    self.bid = [NSString stringWithFormat:@"%@",community.bid];
    self.communityLbl.text = [NSString stringWithFormat:@"%@",community.name];
    
    //更新小区信息
    self.community = community;
    self.lat = [NSString stringWithFormat:@"%@",community.latitude];
    self.lon = [NSString stringWithFormat:@"%@",community.longitude];
    
    [self getLocation];
    
    //关闭筛选菜单
    [self communityButtonClick:nil];

    self.search = YES;
    [self initloading];
//    [self surroundingSearch];
}

//菜单关闭
-(void)didHide
{
    self.distanceArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.communityArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.categoryArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.distanceButton.selected=NO;
    self.communityButton.selected = NO;
    self.categoryButton.selected = NO;
    
    
}

#pragma mark-click
//距离点击
- (IBAction)distanceButtonClick:(id)sender {
    
//    [self.surroundingArray removeAllObjects];
    
    if (!self.distanceButton.selected) {
        self.distanceArrow.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.communityArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.categoryArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.communityButton.selected = NO;
        self.categoryButton.selected = NO;
    }else{
        self.distanceArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    self.distanceButton.selected = !self.distanceButton.selected;
    
    if (_menuTable) {
        
        if ([self.radius isEqualToString:@"500"]) {
            self.menuTable.radiusid = @"0";
        }
        else if ([self.radius isEqualToString:@"1000"]) {
            self.menuTable.radiusid = @"1";
        }
        else if ([self.radius isEqualToString:@"2000"]) {
            self.menuTable.radiusid = @"2";
        }
        else if ([self.radius isEqualToString:@"5000"]) {
            self.menuTable.radiusid = @"3";
        }
        [self.menuTable tableViewWithOption:1 animation:self.distanceButton.selected];
    }
}
//小区点击
- (IBAction)communityButtonClick:(id)sender {
//    [self.surroundingArray removeAllObjects];
    if (!self.communityButton.selected) {
        self.communityArrow.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.distanceArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.categoryArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.distanceButton.selected = NO;
        self.categoryButton.selected = NO;
    }else{
        self.communityArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    self.communityButton.selected = !self.communityButton.selected;
    
    self.menuTable.districtid = self.districtid;
    self.menuTable.tempDistrictid = self.districtid;
    self.menuTable.bid = self.bid;
    
    [self.menuTable tableViewWithOption:2 animation:self.communityButton.selected];
    
}
//类别点击
- (IBAction)categoryButtonClick:(id)sender {
//    [self.surroundingArray removeAllObjects];
    if (!self.categoryButton.selected) {
        self.categoryArrow.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.communityArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.distanceArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.distanceButton.selected = NO;
        self.communityButton.selected = NO;
    }else{
        self.categoryArrow.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    self.categoryButton.selected = !self.categoryButton.selected;
    
    self.menuTable.categoryid = self.industryid;
    [self.menuTable tableViewWithOption:3 animation:self.categoryButton.selected];
}

#pragma mark-tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.surroundingArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SurroundingCell";
    SurroundingCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].firstObject;
    }
    
    if (self.surroundingArray.count > indexPath.row) {
//        
         Shop *shop = self.surroundingArray[indexPath.row];
        
        cell.data = shop;
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.surroundingArray.count > indexPath.row) {
        
        Shop *shop = self.surroundingArray[indexPath.row];
         [self goToCardDetail:shop];
    }
}
-(void)goToCardDetail:(Shop *)surrounding{
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
                memberCardDetail.cardId = surrounding.cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                noMemberCardDetail.reloadData = ^{
                    [self.surroundingArray removeAllObjects];
                    self.search = YES;
                    [self initloading];
                    
//                     [self surroundingSearch];
                };
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}



#pragma mark-tableview datasource


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
