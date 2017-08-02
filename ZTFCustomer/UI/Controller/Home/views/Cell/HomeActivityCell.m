//
//  HomeActivityCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeActivityCell.h"
#import "ActivityCollectionViewCell.h"
#import "HomeCardStyle.h"

@interface HomeActivityCell () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HomeActivityCell

+ (CGFloat)heightForHomeActivityWithDataCount:(NSInteger)count cardStyle:(LIMITYACTIVITY_STYLE)cardStyle
{
    CGFloat height = [HomeCardStyle cardHeightWithStyle:cardStyle dataCount:count];
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
//    UICollectionViewFlowLayout *cardLayout = [[UICollectionViewFlowLayout alloc] init];
//    
////    CGFloat width = (SCREENWIDTH-30)/2.0;
////    
////    
////    cardLayout.itemSize = CGSizeMake(width, width);
//    cardLayout.minimumInteritemSpacing = 0;
//    cardLayout.minimumLineSpacing = 1;
//    
    
//    CardLayout * cardLayout = [HomeCardStyle cardStyleWithCollection:self.collectionView style:limityActivity.style];
    
    
//    [self.collectionView setCollectionViewLayout:cardLayout];

    
    [self.collectionView registerNib:[ActivityCollectionViewCell nib] forCellWithReuseIdentifier:@"ActivityCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange
{
    if ( [self.data isKindOfClass:[LimitActivityModel class]] )
    {
        
        LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
   
        CardLayout * cardLayout = [HomeCardStyle cardStyleWithCollection:self.collectionView style:limityActivity.style_num];
        
        self.collectionView.collectionViewLayout = cardLayout;
        
//        [self.collectionView setCollectionViewLayout:cardLayout];

        [self.collectionView reloadData];
    }
}

#pragma mark-collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
    NSInteger index = limityActivity.list.count;
    
//    [[AppDelegate sharedAppDelegate]showNoticeMsg:[NSString stringWithFormat:@"cell count:%ld",limityActivity.list.count] WithInterval:1.5f];
    
    return index;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [[AppDelegate sharedAppDelegate]showNoticeMsg:@"调用cell" WithInterval:1.5f];
    LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
    NSArray * attrs = limityActivity.list;
    ActivityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCollectionViewCell" forIndexPath:indexPath];
    
    cell.data = attrs[indexPath.item];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCollectionViewCell * cell = (ActivityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(activityDidSelectCell:)]) {
        [self.delegate activityDidSelectCell:cell.data];
    }
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSInteger count = [self.collectionView numberOfItemsInSection:indexPath.section];
//
//    LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
////    NSInteger count = limityActivity.list.count;
//     switch ( limityActivity.style_num ) {
//         case LIMITYACTIVITY_STYLE_DEFAULT1:{
//            
//                 return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//
//             break;
//         }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT2:{
//           
//
//            return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//
//
//             break;
//         }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT3:{
//            
//
//            return CGSizeMake([CardLayout sizeThree].width, [CardLayout sizeThree].height);
//             
//            break;
//         }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT4:{
//                 
//
//            return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//
//             break;
//         }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT5:
//         {
//             
//             if (indexPath.item == 0) {
//                 
//                 return CGSizeMake([CardLayout sizeThree].width, [CardLayout sizeThree].height);
//             }
//             else{
//                 return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//             }
//             break;
//         }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT6:
//         {
//
//             
//                 if (indexPath.item == 0) {
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 }
//                 else{
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                 }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT7:
//             {
//                 
//
//                return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//
//                 
//                 break;
//             }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT8:
//             {
//                 
//                     
//                     if (indexPath.item == 0) {
//                          return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     }else
//                     {
//
//                             return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//
//                     }
//                     
//                 break;
//             }
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT9:
//             {
//               
//                 if ( indexPath.item == 0 )
//                 {
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 }
//                 else if ( indexPath.item == count - 1 )
//                 {
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 }
//                 else
//                 {
//                     
//                        return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     
//                 }
//                 
//                 break;
//             }
//             
//         }
//    
//    return CGSizeMake(0, 0);
//}

@end
