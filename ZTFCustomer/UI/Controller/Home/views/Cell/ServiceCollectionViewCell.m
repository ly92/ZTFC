//
//  ServiceCollectionViewCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ServiceCollectionViewCell.h"

@interface ServiceCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgViewWidth;


@end


@implementation ServiceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImgViewHeight.constant = self.iconImgViewWidth.constant = SCREENWIDTH/4.0/2.0;
}

-(void)dataDidChange{
    FunctionModel *functionModel = (FunctionModel *)self.data;
    if (functionModel) {
        self.nameLbl.text = functionModel.name;
        
        [self.iconImgView setImageWithURL:[NSURL URLWithString:functionModel.iconurl] placeholder:[UIImage imageNamed:@""]];
        
    }
}

@end
