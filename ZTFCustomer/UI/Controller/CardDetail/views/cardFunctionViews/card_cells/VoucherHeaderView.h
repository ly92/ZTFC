//
//  VoucherHeaderView.h
//  colourlife
//
//  Created by 李勇 on 16/2/29.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *voucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addresslbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLblH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLblH;

@end
