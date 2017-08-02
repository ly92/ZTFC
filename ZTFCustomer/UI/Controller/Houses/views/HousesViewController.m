//
//  HousesViewController.m
//  ztfCustomer
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HousesViewController.h"
#import "HousesCell.h"
//#import "HouseMenuTable.h"
#import "HouseDetailController.h"
#import "SelectCityController.h"
#import "WSSMenuTable.h"
#import "MenuTableCell.h"

static NSString *houseIdentifier = @"HousesCell";
//HouseMenuTableDelegate
@interface HousesViewController ()<HousesCellDelegate,WSSMenuTableDelegate,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewWidth;

@property (weak, nonatomic) IBOutlet UIButton *regionButton;
@property (weak, nonatomic) IBOutlet UILabel *regionlbl;
@property (weak, nonatomic) IBOutlet UIImageView *regionimageView;

@property (weak, nonatomic) IBOutlet UIImageView *priceImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;

@property (weak, nonatomic) IBOutlet UIImageView *houseStyleImgView;
@property (weak, nonatomic) IBOutlet UILabel *houseStyleLbl;
@property (weak, nonatomic) IBOutlet UIButton *houseStyleButton;

@property (weak, nonatomic) IBOutlet UIImageView *areaImgView;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;

@property (nonatomic, strong) UILabel *selectCityLbl;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *arrowDownIV;
@property (nonatomic, strong) UIButton *arrowBtn;


@property (nonatomic, strong) NSMutableArray *houseArray;
//@property (nonatomic, strong) HouseMenuTable *menuTable;
@property (nonatomic, strong) WSSMenuTable *houseMenuTable;



@property (nonatomic, strong) NSMutableArray *regionArray;
@property (nonatomic, strong) NSMutableArray *priceArr;
@property (nonatomic, strong) NSMutableArray *houseTypeArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *selectHouseArr;

@property (nonatomic, strong) UITextField *searchTxt;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *priceId;
@property (nonatomic, copy) NSString *houseTypeId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *searchWord;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *skip;

@end

@implementation HousesViewController

+(instancetype)spawn{
    return [HousesViewController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
   
    self.provinceId = @"";
    self.cityId = @"";
    self.districtId = @"";
    self.priceId = @"";
    self.houseTypeId = @"";
    self.areaId = @"";
    self.searchWord = @"";
    self.limit = @"10";
    self.skip = @"0";
    
    [self setNavigationBar];
    [self registerNoti];
    
    [self setHeaderAndFooter];
    
    if ([ISNull isNilOfSender:[STICache.global objectForKey:@"PROJECTOPTION"]]) {
          [self loadProjectOption];
    }else{
        NSArray *arr = [STICache.global objectForKey:@"PROJECTOPTION"];
        self.priceArr = arr[0];
        self.houseTypeArr = arr[1];
        self.areaArr = arr[2];
    }

    self.houseMenuTable = [WSSMenuTable show:CGPointMake(0, 104) andHeight:1];
    self.houseMenuTable.delegate = self;
    self.houseMenuTable.titleMenuArray = @[@"区域",@"价格",@"户型",@"面积"];
    [self.view addSubview:self.houseMenuTable];
    
    [self loadLocationData];
   
    [self hideKeyBoard]; 

    self.selectViewWidth.constant = (SCREENWIDTH-3)/4.0;
    
    [self.tv registerNib:@"HousesCell" identifier:houseIdentifier];

//    [self initloading];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.houseMenuTable hideMenuTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadLocationData{
    if ( ![AppLocation canLocate] )
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否开启定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    
    RegionModel *selectVity = [STICache.global objectForKey:[NSString stringWithFormat:@"crcclocation_selectcity_%@",user.mobile]];
    
    if ( selectVity.id )
    {
        self.selectCityLbl.text =[AppLocation sharedInstance].selectCity.name;
        self.cityId = [AppLocation sharedInstance].selectCity.id;
        if ([AppLocation sharedInstance].selectCity.id.length == 0) {
            self.cityId = @"";
        }
        [self.regionArray addObjectsFromArray:[AppLocation sharedInstance].selectCity.districts];
        [self initloading];
    }
    else
    {
        [self presentLoadingTips:nil];
        [[AppLocation sharedInstance] locateThen:^(RegionModel *city) {
            [self dismissTips];
            [AppLocation sharedInstance].selectCity = city;
            if ( city.id )
            {
                [self.regionArray removeAllObjects];
                self.selectCityLbl.text =city.name;
                self.cityId = city.id;
                if (city.id.length == 0) {
                    self.cityId = @"";
                }
                [self.regionArray addObjectsFromArray:city.districts];
                
                [self initloading];
                
            }else if(city == nil){
               
                [self presentFailureTips:@"定位失败"];
                self.selectCityLbl.text = @"定位失败";
                [self initloading];
            }else{
                
                 [self loadNearestCityWithLng:city.lng lat:city.lat radius:@""];
               
            }
        }];
    }
}

#pragma mark - hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.searchTxt resignFirstResponder];
}

