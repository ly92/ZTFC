//
//  EntranceGuardCell.m
//  colourlife
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "EntranceGuardCell.h"

@interface EntranceGuardCell ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;

@property (weak, nonatomic) IBOutlet UIView *contextView;

@end

@implementation EntranceGuardCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)dataDidChange{
    
    NSDictionary *door = self.data;
    
    if (door) {
        self.nameLabel.text = [door objectForKey:@"name"];
        self.buildingLabel.text = [door objectForKey:@"address"];
        self.numberLabel.text = self.number;
    }
}



@end
