//
//  MenuTable.m
//  YiDa
//
//  Created by 沿途の风景 on 14-10-11.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import "MenuTable.h"
#import "SurroundingDatabase.h"
#import "MenuCell.h"
#import "AreaMenuCell.h"

#define SCREENTWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENTHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MenuTable ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) int selectedOption;
@property (nonatomic, retain) NSMutableArray *districtArray;
@property (nonatomic, retain) NSMutableArray *communityArray;
@property (nonatomic, retain) NSMutableArray *allCommunityArray;
@property (nonatomic, retain) NSMutableArray *areaArray;

@property (nonatomic, retain) NSString *provinceid;
@property (nonatomic, retain) NSString *cityid;

@end

@implementation MenuTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //默认菜单是关闭的
        self.openContentView = NO;
        self.hidden = YES;
        
//        self.districtid = @"0";
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        //界面布局
        [self prepareLayout];
        
        //数据
        [self fillData];
    }
    return self;
}

- (void)prepareLayout
{
    _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENTWIDTH, self.frame.size.height)];
    _bg.backgroundColor =[UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_bg];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
    [self.bg addGestureRecognizer:tap];
    //    [_bg addTapAction:@selector(hide:) forTarget:self];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENTWIDTH, 140)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;   //不要忘记
    [self addSubview:_contentView];
    
    //半径或类别列表
    _globalTable = [[UITableView alloc] initWithFrame:_contentView.bounds];
    _globalTable.backgroundColor = [UIColor clearColor];
    _globalTable.delegate = self;
    _globalTable.dataSource = self;
    _globalTable.rowHeight = 35;
//    _globalTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (GT_IOS7) {
        _globalTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [_contentView addSubview:_globalTable];
    
 
    
    //区域列表
    _areaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 106, 140)];
    _areaTable.backgroundColor = [UIColor clearColor];
    _areaTable.delegate = self;
    _areaTable.dataSource = self;
    _areaTable.rowHeight = 35;
    _areaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_areaTable];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake( 106, 0 , 0.5, 140)];
    self.lineView.backgroundColor =RGBACOLOR(179, 179, 179, 1.0) ;
    [_contentView addSubview:self.lineView];
    
    //小区列表
    _communityTable = [[UITableView alloc] initWithFrame:CGRectMake(107, 0, SCREENTWIDTH-107, 140)];
    _communityTable.backgroundColor = [UIColor clearColor];
    _communityTable.delegate = self;
    _communityTable.dataSource = self;
    _communityTable.rowHeight = 35;

    [_contentView addSubview:_communityTable];
    
    [_contentView bringSubviewToFront:_areaTable];
    [_contentView bringSubviewToFront:_communityTable];
}

- (void)fillData
{
    _communityArray = [[NSMutableArray alloc] init];
    
    _allCommunityArray=[[NSMutableArray alloc] init];
    
    self.categoryArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Industry" ofType:@"plist"]];
    self.category = [_categoryArray objectAtIndex:0];//用作默认数据
    
    self.distanceArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurroundingRadius" ofType:@"plist"]];
    self.radius = [_districtArray objectAtIndex:0];//用作默认数据
    
    [self.globalTable reloadData];
}
-(void)tableViewWithDistrictid:(NSString *)districtId{
    
}
#pragma mark - 第一次加载小区信息

- (void)loadCommunityInfomationOfDistrict:(NSString *)provinceid cityid:(NSString *)cityid districtid:(NSString *)districtid
{
    
    self.cityid = cityid;
    self.provinceid = provinceid;
    self.districtid = districtid;
    
    //从数据库查询对应区域
    self.districtArray = [[NSMutableArray alloc] initWithArray:[[SurroundingDatabase shareSurroundingDB] selectDistrictWithProvinceid:provinceid cityid:cityid]];
    //PRINT(@"districtArray : %@",_districtArray);
    
    //全部
    NSDictionary *all_district = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"districtid",@"全部",@"districtname", nil];
    [self.districtArray insertObject:all_district atIndex:0];
    
    [_areaTable reloadData];
}

#pragma mark - 菜单开关动画

-(void)hide:(id)sender
{
    [self tableViewWithOption:self.selectedOption animation:YES];
    
    [UIView animateWithDuration:0.35 animations:^{
        

            _contentView.height = 0;
    
        
    } completion:^(BOOL finished) {
      
            self.hidden = YES;

        self.openContentView = NO;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didHide)]) {
            [self.delegate didHide];
        }
    }];
}

