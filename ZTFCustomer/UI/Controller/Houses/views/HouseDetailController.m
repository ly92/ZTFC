//
//  HouseDetailController.m
//  ztfCustomer
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseDetailController.h"
#import "MorewHouseTypeController.h"
#import "HouseTypeDetailController.h"
#import "SurroundingViewController.h"
#import "SubscribeMerchantViewController.h"
#import "HouseTypeCollectionCell.h"
#import "HouseBookController.h"
#import "MWPhotoBrowser.h"
@interface HouseDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headScrollViewWidth;
//@property (weak, nonatomic) IBOutlet UIView *headScroolContainerView;

@property (weak, nonatomic) IBOutlet UIView *pageControlView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLblheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;



@property (weak, nonatomic) IBOutlet UILabel *introductionLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionViewHeight;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseTypeViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLbl;
@property (weak, nonatomic) IBOutlet UIButton *moreHouseTypeButoon;
@property (weak, nonatomic) IBOutlet UIButton *GPSButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *headImageArr;
@property (nonatomic, strong) NSMutableArray *houseTypeDataArr;

@property (nonatomic, strong) HousesModel *houseDetailModel;
@property (nonatomic, strong) NSMutableArray *mwPhotoArray;

@property (nonatomic, assign) NSInteger cancelInt;
@property (nonatomic, assign) NSInteger currentHousetypeRow;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, strong) PropertyConstrulantModel *propertyConstrulantModel;

@end

@implementation HouseDetailController

+(instancetype)spawn{
    return [HouseDetailController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    [self.GPSButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.callButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self.bookButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self.moreHouseTypeButoon setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
    self.headViewHeight.constant = (SCREENWIDTH *450)/750;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HouseTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HouseTypeCollectionCell"];
      self.pageControlView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    //未选中的点颜色
    self.pageControl.pageIndicatorTintColor = PAGECONTROL_UNSELECT_COLOR;
    //当前选中的点的颜色
    self.pageControl.currentPageIndicatorTintColor = PAGECONTROL_SELECT_COLOR;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREENWIDTH-40)/3.0;
    layout.itemSize = CGSizeMake(width, width+70);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectButton buttonSetTitle:@"收藏" imageStr:@"house_collect" selectImageStr:@"house_collect_pre" imagePosition:RIGHTSTYLE];
    

    //加载数据
    if (self.data) {
        self.project_id = (NSString *)self.data;
        [self loadData];
    }else{
        self.project_id = self.houseModel.project_id;
       [self loadData];
    }
    [self loadPropertyConsultane];
    [self fk_observeNotifcation:@"OPERATEHOUSETYPESUCCESS" usingBlock:^(NSNotification *note) {
        [self loadData];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        if (self.isCollect) {
            if (self.cancelInt == 1) {
                //重新收藏
                 [self fk_postNotification:@"COLLECTSUCCESS" object:self.houseModel];
                
            }else if(self.cancelInt == 2){
                //取消收藏
                 [self fk_postNotification:@"CANCELCOLLECTSUCCESS" object:self.houseModel];
                
            }
           
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"house_share"] handler:^(id sender) {
        
        [self myShare];
        
    }];
}
#pragma mark - 初始化
-(NSMutableArray *)houseTypeDataArr{
    if (!_houseTypeDataArr) {
        _houseTypeDataArr = [NSMutableArray array];
    }
    return _houseTypeDataArr;
}

#pragma mark - 初始化
-(NSMutableArray *)mwPhotoArray{
    if (!_mwPhotoArray) {
        _mwPhotoArray = [NSMutableArray array];
    }
    return _mwPhotoArray;
}

#pragma mark - setHeadScrollView
-(void)setHeadscrollView{
    
    if (self.headImageArr.count > 0 ) {
        
        ResourceModel *resourceModel = self.headImageArr[self.headImageArr.count-1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.tag = 100+self.headImageArr.count -1;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvClick:)];
        [imageView addGestureRecognizer:tap];
        
        [self.headScrollView addSubview:imageView];
    }
    
    
    for (int i=0; i<self.headImageArr.count; i++) {
         ResourceModel *resourceModel = self.headImageArr[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*(i+1), 0, SCREENWIDTH, self.headViewHeight.constant)];
        
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvClick:)];
        [imageView addGestureRecognizer:tap];
        [self.headScrollView addSubview:imageView];
        
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:resourceModel.url]];
        [self.mwPhotoArray addObject:photo];
        
    }
    if (self.headImageArr.count > 0) {
         ResourceModel *resourceModel = self.headImageArr[0];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.headImageArr.count + 1)*SCREENWIDTH , 0, SCREENWIDTH, self.headViewHeight.constant)];
        [imageView setImageWithURL:[NSURL URLWithString:resourceModel.url] placeholder:[UIImage imageNamed:@"house_detail_noimage"]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvClick:)];
        [imageView addGestureRecognizer:tap];
        [self.headScrollView addSubview:imageView];
    }
    self.headScrollView.contentSize = CGSizeMake(SCREENWIDTH*(self.headImageArr.count+2), 0);
    self.headScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    self.pageControl.numberOfPages = self.headImageArr.count;
    [self setupTimer];
    
}

