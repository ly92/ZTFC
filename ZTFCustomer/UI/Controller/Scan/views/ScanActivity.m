//
//  ScanActivity.m
//  gaibianjia
//
//  Created by PURPLEPENG on 9/17/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//  扫一扫

#import "ScanActivity.h"
#import "ScanView.h"

#import "OpenSuccessViewController.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"
#import "WebViewController.h"
#import "OtherViewController.h"
#import "GetCouponController.h"
#import "PropertyConstrulantDetailController.h"
#import "DropPayController.h"

//#import "WebViewPhotoModel.h"
//#import "OtherViewController.h"
//#import "AddMemberModel.h"
//#import "CarddetailViewController.h"
//#import "CardDetailNotMerberViewController.h"
//#import "GetCouponController.h"
//#import "SurroundDetailModel.h"
//#import "CardDetailNotMerberViewController.h"
//#import "PayController.h"
//#import "MallOrderModel.h"

//#import "ZXCapture.h"
//#import "ZXResult.h"
//#import "ZXCaptureDelegate.h"

//, ZXCaptureDelegate
@interface ScanActivity () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    AVCaptureDevice * device;
}
@property (weak, nonatomic) IBOutlet ScanView *scanView;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
- (IBAction)flashlightAction:(UIButton *)sender;

//推荐人的cid
@property (copy, nonatomic) NSString *recommendId;
@property (nonatomic,retain) NSString *fakeBid;
@property (nonatomic,retain) NSString *fakeTcid;

@property (retain,nonatomic) NSString *transType;

//@property (strong, nonatomic) AddMemberModel *addMemberModel;
//@property (strong, nonatomic) AddMemberModel *consumeModel1;
//@property (strong, nonatomic) AddMemberModel *consumeModel2;
//@property (strong, nonatomic) AddMemberModel *drawCardModel;
//@property (strong, nonatomic) SurroundDetailModel *detailModel;

//@property (nonatomic,strong) MallOrderModel *model;
//
//@property (nonatomic, strong) ZXCapture * capture;

@property (nonatomic, assign) BOOL isViewDidAppear;

//@property (nonatomic, copy) NSString *scanValue;


@end

@implementation ScanActivity

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = @"扫一扫";
//    [self.navigationController enabledMLBlackTransition:NO];
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        @strongify(self);
        if ( self.flashlightButton.selected )
        {
            [self flashlightAction:self.flashlightButton];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if ( GT_IOS7)
    {
        [self setupSession];
    }
    else
    {
        //获取摄像设备
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        self.capture = [[ZXCapture alloc] init];
//        self.capture.camera = self.capture.back;
//        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
//        self.capture.rotation = 90.0f;
//        self.capture.delegate = self;
//        self.capture.layer.frame = self.scanView.bounds;
//        [self.scanView.layer addSublayer:self.capture.layer];
    }
    
    [self fk_observeNotifcation:UIApplicationDidBecomeActiveNotification usingBlock:^(NSNotification *note) {
        if ( self.scanView )
        {
            if (GT_IOS7)
            {
                [self.scanView startAnimation];
            }
        }
        
        if ( self.flashlightButton.selected )
        {
            [self flashlightAction:self.flashlightButton];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCapture];
    
    if ( self.flashlightButton.selected )
    {
        [self flashlightAction:self.flashlightButton];
    }
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
   
}

//- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
//{
//    if ( !self.isViewDidAppear )
//    {
//        return;
//    }
//    
//    if (!result)
//    {
//        return;
//    }
//    
//    if ( capture.running == NO )
//    {
//        [self handleUrl:result.text];
//        
//        NSLog(@"---  result = %@  ---", result.text);
//    }
//    
//    [capture hard_stop];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isViewDidAppear = YES;
    
    if ( GT_IOS7 )
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status) {
            case AVAuthorizationStatusAuthorized:
            {
                [self.scanView startAnimation];
                break;
            }
            default:
                break;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.scanView stopAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)setupSession
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:
        {
            //获取摄像设备
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            //创建输出流
            AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            //初始化链接对象
            session = [[AVCaptureSession alloc]init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            
            [session addInput:input];
            [session addOutput:output];
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            output.rectOfInterest = CGRectMake( 0.15, 0.15, 0.7, 0.7 );
            
            AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    layer.frame = self.view.layer.bounds;
            layer.frame = [[UIScreen mainScreen] bounds];
            [self.view.layer insertSublayer:layer atIndex:0];
            break;
        }
        case AVAuthorizationStatusDenied:
            [self setupDenied];
            break;
        case AVAuthorizationStatusNotDetermined:
            [self setupNotDetermined];
            break;
        default:
            break;
    }
}