- (void)tableViewWithOption:(int)option animation:(BOOL)show
{
    self.selectedOption = option;
    
    if (option == 2) {  //地址
        _globalTable.hidden = YES;
        self.lineView.hidden = NO;
        _areaTable.hidden = NO;
        _communityTable.hidden = NO;
        
        if (self.districtid != nil) {
            [self remeberCurrentDistrict];
//            [self.areaTable reloadData];
        }
        
        //获取小区名字
        if (!_openContentView) {
            [self communityList:nil];
        }
        else{
            if (!self.communityArray||self.communityArray.count==0) {
                [self communityList:nil];
            }
        }
        
    }
    else {  //距离或分类
        _globalTable.hidden = NO;
        self.lineView.hidden = YES;
        _areaTable.hidden = YES;
        _communityTable.hidden = YES;
        
        [_globalTable reloadData];
    }
    
    //当前菜单是打开状态&&动画是执行展开的
    if (_openContentView && show == YES) {
        return;
    }
    
    if (show) {
        _contentView.height = 0;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        if (show == NO) {
            _contentView.height = 0;
        }
        else {
            self.hidden = NO;
            _contentView.height = 140;
        }
        
    } completion:^(BOOL finished) {
        if (show == NO) {
            self.hidden = YES;
        }
        self.openContentView = show;
    }];
    
}

//记住当前所选区域
- (void)remeberCurrentDistrict
{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.districtArray.count; i++) {
        [array addObject:[_districtArray[i] objectForKey:@"districtid"]];
    }
    
    //从区域数据中匹配districtid
    NSInteger index = [array indexOfObject:_districtid];
    
    [self.areaTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _globalTable) {
        if (_selectedOption == 1) {
            return self.distanceArray.count;
        }
        return _categoryArray.count;
    }
    else if (tableView == _areaTable) {
        return _districtArray.count;
    }
    else {
        return _communityArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    static NSString *cellIdentifier1 = @"MenuCell";
    static NSString *cellIdentifier2 = @"AreaMenuCell";
        //半径或分类
    if (tableView == _areaTable ) {
        AreaMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:cellIdentifier2 owner:nil options:nil].firstObject;
            
           
        }

        UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
        selectedView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectedView;
        
        NSDictionary *district = [self.districtArray objectAtIndex:indexPath.row];
    
        if (district.count) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",[district objectForKey:@"districtname"]];
            
            if ([self.districtid isEqualToString:[district objectForKey:@"districtid"]]) {
                cell.nameLabel.textColor = RGBACOLOR(0, 153, 235, 1.0);
            }
            else {
                cell.nameLabel.textColor = [UIColor blackColor];
            }
        }
        return cell;
    }
    
        if (tableView == _communityTable) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            if (![ISNull isNilOfSender:_communityArray]) {
                Community *cm = self.communityArray[indexPath.row];
                
                if (cm) {
                    
                    cell.textLabel.text = cm.name;
                    if ([self.bid isEqualToString:[NSString stringWithFormat:@"%@",cm.bid]]) {
                        cell.textLabel.textColor = RGBACOLOR(0, 153, 235, 1.0);
                    }
                    else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                }
            }
            return cell;
        }


    else{
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:cellIdentifier1 owner:nil options:nil].firstObject;
        }
        //分类
        if (_selectedOption == 3) {
            cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[_categoryArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            
            if ([self.categoryid isEqualToString:[[_categoryArray objectAtIndex:indexPath.row] objectForKey:@"id"]]) {
                cell.nameLabel.textColor = RGBACOLOR(0, 153, 235, 1.0);
            }
            else {
                cell.nameLabel.textColor = [UIColor blackColor];
            }
        }
        //半径
        else {
            cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            NSString *distance = [NSString stringWithFormat:@"%@",[[self.distanceArray objectAtIndex:indexPath.row] objectForKey:@"radius"]];
            if ([distance judgePositiveIntegerNumberOfDigits] == 3) {
                distance = [NSString stringWithFormat:@"%@m",distance];
            }
            else if ([distance judgePositiveIntegerNumberOfDigits] >= 4) {
                distance = [NSString stringWithFormat:@"%dkm",[distance intValue]/1000];
            }
            
            cell.nameLabel.text = distance;
            
            if ([self.radiusid isEqualToString:[[self.distanceArray objectAtIndex:indexPath.row] objectForKey:@"radiusid"]]) {
                cell.nameLabel.textColor = RGBACOLOR(0, 153, 235, 1.0);
            }
            else {
                cell.nameLabel.textColor = [UIColor blackColor];
            }
        }
        
        return cell;
       
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _globalTable) {
        
        if (_selectedOption == 1) { //半径
            self.radius = [NSDictionary dictionaryWithDictionary:[self.distanceArray objectAtIndex:indexPath.row]];
            
            if ([self.delegate respondsToSelector:@selector(didSelectRadius:)]) {
                [self.delegate didSelectRadius:_radius];
            }
        }
        else {  //分类
            self.category = [NSDictionary dictionaryWithDictionary:[_categoryArray objectAtIndex:indexPath.row]];
            
            if ([self.delegate respondsToSelector:@selector(didSelectCategory:)]) {
                [self.delegate didSelectCategory:_category];
            }
        }
        
    }
    else if (tableView == _areaTable) { //区域
        
        self.tempDistrictid = [[_districtArray objectAtIndex:indexPath.row] objectForKey:@"districtid"];
        
        self.districtid = _tempDistrictid;
        
        //加载小区列表信息
        [self communityList:_tempDistrictid];
        
        [self resetCommunityState:indexPath.row];
    }
    else {  //小区
        
        Community *cm = self.communityArray[indexPath.row];
        self.districtid = _tempDistrictid;
        
        //回调参数
        if ([self.delegate respondsToSelector:@selector(didSelectCommunity:district:)]) {
            [self.delegate didSelectCommunity:cm district:_districtid];
        }
    }
}
//除当前选择的小区，恢复其他的默认值
- (void)resetCommunityState:(NSInteger)index
{
    if (self.districtArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.districtArray.count; i++) {
        NSIndexPath * indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        AreaMenuCell *cell = [self.areaTable cellForRowAtIndexPath:indexPath];
        if (i != index) {
             cell.nameLabel.textColor = [UIColor blackColor];
        }else{
            cell.nameLabel.textColor = RGBACOLOR(0, 153, 235, 1.0);
        }
    }
}
#pragma mark - 小区列表

