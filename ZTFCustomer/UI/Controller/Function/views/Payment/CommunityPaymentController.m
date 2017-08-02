//
//  CommunityPaymentController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CommunityPaymentController.h"
#import "PropertyAddressCell.h"
#import "SelectedCommunityController.h"

@interface CommunityPaymentController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation CommunityPaymentController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirmButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.confirmButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self setnavigationBar];
    [self.tv registerNib:@"PropertyAddressCell"];
    [self.tv tableViewRemoveExcessLine];
    [self loadData];
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
    
    self.navigationItem.title = @"选择地址";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"f1_icon_delete"] handler:^(id sender) {
        [self.tv setEditing:!self.tv.isEditing animated:YES];
    }];
}

-(NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

-(void)loadData{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    PaymentAddressListAPI *paymentAddressListApi = [[PaymentAddressListAPI alloc]init];
    [paymentAddressListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        [self.itemsArray removeAllObjects];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                PaymentAddressModel *paymentAddressModel = [PaymentAddressModel mj_objectWithKeyValues:dic];
                [self.itemsArray addObject:paymentAddressModel];
            }
            if (self.itemsArray.count == 0) {
                self.emptyView.hidden = NO;
                self.tv.hidden = YES;
            }else{
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }
            [self.tv reloadData];
            
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

#pragma mark-click
//添加新地址
- (IBAction)confirmBtnClick:(id)sender {
    
    SelectedCommunityController *selectedCommunity = [SelectedCommunityController spawn];
    [self.navigationController pushViewController:selectedCommunity animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyAddressCell" forIndexPath:indexPath];
   
    if (self.itemsArray.count > indexPath.row) {
        PaymentAddressModel *payMentAddress = self.itemsArray[indexPath.row];
        cell.data = payMentAddress;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch ( self.paymentType )
//    {
//        case PAYMENT_TYPE_PROPERTY:
//        {
//            if ( self.didSelect )
//            {
//                ADDRESS * address = self.model.items[indexPath.row];
//                self.didSelect(address);
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            break;
//        }
//        case PAYMENT_TYPE_MANAGEMENT:
//        {
//            if ( self.didSelect )
//            {
                PaymentAddressModel * address = self.itemsArray[indexPath.row];
                self.didSelect(address);
                [self.navigationController popViewControllerAnimated:YES];
//            }
//            break;
//        }
//        case PAYMENT_TYPE_PARKING:
//        {
//            if ( self.didSelect )
//            {
//                PARKINGADDRESSDATA * address = self.model.items[indexPath.row];
//                self.didSelect(address);
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            break;
//        }
//        default:
//            break;
//    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        [self deleteAddressForIndexPath:indexPath];
    }
}


-(void)deleteAddressForIndexPath:(NSIndexPath *)indexPath{
    
    PaymentAddressModel *payMentAddress = self.itemsArray[indexPath.row];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    DeleteAddressAPI  *deleteAddresApi = [[DeleteAddressAPI alloc]initWithAddressId:payMentAddress.id];
    [deleteAddresApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self loadData];
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
