//
//  SelectedCommunityController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SelectedCommunityController.h"
#import "SelectAddressCell.h"
#import "CompleteCell.h"

@interface SelectedCommunityController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toobar;
@property (nonatomic, strong) NSArray *iconImageArray;

@property (nonatomic, assign) NSInteger seleteRegionWithProvince;//省
@property (nonatomic, assign) NSInteger seleteRegionWithCity;//市
@property (nonatomic, assign) NSInteger seleteRegion;//区
@property (nonatomic, assign) NSInteger seleteComunity;//小区
@property (nonatomic, assign) NSInteger seleteBuild;//楼栋
@property (nonatomic, assign) NSInteger seleteRoom;//门牌号

@property (nonatomic, strong) NSMutableArray *regionsArray;//省市区
@property (nonatomic, strong) NSMutableArray *comunityArray;//所有的小区
@property (nonatomic, strong) NSMutableArray *buildingArray;//获取楼栋和房间号
@property (nonatomic, strong) NSMutableArray *buildArray;//获取楼栋
@property (nonatomic, strong) NSMutableArray *unitArray;//获取房间号(停车费用手动输入)

@property (nonatomic, copy) NSString *regionString;//选择省市区地址;
@property (nonatomic, copy) NSString *communityString;//选择小区;
@property (nonatomic, copy) NSString *buildString;//选择楼栋;
@property (nonatomic, copy) NSString *buildingString;//选择楼栋和门牌号;
@property (nonatomic, copy) NSString *unitString;//选择房间号;
@property (nonatomic, copy) NSString *regionId;//区id;
@property (nonatomic, copy) NSString *communityId;//小区id;
@property (nonatomic, copy) NSString *buildId;//楼栋id;
@property (nonatomic, copy) NSString *unitId;//房间id;
@property (nonatomic, strong) UITextField *roomTextField;

@property (nonatomic, strong) RegionModel *region;
@property (nonatomic, strong) CommunityModel *community;
@property (nonatomic, strong) BuildModel *build;

@end

@implementation SelectedCommunityController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setnavigationBar];
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self.tableView tableViewRemoveExcessLine];
   
    //初始化数据
    self.regionsArray = [NSMutableArray array];
    self.comunityArray = [NSMutableArray array];
    self.buildingArray = [NSMutableArray array];
    self.buildArray = [NSMutableArray array];
    self.unitArray = [NSMutableArray array];
    
    _seleteRegionWithProvince = 0;
    _seleteRegionWithCity = 0;
    _seleteRegion = 0;
    _seleteComunity = 0;
    _seleteBuild = 0;
    _seleteRoom = 0;
    
    _regionString = @"请选择省市区";
    _communityString = @"请选择小区";
    _buildString = @"请选择楼栋";
    _unitString = @"请选择门牌号";
    
    //图片
    self.iconImageArray = @[@"home_pay_icon1",@"home_pay_icon2",@"home_pay_icon3",@"home_pay_icon4"];
     [self.tableView registerNib:@"SelectAddressCell"];
    [self.tableView registerNib:@"CompleteCell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.isTabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}
#pragma mark-navibar
-(void)setnavigationBar{
    
    self.navigationItem.title = @"选择小区";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - VIEWS
#pragma mark -创建选择器
-(void)creatPickerViewWithTag:(NSInteger)tag
{
    /*!
     101 省市区
     102 小区
     103 楼栋
     104 楼栋和房间号
     ...
     */
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-216, SCREENWIDTH, 216)];
        
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setTag:tag];
        [self.view addSubview:_pickerView];
//        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.view.mas_left);
//            make.bottom.mas_equalTo(self.view.mas_bottom);
//            make.right.mas_equalTo(self.view.mas_right);
//            make.height.mas_equalTo(@216);
//        }];
        
        _toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-218-38, SCREENWIDTH, 38)];
        _toobar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                           style:UIBarButtonItemStyleDone target:self action:@selector(tapAction)];
        
        [_toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
        [self.view addSubview:_toobar];
        
//        [_toobar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.view.mas_left);
//            make.bottom.mas_equalTo(_pickerView.mas_top);
//            make.right.mas_equalTo(self.view.mas_right);
//            make.height.mas_equalTo(@38);
//        }];
    }else{
        [_pickerView setTag:tag];
        [_toobar setHidden:NO];
        [_pickerView setHidden:NO];
    }
    [_pickerView reloadAllComponents];
    if (tag ==101) {
        [_pickerView selectRow:_seleteRegionWithProvince inComponent:0 animated:YES];
        [_pickerView selectRow:_seleteRegionWithCity inComponent:1 animated:YES];
        [_pickerView selectRow:_seleteRegion inComponent:2 animated:YES];
        
        [self updateRegionInfo];
    } else if (tag == 102) {
        [_pickerView selectRow:_seleteComunity inComponent:0 animated:YES];
        [self updateComunityInfo];
    } else if (tag == 103) {
        [_pickerView selectRow:_seleteBuild inComponent:0 animated:YES];
        [self updateBuildInfo];
    } else if (tag == 104) {
        [_pickerView selectRow:_seleteRoom inComponent:0 animated:YES];
        [self updateRoomInfo];
    }
    
}
-(void)tapAction
{
    [_toobar setHidden:YES];
    [_pickerView setHidden:YES];
}

