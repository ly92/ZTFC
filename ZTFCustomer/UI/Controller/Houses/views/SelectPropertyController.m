//
//  SelectPropertyController.m
//  ZTFCustomer
//
//  Created by mac on 16/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SelectPropertyController.h"
#import "BindingPropertyConstrulantCell.h"
@interface SelectPropertyController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *limits;
@property (nonatomic, strong) NSMutableArray *propertyArr;

@end

@implementation SelectPropertyController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    
    [self setHeaderAndFooter];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:@"BindingPropertyConstrulantCell" identifier:@"BindingPropertyConstrulantCell"];
    
    [self setNavigationbar];
    
    self.skip = @"0";
    self.limits = @"10";
//    self.keyword = @"";
    
    [self initloading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HIDETABBAR;
}


-(NSMutableArray *)propertyArr{
    if (!_propertyArr) {
        _propertyArr = [NSMutableArray array];
    }
    return _propertyArr;
}


#pragma mark-navibar
-(void)setNavigationbar{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27,SCREENWIDTH-70 , 30)];
//    view.backgroundColor = [UIColor blackColor];
//    
//    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    
//    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
//    searchImg.backgroundColor = [UIColor clearColor];
//    searchImg.image = [UIImage imageNamed:@"d1_search"];
//    [view addSubview:searchImg];
//    
//    
//    if (!(GT_IOS7)){
//        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-100 , 30)];
//    }else{
//        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-100 , 30)];
//    }
//    self.searchTxt.placeholder = @"搜索楼栋管家";
//    self.searchTxt.backgroundColor = [UIColor clearColor];
//    //187 194 199
//    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
//    [self.searchTxt setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
//    self.searchTxt.borderStyle =UITextBorderStyleNone;
//    self.searchTxt.backgroundColor = [UIColor blackColor];
//    self.searchTxt.delegate = self;
//    self.searchTxt.textColor = RGBACOLOR(187, 194, 199, 1.0) ;
//    
//    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.searchTxt.returnKeyType = UIReturnKeySearch;
//    
//    [view addSubview:self.searchTxt];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithCustomView:view];
    
//    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"取消" handler:^(id sender) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
      self.navigationItem.title = @"预约顾问";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)loadNewData{
    [self.propertyArr removeAllObjects];
    
    self.skip = @"0";
    
    [self loadData];
}
-(void)loadMoreData{
    
//    NSInteger page = [self.skip integerValue];
    
    self.skip = [NSString stringWithFormat:@"%d",[self.skip intValue]+[self.limits intValue]];
    [self loadData];
}

-(void)loadData{
    
    
    //    Community *community = [STICache.global objectForKey:@"selected_community"];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    PropertyListAPI *propertyConstulant = [[PropertyListAPI alloc]initWithCommunityId:@"" ProjectId:self.houseModel.project_id keyword:@"" limit:self.limits skip:self.skip];
    propertyConstulant.employeeType = EMPLOYEELISTTYPE;
    [propertyConstulant startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            NSArray *list = content[@"employees"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    PropertyConstrulantModel *consultantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
                    [self.propertyArr addObject:consultantModel];
                }
            }
            
            if (list.count < [self.limits intValue]) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }
            
            if (self.propertyArr.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            
            [self.tv reloadData];
            
        }else{
            
            if (self.propertyArr.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            
            [self.tv reloadData];
            [self presentFailureTips:result[@"message"]];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (self.propertyArr.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }
        
        [self.tv reloadData];
        
        [self doneLoadingTableViewData];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
}

#pragma mark-tableView delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.propertyArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BindingPropertyConstrulantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingPropertyConstrulantCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.bindingButton.hidden = YES;
    if (self.propertyArr.count > indexPath.row) {
        PropertyConstrulantModel *consultntModel = self.propertyArr[indexPath.row];
        cell.data = consultntModel;
    }
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.propertyArr.count > indexPath.row) {
        PropertyConstrulantModel *consultntModel = self.propertyArr[indexPath.row];
        
        [UIAlertView bk_showAlertViewWithTitle:@"预约顾问" message:consultntModel.name cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                [self fk_postNotification:@"SELECTCUSSESS" object:consultntModel];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }];
    }
}

#pragma mark -
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
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