- (void)startCapture
{
    //开始捕获
    [session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( metadataObjects.count > 0 )
    {
        [session stopRunning];
        [self.scanView stopAnimation];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0 ];
        //输出扫描字符串
//        NSLog(@"%@",metadataObject.stringValue);
        [self handleUrl:metadataObject.stringValue];
       
    }
}
#pragma mark-handleurl
- (void)handleUrl:(NSString *)url
{
//        [[RootController sharedInstance] handleUrl:url in:self];
    NSURL *paraUrl =nil;
    @try {
        paraUrl = [NSURL URLWithString:url];
    }
    @catch (NSException *exception) {
        paraUrl=nil;
    }
    @finally {
        
    }
    
    NSMutableDictionary *urlParams = [self getUrlParameters:paraUrl];
    
    if ( self.whenGetScan )
    {
        self.whenGetScan(url);
        
        NSString *scanValue = url;
        
        //门禁规则
        if ([[scanValue lowercaseString] containsString:@"http://kkt.me/dr/"]) {
            
            NSString *qrcode = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/dr/" withString:@""];
            
            if (qrcode==nil||[qrcode trim].length == 0 ) {
                [self presentFailureTips:@"无效门禁"];
                return;
            }else {
                
                OpenSuccessViewController *openSuccess = [[OpenSuccessViewController alloc]initWithQrcodeByNet:qrcode];
                
                //        openSuccess.entranceGuard = self.entranceGuard;
                [self.navigationController pushViewController:openSuccess animated:YES];
                
                return;
            }
            
//            [self handleEntranceGuard:scanValue];
            
            return;
            
        }
        
        //蓝牙门禁规则
        if ([[scanValue lowercaseString] containsString:@"http://kkt.me/drb/"]) {
            
            NSString *qrcode = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/drb/" withString:@""];
            
            if (qrcode==nil||[qrcode trim].length == 0 ) {
                [self presentFailureTips:@"无效门禁"];
                return;
            }
            else {
                OpenSuccessViewController *openSuccess = [[OpenSuccessViewController alloc]initWithQrcodebyBle:qrcode];
                
                //        openSuccess.entranceGuard = self.entranceGuard;
                [self.navigationController pushViewController:openSuccess animated:YES];
                
                return;
            }

            
//            [self handleBluetooth:scanValue];
            return;
        }
        
        //C端扫描自动售货机二维码
        //http://kkt.me/mall/?bid=xxx&tnum=xxxx&money=xxx&content=xxx&device=xxxxxx
        if ([[scanValue lowercaseString] containsString:@"http://kkt.me/mall/?"] || [[scanValue lowercaseString] containsString:@"http://kkt.me/mall/"]) {
            
            
            NSString *parameters  = nil;
            
            if ([[scanValue lowercaseString] containsString:@"http://kkt.me/mall/?"]) {
                parameters = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/mall/?" withString:@""];
            }else if([[scanValue lowercaseString] containsString:@"http://kkt.me/mall/"]){
                parameters = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/mall/" withString:@""];
            }
            
            NSArray *params = [parameters componentsSeparatedByString:@"&"];
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            for (NSString *param in params) {
                NSArray *paramCell = [param componentsSeparatedByString:@"="];
                [paramsDict setObject:paramCell[1] forKey:paramCell[0]];
            }
            
            //                NSString *bid = [paramsDict objectForKey:@"bid"];
            //            NSString *tnum = [paramsDict objectForKey:@"tnum"];
            //            NSString *money = [NSString stringWithFormat:@"%.2f",[[paramsDict objectForKey:@"money"] doubleValue]];
            //            NSString *content = [paramsDict objectForKey:@"content"];
            //            NSString *dev = [paramsDict objectForKey:@"device"];
            
            //            self.model = [[MallOrderModel alloc] init];
            //            @weakify(self);
            //            [self.model getMallOrderWithTnum:tnum Money:money Device:dev then:^(STIHTTPResponseError *e) {
            //                @strongify(self);
            //                if (!e && [self.model.result intValue] == 0){
            //                    CashierViewController *cash = [CashierViewController spawn];
            //                    cash.sn = self.model.tnum;
            //                    cash.isEParking = NO;
            //                    cash.isFromHtml = NO;
            //                    cash.isFromScan = YES;
            //                    cash.content = content;
            //                    cash.cSn = tnum;
            //
            //                    [self.navigationController pushViewController:cash animated:YES];
            //
            //                }else{
            //                    [self presentFailureTips:@"扫描失败，请重新扫描"];
            //                    if ( self.flashlightButton.selected )
            //                    {
            //                        [self flashlightAction:self.flashlightButton];
            //                    }
            //                    [self.navigationController popViewControllerAnimated:YES];
            //                }
            //
            //            }];
            return;
            
//            [self handleVendingMachine:scanValue];
            return;
            
        }
        
        if ([APP_ID isEqualToString:@"124"]) {
            //扫码铁豆支付
            if ([scanValue containsString:@"http://app.kakatool.cn/app.php?appid=124&B="]) {
                
                NSString *bid = [scanValue stringByReplacingOccurrencesOfString:@"http://app.kakatool.cn/app.php?appid=124&B=" withString:@""];
                
                if (bid==nil||[bid trim].length == 0 ) {
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:@"请确认商户二维码"];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                else {
                    
                    DropPayController *dropPayVC = [DropPayController spawn];
                    dropPayVC.bid = bid;
                    [self.navigationController pushViewController:dropPayVC animated:YES];
                    
                    return;
                }
                
                
                //                      [self handleBluetooth:scanValue];
                return;
            }
        }
        
        
        //扫码添加会员，绑定置业顾问
        //http://app.kakatool.cn/app.php?appid=202&employee_id=xxx&project_id=xxxx
        
        if ([[scanValue lowercaseString] containsString:@"http://app.kakatool.cn/app.php?"] && [[scanValue lowercaseString] containsString:@"employee_id"] ) {
            
            
            NSString *parameters = [scanValue stringByReplacingOccurrencesOfString:@"http://app.kakatool.cn/app.php?" withString:@""];
            
            NSArray *params = [parameters componentsSeparatedByString:@"&"];
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            for (NSString *param in params) {
                NSArray *paramCell = [param componentsSeparatedByString:@"="];
                [paramsDict setObject:paramCell[1] forKey:paramCell[0]];
            }
            
            NSString *emolyeeName = paramsDict[@"employee_name"];
            NSString *employeeId = paramsDict[@"employee_id"];
            NSString *projectId = paramsDict[@"project_id"];
            
            
            [self presentLoadingTips:nil];
            [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
//            UserModel *userModel = [[LocalData shareInstance]getUserAccount];
//            Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
            
            PropertyConstulantAPI *propertyConstulantApi = [[PropertyConstulantAPI alloc]initWithProjectId:projectId communityId:@"" key:@"" skip:@"0" limit:@"10000"];
            propertyConstulantApi.propertyType = ISBINDPROPERTY;
            [propertyConstulantApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                [self dismissTips];
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSDictionary *content = result[@"content"];
                if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                    
                    NSArray *arr = content[@"employee"];
                    if (arr.count > 0) {
                        NSDictionary *dic = arr[0];
                       PropertyConstrulantModel *propertyConstrulantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
                        if ([propertyConstrulantModel.id isEqualToString:employeeId]) {
                            
                            PropertyConstrulantDetailController *propertyConsultantDetainCon = [PropertyConstrulantDetailController spawn];
                            propertyConsultantDetainCon.communityId = propertyConstrulantModel.project.community_id;
                            propertyConsultantDetainCon.propertyModel = propertyConstrulantModel;
                            //取消绑定置业顾问成功
                            propertyConsultantDetainCon.cancelBindingBlock = ^(){
                                //获取置业顾问数据，刷新列表
                                
                                
                            };
                            [self.navigationController pushViewController:propertyConsultantDetainCon animated:YES];

                        }else{
                            [UIAlertView bk_showAlertViewWithTitle:@"是否绑定顾问" message:emolyeeName cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    [self loadPropertyModelWithEmployeeId:employeeId ProjectId:projectId];
                                }else{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                            }];
                        }
                        
                    }else{
                        [UIAlertView bk_showAlertViewWithTitle:@"是否绑定顾问" message:emolyeeName cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                [self loadPropertyModelWithEmployeeId:employeeId ProjectId:projectId];
                            }else{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }];
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
            
            return;
            
        }
        
        
        
        
        
        //处理领取优惠券
//        [self handleCoupon:scanValue];
        
//        if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"COUPON"]&&[urlParams allKeys].count==2) {
//            
//            NSString *bid = [urlParams objectForKey:@"B"];
//            NSString *couponid = [urlParams objectForKey:@"COUPON"];
//            if (![bid isNumText] || [couponid trim].length == 0) {
//                [SVProgressHUD showErrorWithStatus:@"无法识别"];
//                return;
//            }
//            
//            GetCouponController *getCoupon = [[GetCouponController alloc] initWithBid:bid couponId:couponid];
//            getCoupon.entranceGuard = self.entranceGuard;
//            [self.navigationController pushViewController:getCoupon animated:YES];
//            
//            return;
//        }
        
        //处理加会员，消费
//        [self handleOther:scanValue];
        
        
        
        int type = -1;
        NSString *numStr = @"";
        NSString *cId = @"";
        
        //C端扫描优惠券二维码，领取优惠券
        //"http://www.kakatool.com/?B=%@&COUPON=%@"
        //corp/qrcode
        if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"COUPON"]&&[urlParams allKeys].count==2) {
            
            NSString *bid = [urlParams objectForKey:@"B"];
            NSString *couponid = [urlParams objectForKey:@"COUPON"];
            if (![bid isNumText] || [couponid trim].length == 0) {
                 [self presentFailureTips:@"无法识别"];
                return;
            }
            
            GetCouponController *getCoupon = [[GetCouponController alloc] initWithBid:bid couponId:couponid];
            getCoupon.entranceGuard = self.entranceGuard;
            [self.navigationController pushViewController:getCoupon animated:YES];
            
            return;
        }
        
        //C端扫描B端加会员
        if ([[urlParams allKeys] containsObject:@"B"]&&[urlParams allKeys].count==1) {
            type=1;
            numStr = [urlParams objectForKey:@"B"];
            if (![numStr isNumText]) {
                //                [self presentFailureTips:@"无法识别"];
                return;
            }
            
        }
        
        //C端扫描C端推荐加会员
        if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"C"]&&[urlParams allKeys].count==2) {
            type=1;
            numStr = [urlParams objectForKey:@"B"];
            cId = [urlParams objectForKey:@"C"];
            if ([numStr isNumText] && [cId isNumText]) {
                self.recommendId = cId;
            }
            else {
                //                [self presentFailureTips:@"无法识别"];
                return;
            }
            
        }
        
        //金钱二维码交易
        if ([[urlParams allKeys] containsObject:@"T"]&&[urlParams allKeys].count==1) {
            
            type=2;
            numStr = [urlParams objectForKey:@"T"];
        }
        //新增交易
        if ([[urlParams allKeys] containsObject:@"Q"]&&[urlParams allKeys].count==1) {
            type=5;
            numStr = [urlParams objectForKey:@"Q"];
        }
        
        //积分二维码交易
        if ([[urlParams allKeys] containsObject:@"P"]&&[urlParams allKeys].count==1) {
            type=4;
            numStr = [urlParams objectForKey:@"P"];
        }
        
        //领卡操作
        if ([[urlParams allKeys] containsObject:@"I"]&&[[urlParams allKeys] containsObject:@"F"]&&[urlParams allKeys].count==2) {
            
            // NSLog(@"scan:%@",result);
            type=3;
            self.fakeBid = [urlParams objectForKey:@"I"];
            self.fakeTcid = [urlParams objectForKey:@"F"];
            
            if (![self.fakeBid isNumText] || ![self.fakeTcid isNumText]) {
                
                //                [self presentFailureTips:@"无法识别"];
                return;
            }
        }
        
       
        //处理非kakatool链接
        if ([[scanValue lowercaseString] containsString:@"kakatool.com"] == NO) {
            
            
//            NSURL *url =nil;
//            @try {
//                url = [NSURL URLWithString:scanValue];
//            }
//            @catch (NSException *exception) {
//                url=nil;
//            }
//            @finally {
//                
//            }
            
            if ([scanValue isURL]) {
                //若为链接
                NSString *urlStr = [[NSString stringWithString:scanValue] trim];
                NSString *urlHttp = @"http://";
                if (![urlStr hasPrefix:@"http://"]&&![urlStr hasPrefix:@"https://"]) {
                    urlStr = [urlHttp stringByAppendingString:urlStr];
                }
                
                
                WebViewController *web = [WebViewController spawn];
                web.webURL = urlStr;
                web.webTitle = @"";
                [self.navigationController pushViewController:web animated:YES];
                
                return;
            }else if (url == nil&&(![scanValue isURL])) {
                //不是链接跳转到其他界面
                OtherViewController *other = [[OtherViewController alloc]init];
                other.result = scanValue;
                [self.navigationController pushViewController:other animated:YES];
                return;
            }
            
//            [self handleNoKakatool:scanValue];
        }
        
        
        if (type) {
            switch (type) {
                case 1://加会员
                    [self addMember:numStr CID:cId];
                    break;
                case 2://消费
                    self.transType = @"T";
                    [self consume:[NSMutableArray arrayWithObjects:@"T",numStr, nil]];
                    break;
                case 5://理发店消费
                    self.transType = @"T";
                    [self consume:[NSMutableArray arrayWithObjects:@"Q",numStr, nil]];
                    break;
                case 4://积分消费
                    self.transType = @"P";
                    [self consumePoints:numStr];
                    break;
                case 3://领卡
                    [self drawCard:numStr];
                    break;
                case -1://无法识别
                {
                    
                }
                    
                default:
                    break;
            }
            return;
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

//根据顾问ID和小区ID获取顾问信息
-(void)loadPropertyModelWithEmployeeId:(NSString *)employeeId ProjectId:(NSString *)projectId{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    OperatePropertyConstulantAPI *cancelBinding = [[OperatePropertyConstulantAPI alloc]initWithSaleid:employeeId ProjectId:projectId communityId:@""];
    cancelBinding.operateType = BINDING;
    [cancelBinding startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0 ) {
            //绑定成功之后返回的是顾问实体,返回到首页进行获取置业顾问信息显示
            NSDictionary *employee = content[@"employee"];
            PropertyConstrulantModel *employeeModel = [PropertyConstrulantModel mj_objectWithKeyValues:employee];
            
            [self fk_postNotification:@"BingingSuccess" object:employeeModel.community_id];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
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

#pragma mark-解析扫描结果
//解析扫描结果
-(NSMutableDictionary *)getUrlParameters:(NSURL *) url
{
    NSString *string =  [[url.absoluteString stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    
    NSString *temp;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [scanner scanUpToString:@"?" intoString:nil];       //ignore the beginning of the string and skip to the vars
    while ([scanner scanUpToString:@"&" intoString:&temp])
    {
        NSArray *parts = [temp componentsSeparatedByString:@"="];
        if([parts count] == 2)
        {
            [dict setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
        }
    }
    
    return dict;
}

#pragma mark  - 处理各种扫描结果

#pragma mark-处理门禁
-(void)handleEntranceGuard:(NSString *)scanValue{
    NSString *qrcode = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/dr/" withString:@""];
    
    if (qrcode==nil||[qrcode trim].length == 0 ) {
         [self presentFailureTips:@"无效门禁"];
        return;
    }else {
        
        OpenSuccessViewController *openSuccess = [[OpenSuccessViewController alloc]initWithQrcodeByNet:qrcode];
        
//        openSuccess.entranceGuard = self.entranceGuard;
        [self.navigationController pushViewController:openSuccess animated:YES];
        
        return;
    }
}
#pragma mark-蓝牙门禁
-(void)handleBluetooth:(NSString *)scanValue{
    
    NSString *qrcode = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/drb/" withString:@""];
    
    if (qrcode==nil||[qrcode trim].length == 0 ) {
        [self presentFailureTips:@"无效门禁"];
        return;
    }
    else {
        OpenSuccessViewController *openSuccess = [[OpenSuccessViewController alloc]initWithQrcodebyBle:qrcode];
        
//        openSuccess.entranceGuard = self.entranceGuard;
        [self.navigationController pushViewController:openSuccess animated:YES];
        
        return;
    }

}

#pragma mark-自动售货机
-(void)handleVendingMachine:(NSString *)scanValue{
    NSString *parameters  = nil;
    
    if ([[scanValue lowercaseString] containsString:@"http://kkt.me/mall/?"]) {
        parameters = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/mall/?" withString:@""];
    }else if([[scanValue lowercaseString] containsString:@"http://kkt.me/mall/"]){
        parameters = [scanValue stringByReplacingOccurrencesOfString:@"http://kkt.me/mall/" withString:@""];
    }
    
    NSArray *params = [parameters componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    for (NSString *param in params) {
        NSArray *paramCell = [param componentsSeparatedByString:@"="];
        [paramsDict setObject:paramCell[1] forKey:paramCell[0]];
    }
    
    //                NSString *bid = [paramsDict objectForKey:@"bid"];
    //            NSString *tnum = [paramsDict objectForKey:@"tnum"];
    //            NSString *money = [NSString stringWithFormat:@"%.2f",[[paramsDict objectForKey:@"money"] doubleValue]];
    //            NSString *content = [paramsDict objectForKey:@"content"];
    //            NSString *dev = [paramsDict objectForKey:@"device"];
    
    //            self.model = [[MallOrderModel alloc] init];
    //            @weakify(self);
    //            [self.model getMallOrderWithTnum:tnum Money:money Device:dev then:^(STIHTTPResponseError *e) {
    //                @strongify(self);
    //                if (!e && [self.model.result intValue] == 0){
    //                    CashierViewController *cash = [CashierViewController spawn];
    //                    cash.sn = self.model.tnum;
    //                    cash.isEParking = NO;
    //                    cash.isFromHtml = NO;
    //                    cash.isFromScan = YES;
    //                    cash.content = content;
    //                    cash.cSn = tnum;
    //
    //                    [self.navigationController pushViewController:cash animated:YES];
    //
    //                }else{
    //                    [self presentFailureTips:@"扫描失败，请重新扫描"];
    //                    if ( self.flashlightButton.selected )
    //                    {
    //                        [self flashlightAction:self.flashlightButton];
    //                    }
    //                    [self.navigationController popViewControllerAnimated:YES];
    //                }
    //
    //            }];
    return;

}

#pragma mark-扫码领取优惠券
-(void)handleCoupon:(NSString *)scanValue{
    NSURL *url =nil;
    @try {
        url = [NSURL URLWithString:scanValue];
    }
    @catch (NSException *exception) {
        url=nil;
    }
    @finally {
        
    }
    
    NSMutableDictionary *urlParams = [self getUrlParameters:url];
    
    //C端扫描优惠券二维码，领取优惠券
    //"http://www.kakatool.com/?B=%@&COUPON=%@"
    //corp/qrcode
    if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"COUPON"]&&[urlParams allKeys].count==2) {
        
        NSString *bid = [urlParams objectForKey:@"B"];
        NSString *couponid = [urlParams objectForKey:@"COUPON"];
        if (![bid isNumText] || [couponid trim].length == 0) {
             [self presentFailureTips:@"无法识别"];
            return;
        }
        
        GetCouponController *getCoupon = [[GetCouponController alloc] initWithBid:bid couponId:couponid];
        getCoupon.entranceGuard = self.entranceGuard;
        [self.navigationController pushViewController:getCoupon animated:YES];
        
        return;
    }

    
}

-(void)handleOther:(NSString *)scanValue{
    
    NSURL *url =nil;
    @try {
        url = [NSURL URLWithString:scanValue];
    }
    @catch (NSException *exception) {
        url=nil;
    }
    @finally {
        
    }
    
    NSMutableDictionary *urlParams = [self getUrlParameters:url];
    
    
    int type = -1;
    NSString *numStr = @"";
    NSString *cId = @"";
    
    //C端扫描优惠券二维码，领取优惠券
    //"http://www.kakatool.com/?B=%@&COUPON=%@"
    //corp/qrcode
    if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"COUPON"]&&[urlParams allKeys].count==2) {
        
        NSString *bid = [urlParams objectForKey:@"B"];
        NSString *couponid = [urlParams objectForKey:@"COUPON"];
        if (![bid isNumText] || [couponid trim].length == 0) {
            [self presentFailureTips:@"无法识别"];
            return;
        }
        
        GetCouponController *getCoupon = [[GetCouponController alloc] initWithBid:bid couponId:couponid];
        getCoupon.entranceGuard = self.entranceGuard;
        [self.navigationController pushViewController:getCoupon animated:YES];
        
        return;
    }
    
    //C端扫描B端加会员
    if ([[urlParams allKeys] containsObject:@"B"]&&[urlParams allKeys].count==1) {
        type=1;
        numStr = [urlParams objectForKey:@"B"];
        if (![numStr isNumText]) {
            //                [self presentFailureTips:@"无法识别"];
            return;
        }
        
    }
    
    //C端扫描C端推荐加会员
    if ([[urlParams allKeys] containsObject:@"B"]&&[[urlParams allKeys] containsObject:@"C"]&&[urlParams allKeys].count==2) {
        type=1;
        numStr = [urlParams objectForKey:@"B"];
        cId = [urlParams objectForKey:@"C"];
        if ([numStr isNumText] && [cId isNumText]) {
            self.recommendId = cId;
        }
        else {
            //                [self presentFailureTips:@"无法识别"];
            return;
        }
        
    }
    
    //金钱二维码交易
    if ([[urlParams allKeys] containsObject:@"T"]&&[urlParams allKeys].count==1) {
        
        type=2;
        numStr = [urlParams objectForKey:@"T"];
    }
    //新增交易
    if ([[urlParams allKeys] containsObject:@"Q"]&&[urlParams allKeys].count==1) {
        type=5;
        numStr = [urlParams objectForKey:@"Q"];
    }
    
    //积分二维码交易
    if ([[urlParams allKeys] containsObject:@"P"]&&[urlParams allKeys].count==1) {
        type=4;
        numStr = [urlParams objectForKey:@"P"];
    }
    
    //领卡操作
    if ([[urlParams allKeys] containsObject:@"I"]&&[[urlParams allKeys] containsObject:@"F"]&&[urlParams allKeys].count==2) {
        
        // NSLog(@"scan:%@",result);
        type=3;
        self.fakeBid = [urlParams objectForKey:@"I"];
        self.fakeTcid = [urlParams objectForKey:@"F"];
        
        if (![self.fakeBid isNumText] || ![self.fakeTcid isNumText]) {
            
            //                [self presentFailureTips:@"无法识别"];
            return;
        }
    }

    if (type) {
        switch (type) {
            case 1://加会员
                [self addMember:numStr CID:cId];
                break;
            case 2://消费
                self.transType = @"T";
                [self consume:[NSMutableArray arrayWithObjects:@"T",numStr, nil]];
                break;
            case 5://理发店消费
                self.transType = @"T";
                [self consume:[NSMutableArray arrayWithObjects:@"Q",numStr, nil]];
                break;
            case 4://积分消费
                self.transType = @"P";
                [self consumePoints:numStr];
                break;
            case 3://领卡
                [self drawCard:numStr];
                break;
            case -1://无法识别
            {
                
            }
                
            default:
                break;
        }
        return;
    }
    
}

#pragma mark-添加会员扫描
//添加会员扫描
-(void)addMember:(NSString *)sender CID:(NSString *)cID
{
    if (sender) {
    
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
        ScanAddMemberAPI *scanAddMemberApi = [[ScanAddMemberAPI alloc]initWithRecommendId:cID bid:sender];
        
        [scanAddMemberApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                NSDictionary *cardInfo = result[@"cardinfo"];
                if (![ISNull isNilOfSender:cardInfo]) {
                    Card *cardinfo = [Card mj_objectWithKeyValues:result[@"cardinfo"]];
                    
                    
                    NSString *cardnum = cardinfo.cardinfo.cardnum;
                    NSString *cardtype = cardinfo.cardtype;
                    NSString *extra = cardinfo.extra;
                    
                    
                    if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
                        //饭票商城   //地方饭票
                        if (extra&&[extra trim].length>0) {
                            if ([[LocalData shareInstance] isLogin]) {
                                
                                UserModel *user = [[LocalData shareInstance]getUserAccount];
                                
                                NSString *token = [LocalData getDeviceToken];
                                if (user&&token) {
                                    if ([cardinfo.cardtype intValue] == 1){
                                        NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[cardinfo.extra trim],user.cid,token];
                                        if (urlstring) {
                                            
                                            WebViewController *web = [WebViewController spawn];
                                            web.webURL = urlstring;
                                            web.webTitle = @"饭票商城";
                                            [self.navigationController pushViewController:web animated:YES];
                                            
                                        }
                                    }else if ([cardinfo.cardtype intValue] == 2){
                                        //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                                        NSString *urlstring = cardinfo.extra;
                                        urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:cardinfo.cid];
                                        urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                                        urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:cardinfo.bid];
                                                                    urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:cardinfo.bid];
                                        
                                        if (urlstring) {
                                            
                                            
                                            WebViewController *web = [WebViewController spawn];
                                            web.webURL = urlstring;
                                            web.webTitle = cardinfo.cardname;
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
                            
                            memberCardDetail.bid = cardinfo.bid;
                            memberCardDetail.cardId = cardinfo.cardid;
                            memberCardDetail.cardType = @"online";
                            
                            [self.navigationController pushViewController:memberCardDetail animated:YES];
                            
                        }else{
                            //非会员
                            
                            NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                            noMemberCardDetail.bid = cardinfo.bid;
                            noMemberCardDetail.reloadData = ^{};
                            
                            [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                            
                        }
                        
                    }
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
}


#pragma mark-消费扫描
//消费扫描
-(void)consume:(NSMutableArray *)sender
{
    
//    self.consumeModel1 = [[AddMemberModel alloc]init];
//    
//    self.consumeModel1.dict = @{@"Code":[sender objectAtIndex:1]};
//
//    if ([[sender objectAtIndex:0] isEqualToString:@"Q"]) {
//        self.consumeModel1.module = @"transaction";
//        self.consumeModel1.func = @"qrtrsrequest";
//        
//    }else{
//        self.consumeModel1.module = @"transaction";
//        self.consumeModel1.func = @"trsinfobytnum";
//        
//    }
//    [self presentLoadingTips:nil];
//    @weakify(self);
//    self.consumeModel1.whenUpdated = ^(STIHTTPResponseError *error){
//        @strongify(self);
//        [self dismissTips];
//        if (error) {
//            
//        }else{
//            if (self.consumeModel1.reason) {
//                [self presentFailureTips:self.consumeModel1.reason];
//            }else{
//                if (self.consumeModel1.data&&self.consumeModel1.businfo &&self.consumeModel1.cardinfo) {
//                    if ([self.consumeModel1.data.tstatus intValue] == 0) {
//                        //跳转消费
//                    PayController *payView = [[PayController alloc] initWithTransInfo:self.consumeModel1.data cardInfo:self.consumeModel1.cardinfo busInfo:self.consumeModel1.businfo value:self.consumeModel1.data.amount];
//                        payView.entranceGuard = self.entranceGuard;
//                        payView.transType = self.transType;
//                        [self.navigationController pushViewController:payView animated:YES];
//                    }else{
//                        [self presentFailureTips:@"该交易已完成，无须重复交易"];
//                    }
//                }else{
//                    [self isAddMember:self.consumeModel1.businfo];
//                }
//            }
//        }
//    };
//    [self.consumeModel1 refresh];
}
////消费扫描
-(void)consumePoints:(NSString *)sender
{
//    self.consumeModel2 = [[AddMemberModel alloc]init];
//    self.consumeModel2.dict = @{@"tnum":sender};
//    self.consumeModel2.module = @"pointstransaction";
//    self.consumeModel2.func = @"trsinfobytnum";
//    
//    [self presentLoadingTips:nil];
//    @weakify(self);
//    self.consumeModel2.whenUpdated = ^(STIHTTPResponseError *error){
//        @strongify(self);
//        [self dismissTips];
//        if (error) {
//            
//        }else{
//            if (self.consumeModel2.reason) {
//                [self presentFailureTips:self.consumeModel2.reason];
//            }else{
//                if (self.consumeModel2.data&&self.consumeModel2.businfo &&self.consumeModel2.cardinfo) {
//                    if ([self.consumeModel2.data.tstatus intValue] == 0) {
//                        //跳转消费
//                        PayController *payView = [[PayController alloc] initWithTransInfo:self.consumeModel2.data cardInfo:self.consumeModel2.cardinfo busInfo:self.consumeModel2.businfo value:self.consumeModel2.data.amount];
//                        payView.entranceGuard = self.entranceGuard;
//                        payView.transType = self.transType;
//                        [self.navigationController pushViewController:payView animated:YES];
//                    }else{
//                        [self presentFailureTips:@"该交易已完成，无须重复交易"];
//                    }
//                }else{
//                    [self isAddMember:self.consumeModel2.businfo];
//                }
//            }
//        }
//    };
//    [self.consumeModel2 refresh];
}
////是否加入会员
//-(void)isAddMember:(BUSINFO *)sender
//{
//    if ([ISNull isNilOfSender:sender]) {
//        [self presentFailureTips:@"请求商户数据错误"];
//        return;
//    }
//    [self presentLoadingTips:nil];
//    self.detailModel = [[SurroundDetailModel alloc]init];
//    self.detailModel.bid = sender.bid;
//    @weakify(self);
//    self.detailModel.whenUpdated = ^(STIHTTPResponseError *error){
//        @strongify(self);
//        [self dismissTips];
//        if (error) {
//            [self dismissTips];
//        }else{
//            if (self.detailModel.reason) {
//                [self presentFailureTips:self.detailModel.reason];
//            }else{
//                CardDetailNotMerberViewController *detailViewController = [[CardDetailNotMerberViewController alloc] initWithInfo:self.detailModel.info bizCardInfo:nil Cardid:nil CardTypes:@"online" imageurl:sender.logourl];
//                
//                detailViewController.entranceGuard = self.entranceGuard;
//                
//                [self.navigationController pushViewController:detailViewController animated:YES];
//                
//            }
//        }
//        
//    };
//    [self.detailModel refresh];
//}
#pragma mark-领卡扫描
////领卡扫描
-(void)drawCard:(NSString *)sender
{
//    self.drawCardModel = [[AddMemberModel alloc]init];
//    self.drawCardModel.dict = @{@"bid":self.fakeBid,
//                                @"tcid":self.fakeTcid};
//    self.drawCardModel.module = @"membercard";
//    self.drawCardModel.func = @"gettempcardinfo";
//    [self presentLoadingTips:nil];
//    @weakify(self);
//    self.drawCardModel.whenUpdated = ^(STIHTTPResponseError *error){
//        @strongify(self);
//        [self dismissTips];
//        if (error) {
//            
//        }else{
//            if (self.drawCardModel.reason) {
//                [self presentFailureTips:self.consumeModel1.reason];
//            }else{
//                
//            }
//        }
//    };
//    [self.drawCardModel refresh];
}

////领卡
- (void)showFakeViewOldCard:(id)oldCard temCard:(id)temCard temMember:(id)temMember
{
    
//    NSDictionary *oldCardInfoDic=(NSDictionary *)oldCard;
//    NSDictionary *temCardInfoDic=(NSDictionary *)temCard;
//    NSDictionary *temMemberInfoDic=(NSDictionary *)temMember;
//    
//    TempMemberInfo *tempMemberInfo = [[[TempMemberInfo alloc] initWithDic:temMemberInfoDic] autorelease];
//    TempCardInfo *tempCardInfo = [[[TempCardInfo alloc] initWithDic:temCardInfoDic] autorelease];
//    
//    FakeViewController *fakeView = [[FakeViewController alloc] init];
//    fakeView.fakeBid = self.fakeBid;
//    fakeView.fakeTcid = self.fakeTcid;
//    fakeView.tempMemberInfo = tempMemberInfo;
//    fakeView.tempCardInfo = tempCardInfo;
//    
//    
//    if ([ISNull isNilOfSender:oldCard]==NO) {
//        TempCardInfo *oldCardInfo = [[[TempCardInfo alloc] initWithDic:oldCardInfoDic] autorelease];
//        fakeView.oldCardInfo = oldCardInfo;
//    }
//    
//    //    if (self.delegate && [self.delegate respondsToSelector:@selector(setTabBarHidden:)]) {
//    //        [self.delegate setTabBarHidden:YES];
//    //    }
//    if (self.wtTabBarController) {
//        [self.wtTabBarController setTabBarHidden:YES];
//    }
//    
//    
//    [self.navigationController pushViewController:fakeView animated:YES];
}

#pragma mark-处理不是kakatool的链接
-(void)handleNoKakatool:(NSString *)scanValue{
    
    NSURL *url =nil;
    @try {
        url = [NSURL URLWithString:scanValue];
    }
    @catch (NSException *exception) {
        url=nil;
    }
    @finally {
        
    }
    
    if ([scanValue isURL]) {
        //若为链接
        NSString *urlStr = [[NSString stringWithString:scanValue] trim];
        NSString *urlHttp = @"http://";
        if (![urlStr hasPrefix:@"http://"]&&![urlStr hasPrefix:@"https://"]) {
            urlStr = [urlHttp stringByAppendingString:urlStr];
        }
        
        
        WebViewController *web = [WebViewController spawn];
        web.webURL = urlStr;
        web.webTitle = @"";
        [self.navigationController pushViewController:web animated:YES];
        
        return;
    }else if (url == nil&&(![scanValue isURL])) {
        //不是链接跳转到其他界面
        OtherViewController *other = [[OtherViewController alloc]init];
        other.result = scanValue;
        [self.navigationController pushViewController:other animated:YES];
        return;
    }
    
}

- (void)setupDenied
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [self.scanView stopAnimation];
}

#pragma mark -

- (void)flashlight:(UIButton *)sender
{
    sender.selected = !sender.selected;
    AVCaptureFlashMode mode = [device flashMode];
    AVCaptureTorchMode torchMode = [device torchMode];
    
    [device lockForConfiguration:nil];
    
    if ( sender.selected )
    {
        mode = AVCaptureFlashModeOn;
        torchMode = AVCaptureTorchModeOn;
    }
    else
    {
        mode = AVCaptureFlashModeOff;
        torchMode = AVCaptureTorchModeOff;
    }
    
    if ([device isFlashModeSupported:mode]) {
        device.flashMode = mode;
    }
    
    if ( [device isTorchModeSupported:torchMode] ) {
        device.torchMode = torchMode;
    }
    
    [device unlockForConfiguration];
}

- (IBAction)flashlightAction:(UIButton *)sender
{
    if ( GT_IOS7 )
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status) {
            case AVAuthorizationStatusAuthorized:
            {
                [self flashlight:sender];
                break;
            }
            default:
                break;
        }
    }
    else
    {
        [self flashlight:sender];
    }
    
}

- (void)setupNotDetermined
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            if ( GT_IOS7 )
            {
                [self setupSession];
            }
        } else {
            [self setupDenied];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}



@end
