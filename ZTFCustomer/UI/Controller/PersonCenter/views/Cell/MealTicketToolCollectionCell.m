//
//  MealTicketToolCollectionCell.m
//  colourlife
//
//  Created by 吴超 on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "MealTicketToolCollectionCell.h"

@interface MealTicketToolCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *toolImage;
@property (weak, nonatomic) IBOutlet UILabel *toolName;

@end

@implementation MealTicketToolCollectionCell
//@def_signal(mealTicketTool);

//- (IBAction)toolClick:(id)sender {
//    [self sendSignal:MealTicketToolCollectionCell.mealTicketTool withObject:self.data];
//}

- (void)dataDidChange
{
//    if ([self.data isKindOfClass:[ACTIVITYLIST class]]) {
//        ACTIVITYLIST * redMoerList = self.data;
//        
//        if (redMoerList)
//        {
//            self.toolImage.hidden = NO;
//            self.toolName.hidden = NO;
//            if (![ISNull isNilOfSender:redMoerList.img]) {
//                [self.toolImage setImageWithPhoto:redMoerList.img];
//            }
//            self.toolName.text = redMoerList.name;
//        }
//        else
//        {
//            self.toolImage.hidden = YES;
//            self.toolName.hidden = YES;
//        }
//
//    } else
    if ([self.data isKindOfClass:[RedMoreListModel class]]) {
        RedMoreListModel * redMoerList = self.data;
        
        if (redMoerList)
        {
            self.toolImage.hidden = NO;
            self.toolName.hidden = NO;
            if (![ISNull isNilOfSender:redMoerList.image]) {
                [self.toolImage setImage:[UIImage imageNamed:redMoerList.image]];
            } else {
//                [self.toolImage setImageWithPhoto:redMoerList.icon_url];
            }
            self.toolName.text = redMoerList.title;
        }
        else
        {
            self.toolImage.hidden = YES;
            self.toolName.hidden = YES;
        }
    }
}

@end
