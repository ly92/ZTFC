//
//  ModifyUsernameController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyUsernameController.h"

@interface ModifyUsernameController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) nameInfoBlock nameBlock;
@property (nonatomic, assign) ActivityType activityType;

@end

@implementation ModifyUsernameController

+(instancetype)spawn{
    return [ModifyUsernameController loadFromStoryBoard:@"PersonalCenter"];
}

-(void)infoWithName:(NSString *)name activityType:(ActivityType)activityType Then:(nameInfoBlock)block{
    
    if (![ISNull isNilOfSender:name]) {
        self.nameString = name;
    }
    
    self.activityType = activityType;
    self.nameBlock = block;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.completeButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.completeButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
    [self hideKeyBoard];
    if (self.activityType == nameType) {
        self.navigationItem.title = @"修改姓名";
        self.nameTextField.placeholder = @"请输入姓名";
        
    }else if (self.activityType == addressType){
        self.navigationItem.title = @"修改地址";
        self.nameTextField.placeholder = @"请输入地址";
    }else if (self.activityType == emailType){
        self.navigationItem.title = @"修改邮箱";
        self.nameTextField.placeholder = @"请输入邮箱";
    }
    
    self.nameTextField.text = self.nameString;

    
    
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.nameTextField.inputAccessoryView   = toobar;
    
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


//toobar Action
-(void)resignKeyboard{
    [self.nameTextField resignFirstResponder];
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark-hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.nameTextField resignFirstResponder];
}

#pragma mark-click

- (IBAction)deleteButtonClick:(id)sender {
 
    self.nameTextField.text =  @"";
}

//完成按钮
- (IBAction)finishButtonClick:(id)sender {
    self.nameBlock(_nameTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}

#pragma mark - textfieldDelegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.activityType == nameType) {
        if (string.length > 0) {
            if (textField.text.length >=10) {
                [self presentFailureTips:@"名字不能超过10个字符"];
                return NO;
            }
        }
    }
    
    return YES;
    
    
}

@end