//图片点击
-(void)imgvClick:(UITapGestureRecognizer *)tap{
    
    // 预览照片
    
    MWPhotoBrowser *mwPhoto = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    mwPhoto.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    mwPhoto.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    mwPhoto.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    mwPhoto.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    mwPhoto.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    mwPhoto.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    mwPhoto.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    //    mwPhoto.autoPlayOnAppear = NO;
    
    [mwPhoto setCurrentPhotoIndex:self.pageControl.currentPage];
    
    [self.navigationController pushViewController:mwPhoto animated:YES];
    
    
}

#pragma mark - loadData
-(void)loadData{
    
    if (!self.project_id) {
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    [self presentLoadingTips:nil];
    HouseDetailAPI *houseDetailApi = [[HouseDetailAPI alloc]initWithHoustId:self.project_id];
    [houseDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"result"] intValue] == 0) {
            
            self.houseDetailModel = [HousesModel mj_objectWithKeyValues:content[@"project"]];
            NSArray *houseTypes = content[@"houseTypes"];
            for (NSDictionary *dic in houseTypes) {
                HouseTypeModel *houseTypeModel = [HouseTypeModel mj_objectWithKeyValues:dic];
                houseTypeModel.mobile = self.houseDetailModel.tel;
                [self.houseTypeDataArr addObject:houseTypeModel];
            }
            [self prepareData];
            
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
-(void)loadPropertyConsultane{
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
//    UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    
    PropertyConstulantAPI *propertyConstulantApi = [[PropertyConstulantAPI alloc]initWithProjectId:self.project_id communityId:@"" key:@"" skip:@"0" limit:@"10000"];
    propertyConstulantApi.propertyType = ISBINDPROPERTY;
    [propertyConstulantApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            
            NSArray *arr = content[@"employee"];
            if (arr.count > 0) {
                NSDictionary *dic = arr[0];
                self.propertyConstrulantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
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
-(void)prepareData{
    
    self.headImageArr = self.houseDetailModel.album.resources;
    [self setHeadscrollView];
    
    if (self.houseDetailModel) {
        //判断是否已被收藏
        NSInteger status = [self.houseDetailModel.is_favorite integerValue];
        if (status == 0) {
            //未收藏
            self.collectButton.selected = NO;

        }else{
            //已收藏
            self.collectButton.selected = YES;
        }
        
        self.communityNameLbl.text = self.houseDetailModel.name;
        self.addressLbl.text = self.houseDetailModel.address;
        
        CGSize addressSize = [self.addressLbl sizeThatFits:CGSizeMake(SCREENWIDTH-110, MAXFLOAT)];
        if (addressSize.height > 20) {
            self.addressLblheight.constant = addressSize.height;
        }else{
            self.addressLblheight.constant = 20;
        }
        self.addressViewHeight.constant = 70 - 20 +self.addressLblheight.constant;
        
        self.priceLbl.text = [NSString stringWithFormat:@"%@元／㎡起",self.houseDetailModel.average_price];
        self.mobileLbl.text = self.houseDetailModel.tel;
        
        self.introductionLbl.text = self.houseDetailModel.intro;
        
        CGFloat introductionHeight = [self.introductionLbl resizeHeight];
        
        if (introductionHeight > 20) {
            self.introductionLblHeight.constant = introductionHeight;
        }else{
            self.introductionLblHeight.constant = 20;
        }
        
        self.introductionViewHeight.constant = 40 -20 + self.introductionLblHeight.constant;
        
        
        CGFloat width = (SCREENWIDTH-40)/3.0;
        
        self.collectionViewHeight.constant = width + 70;
        
        if (self.houseTypeDataArr.count == 0){
            self.moreHouseTypeButoon.hidden = YES;
            self.houseTypeLbl.hidden = YES;
            self.houseTypeViewHeight.constant =  0;
            
        }
//        else  if (self.houseTypeDataArr.count <= 3){
//            self.moreHouseTypeButoon.hidden = YES;
//            self.houseTypeViewHeight.constant =  160 - 66 + self.collectionViewHeight.constant-30;
//            
//            
//        }
        else{
            self.moreHouseTypeButoon.hidden = NO;
            self.houseTypeLbl.hidden = NO;
            self.houseTypeViewHeight.constant =  160 - 66 +self.collectionViewHeight.constant;
        }
        
        //如果户型的个数<=3, 隐藏“更多户型 >”
        
        [self.collectionView reloadData];
        self.containerViewHeight.constant = 650-200 + self.headViewHeight.constant - 70 + self.addressViewHeight.constant - 40 +self.introductionViewHeight.constant - 160 + self.houseTypeViewHeight.constant;
        
    }
}


#pragma mark - share
-(void)myShare{
    NSArray * imageArray = nil;
    //1、创建分享参数
    if (self.headImageArr.count > 0) {
        ResourceModel *resourceModel = self.headImageArr[0];
        imageArray = @[[NSURL URLWithString:resourceModel.url]];
    }else{
        imageArray = @[[UIImage imageNamed:@"appicon"]];
    }
    
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance]getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *name = @"";
    if ([tUserDetail.realname trim].length>0) {
        name = tUserDetail.realname;
    }
    else{
        name = tUserDetail.loginname;
    }
    
    NSString *cShareTitle = self.houseModel.name;
    
    NSString *cShareContent =self.houseModel.intro;
    
    NSString *employeeId = @"";
    if (self.propertyConstrulantModel) {
        employeeId = self.propertyConstrulantModel.id;
    }
    //@"http://app.kakatool.cn/app.php?appid=%@",APP_ID
    //http://crcc.kakatool.cn:2016/share/houses.html?appid=%@&userid=%@
    NSString *cShareurl = [NSString stringWithFormat:@"http://crcc.kakatool.cn:2016/share/houses.html?appid=%@&userid=%@&project_id=%@&platform=%@&employee_id=%@",APP_ID,tUserDetail.cid,self.houseModel.project_id,APP_PLATFORM,@""];
    NSURL *shareUrl = [NSURL URLWithString:cShareurl];
    
    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,shareUrl];
    NSString *cShareAllContent = [NSString stringWithFormat:@"%@",cShareTheme];
    
    //构造分享内容
    //常见分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    //允许跳转到客户端分享(如果不跳转到客户端分享，在未审核通过的时候需要把微博账号添加成为测试账号，否则分享不成功，会出现来回跳转的问题)
    [shareParams SSDKEnableUseClientShare];
    
    [shareParams SSDKSetupShareParamsByText:cShareAllContent
                                     images:imageArray
                                        url:shareUrl
                                      title:cShareTitle
                                       type:SSDKContentTypeAuto];
    
    //定义菜单分享列表
    [ShareSDK showShareActionSheet:nil
                             items:@[
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   if (state == SSDKResponseStateSuccess)
                   {
                       [self presentSuccessTips:@"分享成功"];
                   }
                   else if (state == SSDKResponseStateFail)
                   {
                       [self presentFailureTips:@"分享失败,请重试"];
                       
                   }
                   
               }];
    
}

#pragma mark - click

//收藏点击
- (IBAction)collectClick:(id)sender {
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    //        [self presentLoadingTips:nil];
    //网络请求，点击喜欢
    HouseDetailAPI *collectApi = [[HouseDetailAPI alloc]initWithHoustId:self.houseDetailModel.project_id];
    NSInteger status = [self.houseDetailModel.is_favorite integerValue];
    
    if (status == 0){
        collectApi.operateHouse = COLLECTHOUSE;
    }else{
        collectApi.operateHouse = CANCELCOLLECTHOUSE;
    }
    
    [collectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0)
         
        {
            NSInteger status = [self.houseDetailModel.is_favorite integerValue];
            if (status == 0) {
                 [self presentSuccessTips:@"收藏楼盘成功"];
               //重新收藏
                self.cancelInt = 1;
                self.houseDetailModel.is_favorite = @"1";
                self.houseDetailModel.favorites = [content objectForKey:@"favorite"];
               
                self.collectButton.selected = YES;
                
            }else{
                [self presentSuccessTips:@"取消收藏楼盘"];
                //取消
                self.cancelInt = 2;
                self.houseDetailModel.is_favorite = @"0";
                self.houseDetailModel.favorites = [content objectForKey:@"favorite"];
                self.collectButton.selected = NO;
                
            }
            self.houseDetailModel.is_favorite = self.houseDetailModel.is_favorite;
            self.houseDetailModel.favorites = self.houseDetailModel.favorites;
            
            if (self.isHouseList) {
                [self fk_postNotification:@"OPERATECOLLECTSUCCESS" object:@[self.indexPath,self.houseDetailModel]];
            }
            
            if (!self.isCollect && !self.isHouseList) {
                [self fk_postNotification:@"HOMECOLLECTSUCCESS"];
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


//导航
- (IBAction)navigateButtonClick:(id)sender {
    // 需要经纬度
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.houseDetailModel.lat doubleValue], [self.houseDetailModel.lng doubleValue]) addressDictionary:nil]];
    toLocation.name = self.houseDetailModel.address;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
}

//呼叫
- (IBAction)callButtonClick:(id)sender {
    
    [UIAlertView bk_showAlertViewWithTitle:@"确定拨打电话" message:self.houseDetailModel.tel cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //拨打电话
            NSString *tel = [NSString stringWithFormat:@"tel://%@",self.houseDetailModel.tel];
            NSURL *callUrl = [NSURL URLWithString:tel];
            
            if ([[UIApplication sharedApplication]canOpenURL:callUrl]) {
                
            }else{
                [self presentFailureTips:@"不支持此功能"];
            }
        }

    }];
    
    
}