- (void)communityList:(NSString *)tempDistrictid
{
    
    NSString *districtid = [NSString stringWithFormat:@"%@",self.districtid];
    if (tempDistrictid && [tempDistrictid trim].length != 0) {
        districtid = tempDistrictid;
    }
    
    NSLog(@"allCommunityArray:%ld",self.allCommunityArray.count);
    
    
    //如果存在本地数据，则不加载网络数据
//    if (self.allCommunityArray&&self.allCommunityArray.count>0) {
//        
//        [self.communityArray removeAllObjects];
//        
//        if ([districtid isEqualToString:@"0"]) {
////            self.communityArray = self.allCommunityArray;
//            [self.communityArray addObjectsFromArray:self.allCommunityArray];
//        }
//        else{
//            
//            for (Community *community in self.allCommunityArray) {
//                
//                if ([community.districtid isEqualToString:districtid]) {
//                    [self.communityArray addObject:community];
//                }
//                
//            }
//            
//        }
//        
//        [self.communityTable reloadData];
//        
//        //记住小区名字
//        [self rememberCommunity];
//        
//        return;
//        
//    }
    
    if ([ISNull isNilOfSender:self.cityid] || [ISNull isNilOfSender:self.districtid]) {
        return;
    }
    
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [self presentLoadingTips:nil];
    CommunityListAPI *communityListApi = [[CommunityListAPI alloc]initWithCityid:self.cityid districtid:self.districtid];
    
    [communityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        CommunityListResultModel *result = [CommunityListResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        
        if (result && [result.result intValue] == 0) {
            
            [self.communityArray removeAllObjects];
            
            self.communityArray = [NSMutableArray arrayWithArray:result.communitylist];
            
            if ([districtid isEqualToString:@"0"]) {
                self.allCommunityArray = [NSMutableArray arrayWithArray:result.communitylist];
            }
            [self.communityTable reloadData];
            
        }else{
             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
}

//记住小区名
- (void)rememberCommunity
{
    if ([ISNull isNilOfSender:_communityArray]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (Community *cm in _communityArray) {
        [array addObject:cm.bid];
    }
    
    NSInteger index = [array indexOfObject:_bid];
    
    [self.communityTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

@end
