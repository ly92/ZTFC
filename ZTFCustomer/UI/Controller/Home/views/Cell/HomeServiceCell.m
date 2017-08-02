//
//  HomeServiceCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeServiceCell.h"
#import "ServiceCollectionViewCell.h"

@interface HomeServiceCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblLeading1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblLeading2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblLeading3;

@end

@implementation HomeServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    CGFloat width = SCREENWIDTH/4.0;
    
    self.lblLeading1.constant = self.lblLeading2.constant = self.lblLeading3.constant = width;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
//    CGFloat width = SCREENWIDTH/4.0;
    
    
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
 
    [self.collectionView setCollectionViewLayout:layout];

    [self.collectionView registerNib:[ServiceCollectionViewCell nib] forCellWithReuseIdentifier:@"ServiceCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange
{
    if ( [self.data isKindOfClass:[NSArray class]] )
    {
                
        
        [self.collectionView reloadData];
        
    }
}

#pragma mark-collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *arr = (NSArray *)self.data;
    
//    if (arr == nil) {
//        return 0;
//    }
//    if (arr.count == 0) {
        return arr.count;
//    }
//    else if (arr.count%4 == 0) {
//        return arr.count;
//    }else{
//        return  (arr.count/4+1)*4;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = (NSArray *)self.data;

    ServiceCollectionViewCell * cell =(ServiceCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionViewCell" forIndexPath:indexPath];
    cell.rightLbl.hidden = YES;
    
    if (arr.count > indexPath.item) {
        cell.data = arr[indexPath.item];
    }
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(functionDidSelectCell:)]) {
        [self.delegate functionDidSelectCell:cell.data];
    }
}



@end
