//
//  NoMemberCardDetailViewController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadData)();

@interface NoMemberCardDetailViewController : UIViewController

@property (nonatomic, copy) NSString *bid;

@property (copy, nonatomic) ReloadData reloadData;//

@end