#pragma mark - REQUEST
//获取省市区
-(void)regionsData
{
//    if ([_allregionModel isEmpty]) {
//        [_allregionModel refresh];
//    }else{
//        [_allregionModel loadCache];
//    }
//    
//    @weakify(self);
    [self presentLoadingTips:@"加载中..."];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    SelectAddressAPI *getRegionApi = [[SelectAddressAPI alloc]init];
    getRegionApi.addressType = SELECTADDRESS_REGION;
    [getRegionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                RegionModel *regionModel = [RegionModel mj_objectWithKeyValues:dic];
                [self.regionsArray addObject:regionModel];
            }
            
            if (_regionsArray.count > 0) {
                [self creatPickerViewWithTag:101];
            } else {
                [self presentFailureTips:@"暂无省市区数据"];
            }
            
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
//获取该地区的所有小区
-(void)comunityDataInRegionId:(NSString*)regionId
{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    SelectAddressAPI *getCommunityApi = [[SelectAddressAPI alloc]initWithId:regionId];
    getCommunityApi.addressType = SELECTADDRESS_COMMUNITY;
    [getCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                CommunityModel *communityModel = [CommunityModel mj_objectWithKeyValues:dic];
                [self.comunityArray addObject:communityModel];
            }
            
            if (self.comunityArray.count > 0) {
                [self creatPickerViewWithTag:102];
            } else {
                [self presentFailureTips:@"暂无小区数据"];
            }
            
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
//获取该小区的所有楼栋
-(void)buildDataInCommunityId:(NSString*)communityId
{
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    SelectAddressAPI *getBuildApi = [[SelectAddressAPI alloc]initWithId:communityId];
    getBuildApi.addressType = SELECTADDRESS_BUILD;
    [getBuildApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                BuildModel *regionModel = [BuildModel mj_objectWithKeyValues:dic];
                [self.buildArray addObject:regionModel];
            }
            
            if (_buildArray.count > 0) {
                [self creatPickerViewWithTag:103];
            } else {
                [self presentFailureTips:@"暂无楼栋数据"];
            }
            
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
//获取该楼栋的所有门牌号
-(void)unitDataInColorcloudBuildingId:(NSString*)buildingId
{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    SelectAddressAPI *getUnitApi = [[SelectAddressAPI alloc]initWithId:buildingId];
    getUnitApi.addressType = SELECTADDRESS_UNIT;
    [getUnitApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                BuildModel *regionModel = [BuildModel mj_objectWithKeyValues:dic];
                [self.unitArray addObject:regionModel];
            }
            
            if (self.unitArray.count > 0) {
                [self creatPickerViewWithTag:104];
            } else {
                [self presentFailureTips:@"暂无门牌号数据"];
            }
            
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

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
//    [footerView setBackgroundColor:VIEW_BG_COLOR];
//    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    footerBtn.userInteractionEnabled = YES;
//    [footerBtn setBackgroundColor:UIColorFromRGB(0x27A2F0)];
//    [footerBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [footerBtn.layer setCornerRadius:4];
//    [footerBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:footerBtn];
//
//    return footerView;
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectAddressCell" forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:self.iconImageArray[indexPath.row]];
        if (indexPath.row ==0) {
            [cell.alertLabel setText:_regionString];
        }else if(indexPath.row == 1){
            [cell.alertLabel setText:_communityString];
        }else if (indexPath.row == 2){
            [cell.alertLabel setText:_buildString];

        }else if (indexPath.row == 3){
            [cell.alertLabel setText:_unitString];
        }
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self tapAction];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //选择省市区
            if (_regionsArray.count>0) {
                [self creatPickerViewWithTag:101];
            }else{
                [self regionsData];
            }
            [self.comunityArray removeAllObjects];
            [self updateComunityInfo];
            
            [self.buildArray removeAllObjects];
            [self updateBuildInfo];
            
            [self.unitArray removeAllObjects];
            [self updateRoomInfo];
            
        }else if (indexPath.row == 1) {
            //选择小区
            if ([ISNull isNilOfSender:_regionId]) {
                [self presentFailureTips:@"请选择省市区"];
                return;
            }else{
                if (self.comunityArray.count>0) {
                    [self creatPickerViewWithTag:102];
                }else{
                    [self comunityDataInRegionId:_regionId];
                }
            }
            
            [self.buildArray removeAllObjects];
            [self updateBuildInfo];
            
            [self.unitArray removeAllObjects];
            [self updateRoomInfo];
            
        }
        else if (indexPath.row == 2) {
            //选择楼栋
            if ([ISNull isNilOfSender:_communityId]) {
                [self presentFailureTips:@"请选择小区"];
                return;
            }else{
                if (_buildArray.count>0) {
                    [self creatPickerViewWithTag:103];
                }else{
                    [self buildDataInCommunityId:_communityId];
                }
            }
            [self.unitArray removeAllObjects];
            [self updateRoomInfo];
            
        }else
        {
            //填写房间号(停车费)
            //        if (_status == ChargeSystem) {
            if ([ISNull isNilOfSender:_buildId]) {
                [self presentFailureTips:@"请选择楼栋"];
                return;
            }else{
                if (self.unitArray.count>0) {
                    [self creatPickerViewWithTag:104];
                }else{
                    [self unitDataInColorcloudBuildingId:_buildId];
                }
            }
        }
    }else{
        
        [self.view endEditing:YES];
        [self tapAction];
        if ([ISNull isNilOfSender:_regionId]) {
            [self presentFailureTips:@"请选择省市区"];
            return;
        }
        if ([ISNull isNilOfSender:_communityId]) {
            [self presentFailureTips:@"请选择小区"];
            return;
        }
        if ([ISNull isNilOfSender:_buildId]) {
            [self presentFailureTips:@"请选择楼栋"];
            return;
        }
        if ([ISNull isNilOfSender:_unitId]) {
            [self presentFailureTips:@"请选择门牌号"];
            return;
        }
      
        AddressModel *addressModel = [[AddressModel alloc] init];
      
        CommunityModel *community = [_comunityArray objectAtIndex:_seleteComunity];
      
        BuildModel *build = [_buildArray objectAtIndex:_seleteBuild];
        addressModel.build_id = build.id;
        addressModel.build = build.name;
        addressModel.province_name = _regionString;
        addressModel.community_id = [NSNumber numberWithInteger:[community.id integerValue]];
        addressModel.community_name = community.name;

        BuildModel *room = [_unitArray objectAtIndex:_seleteRoom];
        addressModel.room_id = room.id;
        addressModel.room = room.name;
        
        
        [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
        AddAddressAPI *addAddressApi = [[AddAddressAPI alloc]initWithCommunityid:[NSString stringWithFormat:@"%ld",(long)[addressModel.community_id integerValue]]  buildid:addressModel.build_id  roomid:addressModel.room_id buildName:addressModel.build roomName:addressModel.room];
        [addAddressApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDADDRESSSUCCESS" object:nil];
                
                UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
                [self.navigationController popToViewController:vc animated:true];
                
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
#pragma mark - pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //选择省市区
    if (pickerView.tag==101) {
        return 3;
    }
    //选择小区
    else if (pickerView.tag ==102){
        return 1;
    }
    //选择楼栋
    else if (pickerView.tag ==103){
        return 1;
    }
    //选择门牌号
    else if (pickerView.tag ==104){
        return 1;
    } else {
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //选择省市区
    if (pickerView.tag==101) {
        
        if (component==0) {//省
            return _regionsArray.count;
        }else if (component==1){//市
            _region = [_regionsArray objectAtIndex:_seleteRegionWithProvince];
            if (_region.citys==nil) {
                return 0;
            }
            return _region.citys.count;
        }else{//区
            _region = [_regionsArray objectAtIndex:_seleteRegionWithProvince];
            if (_region.citys==nil) {
                return 0;
            }
            _region = [_region.citys objectAtIndex:_seleteRegionWithCity];
            if (_region.districts==nil) {
                return 0;
            }
            return _region.districts.count;
        }
    }
    //选择小区
    else if (pickerView.tag ==102){
        return self.comunityArray.count;
    }
    //选择楼栋
    else if (pickerView.tag ==103){
        return self.buildArray.count;
    }
    //选择楼栋和门牌号
    else{
        return self.unitArray.count;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //选择省市区
    if (pickerView.tag==101) {
        if (component==0) {//省
            _region = [_regionsArray objectAtIndex:row];
            return _region.name;
        }else if (component==1){//市
            _region = [_regionsArray objectAtIndex:_seleteRegionWithProvince];
            _region = [_region.citys objectAtIndex:row];
            return _region.name;
        }else{//区
            _region = [_regionsArray objectAtIndex:_seleteRegionWithProvince];
            _region = [_region.citys objectAtIndex:_seleteRegionWithCity];
            _region = [_region.districts objectAtIndex:row];
            return _region.name;
        }
    }
    //选择小区
    else if (pickerView.tag ==102){
        _community = [self.comunityArray objectAtIndex:row];
        return _community.name;
    }
    //选择楼栋
    else if (pickerView.tag ==103){
        _build = [_buildArray objectAtIndex:row];
        return _build.name;
    }
    //选择楼栋和门牌号
    else{
        _build = [self.unitArray objectAtIndex:row];
        return _build.name;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //选择省市区
    if (pickerView.tag==101) {
        if (component==0) {//省
            _seleteRegionWithProvince = row;
            _seleteRegionWithCity = 0;
            _seleteRegion = 0;
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [self updateRegionInfo];
        }else if (component==1){//市
            _seleteRegionWithCity = row;
            _seleteRegion = 0;
            [pickerView reloadComponent:2];
            [self updateRegionInfo];
        }else{//区
            _seleteRegion = row;
            [self updateRegionInfo];
        }
    }
    //选择小区
    else if (pickerView.tag ==102){
        _seleteComunity = row;
        [self updateComunityInfo];
    }
    //选择楼栋
    else if (pickerView.tag ==103){
        _seleteBuild = row;
        [self updateBuildInfo];
    }
    //选择门牌号
    else{
        _seleteRoom = row;
        [self updateRoomInfo];
    }
}
//更新省市区显示
-(void)updateRegionInfo
{
    NSString *provinceString;
    NSString *cityString;
    NSString *districtsString;
    _region = [_regionsArray objectAtIndex:_seleteRegionWithProvince];
    provinceString = _region.name;
    if (_region.citys ==nil) {
        cityString = @"";
        districtsString = @"";
    }else{
        _region = [_region.citys objectAtIndex:_seleteRegionWithCity];
        cityString = _region.name;
        if (_region.districts ==nil ||_region.districts.count ==0) {
            districtsString = @"";
        }else{
            _region = [_region.districts objectAtIndex:_seleteRegion];
            districtsString = _region.name;
            _regionId = _region.id;
        }
    }
    _regionString = [NSString stringWithFormat:@"%@%@%@",provinceString,cityString,districtsString];
    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];//刷新第一个section的第二行
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
}
// 更新小区信息
- (void)updateComunityInfo {
    if (![ISNull isNilOfSender:self.comunityArray]) {
        _community = [self.comunityArray objectAtIndex:_seleteComunity];
        if ([ISNull isNilOfSender:_community.name]) {
            _communityString = @"请选择小区";
        } else {
            _communityString = _community.name;
            _communityId = [NSString stringWithFormat:@"%ld",[_community.id integerValue]];
        }
    } else {
        _communityId = nil;
        _seleteComunity = 0;
        _communityString = @"请选择小区";
    }
    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:1 inSection:0];//刷新第一个section的第二行
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
}
//更新楼栋信息
- (void)updateBuildInfo {
    if (![ISNull isNilOfSender:_buildArray]) {
        _build = [_buildArray objectAtIndex:_seleteBuild];
        if ([ISNull isNilOfSender:_build.name]) {
            _buildString = @"请选择楼栋";
        } else {
            _buildString = _build.name;
            _buildId = _build.id;
        }
    } else {
        _buildId = nil;
        _seleteBuild = 0;
        _buildString = @"请选择楼栋";
    }
    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:2 inSection:0];//刷新第一个section的第二行
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
//更新门牌号信息
- (void)updateRoomInfo {
    if (![ISNull isNilOfSender:self.unitArray]) {
        _build = [self.unitArray objectAtIndex:_seleteRoom];
        if ([ISNull isNilOfSender:_build.name]) {
            _unitString = @"请选择门牌号";
        } else {
            _unitString = _build.name;
            _unitId = [NSString stringWithFormat:@"%ld",[_build.id integerValue]];
        }
    } else {
        _unitId = nil;
        _seleteRoom = 0;
        _unitString = @"请选择门牌号";
    }
    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:3 inSection:0];//刷新第一个section的第二行
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
    
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
