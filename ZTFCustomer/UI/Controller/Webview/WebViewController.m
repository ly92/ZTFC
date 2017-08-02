//
//  WebViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "WebViewController.h"
#import "PayController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "ShareSDKJSBridge.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

//@property WebViewJavascriptBridge *bridge;
@end

@implementation WebViewController
+ (instancetype)spawn
{
    return [WebViewController loadFromStoryBoard:@"WebView"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    
    [self presentLoadingTips:nil];
    if ([ISNull isNilOfSender:self.webURL]) {
        
        self.webURL =[NSString stringWithFormat:@"http://app.kakatool.cn/policy.php?appid=%@",APP_ID];
        self.navigationItem.title = @"用户协议";
    }

    
    if (_isShop == YES) {
        self.webURL =[NSString stringWithFormat:@"%@&appid=%@",self.webURL,APP_ID];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [self.webURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
    [_webView setDelegate:self];
    
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
   
//    [UIAlertView bk_showAlertViewWithTitle:@"慧生活" message:@"警告：内存不足" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        
//    }];
    
    
  
}

#pragma mark-navibar

-(void)setNavigationBar{
    
    if (![ISNull isNilOfSender:self.webTitle]) {
        self.navigationItem.title = self.webTitle;
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        if (self.isPay) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([_webView canGoBack]) {
            UserModel *user = [[LocalData shareInstance] getUserAccount];
            NSString *requestStr = _webView.request.URL.absoluteString;
            if ([requestStr hasPrefix:[NSString stringWithFormat:@"http://colour.kakatool.cn/bonus/bonus/couponList?userid=%@",user.cid]] && [requestStr containsString:@"longitude"] && [requestStr containsString:@"latitude"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                [_webView goBack];
            }
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark-webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, jumpShareSdk就是调用的jumpShareSdk方法名
    
    context[@"jumpShareSdk"] = ^() {
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        [self showShare:args];
        
    };
    
    context[@"alert"] = ^(){
        NSArray *args = [JSContext currentArguments];
        JSValue *jsValue = args[0];
        NSString *title = jsValue.toString;
        
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    };
    
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"requestString is %@",requestString);
    if ([requestString containsString:@"payFromHtml5"]){
        
        NSString *tnum;
        
        NSError *error;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[*][0-9]{15,}[*]" options:0 error:&error];
        if (regex!=nil) {
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:requestString options:0 range:NSMakeRange(0, [requestString length])];
            
            //如果找到匹配的字符串
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                NSString *str = [requestString substringWithRange:resultRange];
                tnum = [str substringFrom:1 to:str.length - 1];
                
                
                [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
                
                CheckForKakaPayAPI *checkForkakaPayApi = [[CheckForKakaPayAPI alloc]initWithAppId:APP_ID];
                [checkForkakaPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                    [self dismissTips];
                    NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                    if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                        if ([result[@"enable"] intValue] == 1) {
                            [self payFromHtmcl5With:tnum];
                            
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"该APP不支持在线支付" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
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
            }else{
                 [self presentFailureTips:@"订单不存在"];

            }
        }
        
        
        return NO;
    }
    
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//    
//    NSString *str = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    
//    NSLog(@"%@",str);
    
    
    //    //将url转换为string
    
    NSString *urlStr = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",urlStr);
    NSArray * strArray = [urlStr componentsSeparatedByString:@":"];
    
    
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:requestString]]) {
        return NO;
    }
    if ([[strArray objectAtIndex:0] isEqualToString:@"jsbridge"]) {
        return NO;
    }
//    return ![[ShareSDKJSBridge sharedBridge] captureRequest:request webView:webView];
    return YES;
}

//跳转到支付页面
- (void)payFromHtmcl5With:(NSString *)tnum{
    PayController *payVC = [[PayController alloc]initWithTnum:tnum];

    @weakify(payVC)
    payVC.paySuccess = ^(NSString *payCallback){
        @strongify(payVC)
        [payVC.navigationController popToViewController:self animated:NO];
//        [self.webView removeFromSuperview];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",payCallback]]];
        self.navigationItem.title = @"支付结果";
        
        self.isPay = YES;
        
        [self.webView loadRequest:request];
//        [self.view addSubview:self.webView];
        
    };
    [self.navigationController pushViewController:payVC animated:YES];
   
}

-(void)showShare:(NSArray *)arr{
    
    NSLog(@"%@",arr);
    
    if(arr.count == 0){
        [self myshareClick];
    }else{
        //        [self myshareClick];
        
        [self customShareClick:arr];
    }
    
}

- (void)myshareClick
{
    
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance] getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *name = @"";
    if ([tUserDetail.realname trim].length>0) {
        name = tUserDetail.realname;
    }
    else{
        name = tUserDetail.loginname;
    }
    
//    NSString *cShareTitle = [NSString stringWithFormat:@"%@邀请您立刻加入",name];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSString *cShareContent =[NSString stringWithFormat:@"%@微生活，享受智能社区生活",appName];
    
    
    //    NSString *cShareurl = [NSString stringWithFormat:@"http://kakatool.com/wt/index.html?%@",tUserDetail.cid];
//    NSString *cShareurl = [NSString stringWithFormat:@"http://app.kakatool.cn/app.php?appid=%@",APP_ID];
//    if (IS_APPSTORE) {
      NSString *cShareurl= [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@",APPSTOREID];;
//    }
    NSLog(@"cShareurl-%@" ,cShareurl);
    
//    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,cShareurl];
//    NSString *cShareAllContent = [NSString stringWithFormat:@"%@！%@",cShareTitle,cShareTheme];

    
}

-(void)customShareClick:(NSArray *)arr{
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    for (JSValue *jsVal in arr) {
        NSLog(@"%@", jsVal.toString);
        [arr1 addObject:jsVal.toString];
    }
    
    
//    NSString *name = arr1[0];
    
    
//    NSString *cShareTitle = [NSString stringWithFormat:@"%@",name];
    
//    NSString *cShareContent =[NSString stringWithFormat:@"%@",arr1[2]];
//    
//    NSString *cShareurl = [NSString stringWithFormat:@"%@",arr1[1]];
    
//    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,cShareurl];
//    NSString *cShareAllContent = [NSString stringWithFormat:@"%@！\n%@",cShareTitle,cShareTheme];
    
    
    NSString *str = @"http://img.taopic.com/uploads/allimg/110906/1382-110Z611025585.jpg";
    NSLog(@"%@",str);
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self dismissTips];
    [self presentLoadingTips:nil];
    NSLog(@"Starting to download request: %@", [webView.request.URL absoluteString]);
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissTips];
    
    self.webView.hidden = NO;
   
    
    if ([ISNull isNilOfSender:self.webTitle]) {
        self.navigationItem.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    }
    
    
    NSLog(@"Finished downloading request: %@", [webView.request.URL absoluteString]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [self presentFailureTips:error.localizedDescription];
    if ([error code] == NSURLErrorCancelled){
        NSLog(@"Canceled request: %@", [webView.request.URL absoluteString]);
    }else{
        self.webView.hidden=YES;
//        self.control.hidden=NO;
    }
    NSLog(@"didFailLoadWithError");
}

#pragma mark - 用于模块化的认证
+(NSString *)pingUrlWithUrl:(NSString *)url pushCmd:(NSString *)pushCmd{
    NSString *cid  = @"";
    NSString *timestamp = @"";
    NSString *token = @"";
    NSString *appid = @"";
    NSString *communityid = @"";
    NSString *cmd = @"";
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    cid = [NSString stringWithFormat:@"%@",user.cid];
    NSDate *date = [NSDate date];
    timestamp = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    NSString  *kkToken = [LocalData getAccessToken];
    token = [[NSString stringWithFormat:@"%@%@%@",cid,kkToken,timestamp] MD5Hash];
    appid = APP_ID;
    
    Community *communityDic  = [STICache.global objectForKey:user.mobile];
    communityid = [NSString stringWithFormat:@"%@", communityDic.bid ];
    
    if (pushCmd.length == 0) {
        cmd = @"home";
    }else{
        cmd = pushCmd;
    }
    
    NSString *resultUrl = [NSString stringWithFormat:@"%@",url];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$cid$" withString:cid];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$timestamp$" withString:timestamp];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$token$" withString:token];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$appid$" withString:appid];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$communityid$" withString:communityid];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"$cmd$" withString:cmd];
    
    return resultUrl;
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