// 预约
- (IBAction)bookButtonClick:(id)sender {
    
    
    HouseBookController *houseBook = [HouseBookController spawn];
    
    houseBook.houseModel = self.houseDetailModel;
//    houseBook.bid = self.houseDetailModel.id;
//    houseBook.tel = self.houseDetailModel.phone;
    
     [self.navigationController pushViewController:houseBook animated:YES];
    

}
//周边
- (IBAction)surroundingClick:(id)sender {
    
    SurroundingViewController *surrounding = [SurroundingViewController spawn];
    
    surrounding.isHouseDetail = YES;
    surrounding.communityId = self.houseDetailModel.community_id;
    [self.navigationController pushViewController:surrounding animated:YES];
    
}


//更多户型
- (IBAction)moreHouseTypeButtonClick:(id)sender {
   
    MorewHouseTypeController *moreHouseType = [MorewHouseTypeController spawn];
    
    moreHouseType.projectModel = self.houseDetailModel;
    
    
    [self.navigationController pushViewController:moreHouseType animated:YES];
    
}


#pragma mark - collectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.houseTypeDataArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HouseTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseTypeCollectionCell" forIndexPath:indexPath];
    
    if (self.houseTypeDataArr.count > indexPath.row) {
        cell.data = self.houseTypeDataArr[indexPath.row];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.houseTypeDataArr.count > indexPath.row) {
        HouseTypeModel *houseTypeModel = self.houseTypeDataArr[indexPath.row];
        HouseTypeDetailController *houseTypeDetail = [HouseTypeDetailController spawn];
        houseTypeDetail.projectId = self.houseDetailModel.project_id;
        houseTypeDetail.houseTypeModel = houseTypeModel;
        [self.navigationController pushViewController:houseTypeDetail animated:YES];
    }
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != self.headScrollView) {
        return;
    }
    
    //开始拖动scrollview的时候 停止计时器控制的跳转
    if (self.timer&&[self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer=nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger total = self.headImageArr.count;
    
    NSInteger page = floor((scrollView.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
//     NSInteger screenpage = page;
    NSInteger offset = scrollView.contentOffset.x;
    
    NSInteger offpage = offset/SCREENWIDTH;
    
    if ( offpage < 1) {
        page = total;
    }
    if (offpage > total) {
        page = 1 ;
    }
//    [self.headScrollView setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.headScrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    self.pageControl.currentPage = page-1 ;
    
//    self.pageControl.currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
}

#pragma mark - 轮播
- (void)setupTimer{
    //开始定时
    if (self.timer&&[self.timer isValid]) {
        [self.timer invalidate];
    }
    if (self.headImageArr.count>0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoSlide:) userInfo:nil repeats:YES];
    }
}

-(void)autoSlide:(id)sender
{
    NSUInteger total = self.headImageArr.count;
    int page = floor((self.headScrollView.contentOffset.x - SCREENWIDTH / 2) / SCREENWIDTH) + 1;
    page ++;
     int screenpage = page;
    if (page > total){
        page = 1;
    }
    [self.headScrollView setContentOffset:CGPointMake(screenpage * SCREENWIDTH, 0) animated:YES];
    self.headScrollView.contentOffset = CGPointMake((page-1) * SCREENWIDTH, 0);
    self.pageControl.currentPage = page - 1;
}

#pragma mark - MWPhotoDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mwPhotoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mwPhotoArray.count) {
        return [self.mwPhotoArray objectAtIndex:index];
    }
    return nil;
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
