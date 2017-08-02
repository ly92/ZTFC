//
//  SearchWordCell.h
//  colourlife
//
//  Created by 李勇 on 16/3/23.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchWordCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isCommunity;

@property (weak, nonatomic) IBOutlet UILabel *searchWordLbl;

@end