#pragma mark - navibar
-(void)setNavigationBar{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27,SCREENWIDTH-140 , 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =CGRectMake(view.w-25, 4, 20, 20)
    ;
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"house_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,view.w-45 , 30)];
    
    self.searchTxt.placeholder = @"请输入楼盘名称";
    //187 194 199
    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTxt setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.searchTxt.borderStyle =UITextBorderStyleNone;
    self.searchTxt.backgroundColor = [UIColor whiteColor];
    self.searchTxt.delegate = self;
    self.searchTxt.textColor = NAV_SEARCHTEXTCOLOR ;
    
    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    
    [view addSubview:self.searchTxt];
    
    self.navigationItem.titleView = view;
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    leftLbl.text = @"定位";
    leftLbl.font = [UIFont systemFontOfSize:14];
    leftLbl.textColor = [UIColor whiteColor];
    [leftView addSubview:leftLbl];
    self.selectCityLbl = leftLbl;
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(leftView.w-10, 17, 8, 5)];
    leftImg.image = [UIImage imageNamed:@"house_white_triangle"];
    [leftView addSubview:leftImg];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60, 60);
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];

    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftBtn];
    

    //左item
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右item
//    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"house_map"] handler:^(id sender) {
//        
//    }];
}

//选择城市点击
-(void)leftClick{
    SelectCityController *selectCityCon = [SelectCityController spawn];
    selectCityCon.whenUpdated = ^(RegionModel * region){
        
        
        self.cityId = region.id;
        if (region.id.length == 0) {
            self.cityId = @"";
        }
        self.selectCityLbl.text = region.name;
        self.regionlbl.text = @"区域";
        self.districtId = @"";
        [self.regionArray removeAllObjects];
        
        [self.regionArray addObjectsFromArray:region.districts];
        
        [self initloading];
    };
    [self.navigationController pushViewController:selectCityCon animated:YES];
}

#pragma mark - 懒加载

-(NSMutableArray *)regionArray{
    if (!_regionArray) {
        _regionArray = [NSMutableArray array];
    }
    return _regionArray;
}

-(NSMutableArray *)houseArray{
    if (!_houseArray) {
        _houseArray = [NSMutableArray array];
    }
    return _houseArray;
}

-(NSMutableArray *)priceArr{
    if (!_priceArr) {
        _priceArr = [NSMutableArray array];
    }
    return _priceArr;
}

-(NSMutableArray *)houseTypeArr{
    if (!_houseTypeArr) {
        _houseTypeArr = [NSMutableArray array];
    }
    return _houseTypeArr;
}

-(NSMutableArray *)areaArr{
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
}

-(NSMutableArray *)selectHouseArr{
    if (!_selectHouseArr) {
        _selectHouseArr = [NSMutableArray array];
    }
    return _selectHouseArr;
}

//- (HouseMenuTable *)menuTable{
//    if (!_menuTable){
//        _menuTable = [[HouseMenuTable alloc] init];
//        _menuTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//        _menuTable.delegateMenuTable = self;
//        [self.view addSubview:_menuTable];
//        
//    }
//    return _menuTable;
//}

