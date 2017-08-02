//
//  OtherViewController.m
//  colourlife
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()
@property (weak, nonatomic) IBOutlet UITextView *resultText;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置导航栏的数据
    [self setupNavgationBar];
    
    if (self.result) {
         self.resultText.text = self.result;
    }
   
}
//设置导航栏的数据
-(void)setupNavgationBar{
    self.navigationItem.title=@"扫描结果";
    
    self.navigationItem.leftBarButtonItem=[AppTheme backItemWithHandler:^(id sender) {
        
        for (UIViewController* tempVC in [self.navigationController viewControllers]) {
            if ([tempVC isKindOfClass:[EntranceGuardController class]]) {
                [self.navigationController popToViewController:tempVC animated:YES];
                return ;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
