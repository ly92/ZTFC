//
//  CommentController.m
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "CommentController.h"
#import "RepairController.h"
#import "ComplaintController.h"


@interface CommentController ()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (retain, nonatomic) IBOutlet UIScrollView *sv;
@property (retain, nonatomic) IBOutlet UIControl *containerView;
@property (retain, nonatomic) IBOutlet UIButton *btnGood;
@property (retain, nonatomic) IBOutlet UIButton *btnBad;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *txtContent;
- (IBAction)submitClicked:(id)sender;
- (IBAction)goodClicked:(id)sender;
- (IBAction)badClicked:(id)sender;
- (IBAction)hideKeyboardClicked:(id)sender;

@property(nonatomic,retain) NSString *maintype;
@property(nonatomic,retain) NSString *thirdId;
@property(nonatomic,assign) BOOL isGood;

@end

@implementation CommentController

#pragma mark - 视图生命周期


- (instancetype)initWIthType:(NSString *)aType ThirdNO:(NSString *)aNo
{
    self = [super init];
    if (self) {
        self.maintype = aType;
        self.thirdId = aNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.submitButton setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.btnGood.backgroundColor = BUTTON_BLUECOLOR;
    [self setNavigationBar];
    [self setToolbar];
    [self listenToKeyboard];
    [self prepareLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"评价";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - 布局

-(void)prepareLayout{
    
    self.sv.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    
    [self.sv addSubview:self.containerView];
    
    self.txtContent.placeholder=@"请填写评价内容";
    
    [self.btnGood setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    [self.btnGood setBackgroundColor:VIEW_BTNBG_COLOR];
    
    
    [self.btnBad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnBad setBackgroundColor:[UIColor whiteColor]];
    
    self.isGood=YES;

    
   
}



#pragma mark - 事件

- (IBAction)submitClicked:(id)sender {
    
    if (!self.isGood) {
        
        if (!self.txtContent.text||[self.txtContent.text trim].length==0) {
            [self presentFailureTips:@"不满意请填写内容"];
            return;
        }
    }
    
    NSString *satified = @"1";
    if (!self.isGood) {
        satified=@"2";
    }
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];

    CommentAPI *commentApi = [[CommentAPI alloc]initWithOrderNO:self.thirdId satisfied:satified reason:self.txtContent.text];
    if ([self.maintype isEqualToString:@"1"]) {
        commentApi.commentType = REPAIR;
    } else if([self.maintype isEqualToString:@"2"]){
        commentApi.commentType = COMPLAINT;
    }
    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self presentSuccessTips:@"感谢你的评价"];
            
            if ([self.maintype isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_REPAIR" object:nil];
            } else if([self.maintype isEqualToString:@"2"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_COMPLAINT" object:nil];
            }
            
            
            UIViewController *control = nil;
            
            if ([self.maintype isEqualToString:@"1"]) {
                for (UIViewController *viewControl in self.navigationController.viewControllers) {
                    if ([viewControl isKindOfClass:[RepairController class]]) {
                        control=viewControl;
                        break;
                    }
                }
            } else if([self.maintype isEqualToString:@"2"]){
                for (UIViewController *viewControl in self.navigationController.viewControllers) {
                    if ([viewControl isKindOfClass:[ComplaintController class]]) {
                        control=viewControl;
                        break;
                    }
                }
            }
            
            if (control) {
                [self.navigationController popToViewController:control animated:YES];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
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


//隐藏键盘
- (IBAction)hideKeyboardClicked:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)goodClicked:(id)sender {
    
    [self.btnGood setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    [self.btnGood setBackgroundColor:VIEW_BTNBG_COLOR];
    
    
    [self.btnBad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnBad setBackgroundColor:[UIColor whiteColor]];
    
    self.isGood=YES;
}

- (IBAction)badClicked:(id)sender {
    
    [self.btnBad setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    [self.btnBad setBackgroundColor:VIEW_BTNBG_COLOR];
    
    
    [self.btnGood setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnGood setBackgroundColor:[UIColor whiteColor]];
    
    self.isGood=NO;
}

#pragma mark - 键盘

-(void)listenToKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    NSDictionary* userInfo = [note userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    self.sv.contentInset = UIEdgeInsetsMake(0,0,keyboardFrame.size.height,0);
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    self.sv.contentInset = UIEdgeInsetsMake(0,0,0,0);
}
-(void)setToolbar{
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.txtContent.inputAccessoryView   = toobar;
    
}
-(void)resignKeyboard{
    [self.view endEditing:YES];
}
@end