#pragma mark - registerNoti
-(void)registerNoti{
    [self fk_observeNotifcation:@"OPERATECOLLECTSUCCESS" usingBlock:^(NSNotification *note) {
        
        NSArray *arr = (NSArray *)note.object;
        NSIndexPath *indexPath = arr[0];
        HousesModel *housesModel = arr[1];
        [self.houseArray removeObjectAtIndex:indexPath.row];
        [self.houseArray insertObject:housesModel atIndex:indexPath.row];
        [self.tv reloadData];
        
    }];
    
    //登录成功
    [self fk_observeNotifcation:@"LOGINSUCCESS" usingBlock:^(NSNotification *note) {
        [self loadLocationData];
    }];
    
    //首页活动栏跳转进入楼盘详情，收藏操作成功之后
    [self fk_observeNotifcation:@"HOMECOLLECTSUCCESS" usingBlock:^(NSNotification *note) {
        [self initloading];
    }];
}

#pragma mark - loadData

-(void)loadNearestCityWithLng:(NSString *)lng lat:(NSString *)lat radius:(NSString *)radius{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    NearestCityAPI *nearestCityApi = [[NearestCityAPI alloc]initWithLng:lng lat:lat radius:radius];
    [nearestCityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            NSDictionary *region = [content objectForKey:@"region"];
            
            RegionModel *regionModel = [RegionModel mj_objectWithKeyValues:region];
            
            [AppLocation sharedInstance].selectCity = regionModel;
            
            if (regionModel) {
                self.selectCityLbl.text = regionModel.name;
                self.cityId = regionModel.id;
                if (regionModel.id.length == 0) {
                    self.cityId = @"";
                }
                self.regionlbl.text = @"区域";
                self.districtId = @"";
                [self.regionArray removeAllObjects];
                
                [self.regionArray addObjectsFromArray:regionModel.districts];
                
                [self initloading];
 
            }
//            self.selectCityLbl.text = city.name;
            //[self initloading];
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        
    }];
    
}

-(void)loadNewData{
    [self.houseArray removeAllObjects];
    self.skip = @"0";
    
    [self loadDataWithSearchword:self.searchWord];
}

-(void)loadMoreData{
    
    NSInteger count = [self.skip integerValue];
    self.skip = [NSString stringWithFormat:@"%ld",count+[self.limit integerValue]];
    
    [self loadDataWithSearchword:self.searchWord];
}
//根据搜索关键字搜索列表
-(void)loadDataWithSearchword:(NSString *)searchword{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];

    HouseListAPI *houseListApi = [[HouseListAPI alloc]initWithProvinceId:self.provinceId cityId:self.cityId districtId:self.districtId priceId:self.priceId houseTypeId:self.houseTypeId areaId:self.areaId keyword:self.searchWord limit:self.limit skip:self.skip];
    [houseListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            NSArray *list = content[@"projects"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    HousesModel *houseModel = [HousesModel mj_objectWithKeyValues:dic];
                    [self.houseArray addObject:houseModel];
                }
            }
            
            if (self.houseArray.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            
            if (list.count < [self.limit intValue]) {
                [self loadAll];
            }
            
            [self.tv reloadData];
            
        }else{
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
            [self.tv reloadData];
             [self presentFailureTips:result[@"message"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        self.tv.emptyDataSetSource = self;
        self.tv.emptyDataSetDelegate = self;
        [self.tv reloadData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];
    
}

-(void)loadProjectOption{
    [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
    ProjectOptionsAPI *projectOptionApi = [[ProjectOptionsAPI alloc]init];
    [projectOptionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"%@",result);
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSDictionary *options = content[@"options"];
            NSArray *area = options[@"area"];
            NSArray *housetype = options[@"house_type"];
            NSArray *price = options[@"price"];
            
            for (NSDictionary *areaDic in area) {
                AreaOprionModel *areaOptionModel = [AreaOprionModel mj_objectWithKeyValues:areaDic];
                [self.areaArr addObject:areaOptionModel];
            }
            
            for (NSDictionary *housetypeDic in housetype) {
                HouseTypeOptionModel *housetypeOptionModel = [HouseTypeOptionModel mj_objectWithKeyValues:housetypeDic];
                [self.houseTypeArr addObject:housetypeOptionModel];
            }
            
            for (NSDictionary *priceDic in price) {
                PriceOptionModel *priceOptionModel = [PriceOptionModel mj_objectWithKeyValues:priceDic];
                [self.priceArr addObject:priceOptionModel];
            }
            
            [STICache.global setObject:@[self.priceArr,self.houseTypeArr,self.areaArr] forKey:@"PROJRCTOPTION"];
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTxt resignFirstResponder];
    self.searchWord = self.searchTxt.text;
    [self initloading];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.houseMenuTable hideMenuTable];
    
    return YES;
}

#pragma mark - table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.houseArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HousesCell *cell=[tableView dequeueReusableCellWithIdentifier:houseIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    if (self.houseArray.count > indexPath.row) {
        cell.data = self.houseArray [indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREENWIDTH *450)/750;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.houseArray.count > indexPath.row) {
        HousesModel *houseModel = self.houseArray [indexPath.row];
        HouseDetailController *houseDetail = [HouseDetailController spawn];
        houseDetail.indexPath = indexPath;
        houseDetail.houseModel = houseModel;
        houseDetail.isHouseList = YES;
        [self.navigationController pushViewController:houseDetail animated:YES];
    }
}

#pragma mark - uitextfielddelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    
    
    return YES;
}

#pragma mark - HousesCellDelegate
-(void)loveButtonClick:(id)modelData{
    //喜欢点击
    
    if (modelData) {
        
        HousesModel *houseModel = (HousesModel *)modelData;
        
        [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
//        [self presentLoadingTips:nil];
        //网络请求，点击喜欢
        HouseDetailAPI *collectApi = [[HouseDetailAPI alloc]initWithHoustId:houseModel.project_id];
        
        
        NSInteger status = [houseModel.is_favorite integerValue];
        if (status == 0){
            collectApi.operateHouse = COLLECTHOUSE;
        }else{
            collectApi.operateHouse = CANCELCOLLECTHOUSE;
        }
        [collectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
//            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                NSInteger index = [self.houseArray indexOfObject:modelData];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                HousesCell *cell = [self.tv cellForRowAtIndexPath:indexPath];
                NSInteger status = [houseModel.is_favorite integerValue];
                if (status == 0) {

                    [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"收藏楼盘成功"];
                    houseModel.is_favorite = @"1";
                    
                    NSInteger favorites = [houseModel.favorites integerValue];
                    houseModel.favorites = [NSString stringWithFormat:@"%ld",favorites+1];
                    
                    [self.houseArray replaceObjectAtIndex:index withObject:houseModel];
                    [self.tv reloadData];
                }else{
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"取消收藏楼盘"];
                    houseModel.is_favorite = @"0";
                    NSInteger favorites = [houseModel.favorites integerValue];
                    houseModel.favorites = [NSString stringWithFormat:@"%ld",favorites-1];
                    [self.houseArray replaceObjectAtIndex:index withObject:houseModel];
                    [self.tv reloadData];
                }
                
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
}

#pragma mark - HouseMenuTableDelegate

-(void)didHide
{
    self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    self.priceButton.selected=NO;
    self.houseStyleButton.selected = NO;
    self.areaButton.selected = NO;
    self.regionButton.selected = NO;
    
    self.arrowBtn.selected = NO;
    self.arrowDownIV.image = [UIImage imageNamed:@"home_nav_DownArrow"];
    
}



-(NSString *)showRowDataWithView:(WSSMenuTable *)menuTable AtIndex:(NSIndexPath *)indexPath withSelectOption:(NSInteger)selectOption{
    
    if (selectOption == 0) {
        //价格
        PriceOptionModel *priceOptionModel = menuTable.singleDataArray[indexPath.row];
        return priceOptionModel.name;
    }else if (selectOption == 1){
        //户型
        HouseTypeOptionModel *houseTypeOptionModel = menuTable.singleDataArray[indexPath.row];
        return houseTypeOptionModel.name;
    }else if (selectOption == 2){
        //面积
        AreaOprionModel *areaOptionModel = menuTable.singleDataArray[indexPath.row];
        return areaOptionModel.name;
        
        
    }else if (selectOption == 4){
        //区域
        RegionModel *regionModel = menuTable.singleDataArray[indexPath.row];
        return regionModel.name;
    }
    return nil;
}

-(void)showRowDataWithCell:(MenuTableCell *)cell View:(WSSMenuTable *)menuTable AtIndex:(NSIndexPath *)indexPath withSelectOption:(NSInteger)selectOption{
    
    MenuTableCell *menuCell = (MenuTableCell *)cell;
    WSSMenuTable *menu = (WSSMenuTable *)menuTable;
    
    
    if (selectOption == 0) {
        //价格
        PriceOptionModel *priceOptionModel = menuTable.singleDataArray[indexPath.row];
        if (_priceId ==  priceOptionModel.price_id) {
//            menuCell.contentLbl.textColor = [UIColor colorWithRed:9/255.0 green:177/255.0 blue:247/255.0 alpha:1.0];
            menuCell.contentLbl.textColor = BLUE_TEXTCOLOR;
            [menu.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    }else if (selectOption == 1){
        //户型
        HouseTypeOptionModel *houseTypeOptionModel = menuTable.singleDataArray[indexPath.row];
        if (_houseTypeId ==  houseTypeOptionModel.house_type_id) {
//            menuCell.contentLbl.textColor = [UIColor colorWithRed:9/255.0 green:177/255.0 blue:247/255.0 alpha:1.0];
            menuCell.contentLbl.textColor = BLUE_TEXTCOLOR;
            [menu.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }else if (selectOption == 2){
        //面积
        AreaOprionModel *areaOptionModel = menuTable.singleDataArray[indexPath.row];
        
        if (_areaId ==  areaOptionModel.area_id) {
//            menuCell.contentLbl.textColor = [UIColor colorWithRed:9/255.0 green:177/255.0 blue:247/255.0 alpha:1.0];
            menuCell.contentLbl.textColor = BLUE_TEXTCOLOR;
            [menu.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }else if (selectOption == 4){
        //区域
        RegionModel *regionModel = menuTable.singleDataArray[indexPath.row];
        if (_districtId ==  regionModel.id) {
//            menuCell.contentLbl.textColor = [UIColor colorWithRed:9/255.0 green:177/255.0 blue:247/255.0 alpha:1.0];
            menuCell.contentLbl.textColor = BLUE_TEXTCOLOR;
            [menu.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

-(void)didSelectRowWithView:(WSSMenuTable *)menuTable AtIndexPath:(NSIndexPath *)indexPath withSeletOption:(NSInteger)selectOption{
    if (selectOption == 0) {
        //价格
        PriceOptionModel *priceOptionModel = menuTable.singleDataArray[indexPath.row];
        self.priceLbl.text = priceOptionModel.name;
        _priceId = priceOptionModel.price_id;
        
        // 加载数据
        [self initloading];
    }else if (selectOption == 1){
        //户型
        HouseTypeOptionModel *houseTypeOptionModel = menuTable.singleDataArray[indexPath.row];
        self.houseStyleLbl.text = houseTypeOptionModel.name;
        _houseTypeId = houseTypeOptionModel.house_type_id;
        [self initloading];
        // 加载数据
    }else if (selectOption == 2){
        //面积
        AreaOprionModel *areaOptionModel = menuTable.singleDataArray[indexPath.row];
        self.areaLbl.text = areaOptionModel.name;
        _areaId = areaOptionModel.area_id;
         // 加载数据
        [self initloading];
       
        
    }else if (selectOption == 4){
        //区域
        RegionModel *regionModel = menuTable.singleDataArray[indexPath.row];
        self.regionlbl.text = regionModel.name;
        _districtId = regionModel.id;
        [self initloading];
        // 加载数据
        
    }
    [self didHide];
    
}

//-(void)didSelectDoubleTableAtLeftIndexPath:(NSIndexPath *)leftIndexPath RightIndexPath:(NSIndexPath *)rightIndexPath{
//    
//    NSDictionary *leftDic = self.selectHouseArr[leftIndexPath.row];
//    
//    NSArray *arr = leftDic[@"array"];
//    
//    
//    NSString *str = arr[rightIndexPath.row];
//    self.loupanStr = str;
//
//    [self setNavigationBar];
//    
//}
//
//
//- (void)didSelectSingleTableAtIndexPath:(NSIndexPath *)indexPath withSeletOption:(NSInteger)selectOption{
//    
//    
//    if (selectOption == 0) {
//        
//        NSString *str = self.priceArr[indexPath.row];
//        self.priceLbl.text = str;
//        
//        // 加载数据
//        [self initloading];
//    }else if (selectOption == 1){
//        
//        NSString *str = self.houseTypeArr[indexPath.row];
//        self.houseStyleLbl.text = str;
//        [self initloading];
//        // 加载数据
//    }else if (selectOption == 2){
//        
//        NSString *str = self.areaArr[indexPath.row];
//        self.areaLbl.text = str;
//        [self initloading];
//        // 加载数据
//
//    }else if (selectOption == 4){
//        
//        NSString *str = self.regionArray[indexPath.row];
//        self.regionlbl.text = str;
//        [self initloading];
//        // 加载数据
//        
//    }
//}



#pragma mark - click

- (IBAction)regionButtonClick:(id)sender {
    self.regionButton.selected = !self.regionButton.selected;
    if (self.regionButton.selected == YES) {
        self.priceButton.selected = NO;
        self.houseStyleButton.selected = NO;
        self.areaButton.selected = NO;
        self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    }else{
        
        self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    
    self.houseMenuTable.currrntSelectedColumn = 1100;
    self.houseMenuTable.singleDataArray = self.regionArray;
    
    [_houseMenuTable tableViewWithOption:4 animation:self.regionButton.selected];
}



//价格
- (IBAction)priceButtonClick:(id)sender {
    
    self.priceButton.selected = !self.priceButton.selected;
    if (self.priceButton.selected == YES) {
        self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleButton.selected = NO;
        self.areaButton.selected = NO;
        self.regionButton.selected = NO;
        
    }else{
         self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    
//    NSArray *array = @[@"价格",@"6千以下",@"6千-1万",@"1-1.5万",@"1.5-2万",@"2-3万",@"3-4万",@"4-6万",@"6万以上"];
//    
//    [self.priceArr removeAllObjects];
//        [self.priceArr addObjectsFromArray:self.priceArr];
    self.houseMenuTable.currrntSelectedColumn = 1101;
    self.houseMenuTable.singleDataArray = self.priceArr;
    
    [_houseMenuTable tableViewWithOption:0 animation:self.priceButton.selected];
    
}
//户型
- (IBAction)houseTypeClick:(id)sender {
    
    self.houseStyleButton.selected = !self.houseStyleButton.selected;
    if (self.houseStyleButton.selected == YES) {
        self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceButton.selected = NO;
        self.areaButton.selected = NO;
        self.regionButton.selected = NO;
        
    }else{
         self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    
//    NSArray *array = @[@"户型",@"一室",@"二室",@"三室",@"四室",@"五室以上"];
//    [self.houseTypeArr removeAllObjects];
//    [self.houseTypeArr addObjectsFromArray:array];
    self.houseMenuTable.currrntSelectedColumn = 1102;
    self.houseMenuTable.singleDataArray = self.houseTypeArr;
    
//    [self.menuTable showSingleTableViewWithDataArray:self.houseTypeArr];
//    CGRect frame = _menuTable.frame;
//    frame.origin.y = 51;
//    _menuTable.frame = frame;
    [_houseMenuTable tableViewWithOption:1 animation:self.houseStyleButton.selected];
}

//面积
- (IBAction)areaButtonCLick:(id)sender {
    
    self.areaButton.selected = !self.areaButton.selected;
    if (self.areaButton.selected == YES) {
        self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_up"];
        self.priceButton.selected = NO;
        self.houseStyleButton.selected = NO;
        self.regionButton.selected = NO;
       
    }else{
         self.regionimageView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.priceImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.houseStyleImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
        self.areaImgView.image = [UIImage imageNamed:@"f1_arrow_down"];
    }
    
//    NSArray *array = @[@"面积",@"60㎡以下",@"60-80㎡",@"80-100㎡",@"100-120㎡",@"120-150㎡",@"150-200㎡",@"200㎡以上"];
//    [self.areaArr removeAllObjects];
//    [self.areaArr addObjectsFromArray:array];
    self.houseMenuTable.currrntSelectedColumn = 1103;
    self.houseMenuTable.singleDataArray = self.areaArr;
    
    [_houseMenuTable tableViewWithOption:2 animation:self.areaButton.selected];

    
}

//搜索点击
-(void)searchClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSString *searchword = [self.searchTxt.text trim];
    
    if ([ISNull isNilOfSender:searchword]) {
        return;
    }
    
    self.searchWord = searchword;
    
    
    if (self.searchWord.length == 0) {
        self.searchWord = @"";
    }
    
      [self initloading];
    //加载数据
//    [self loadDataWithSearchword:self.searchWord];
}

#pragma mark - DZNEmptyDelegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *text = @"暂没有楼盘信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
