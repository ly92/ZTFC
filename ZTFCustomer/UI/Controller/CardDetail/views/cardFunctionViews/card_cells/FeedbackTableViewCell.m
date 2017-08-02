//
//  FeedbackTableViewCell.m
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "TextView.h"
#import "FeedbackListmodel.h"

@interface FeedbackTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet TextView *contentL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@end

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dataDidChange{
    FeedbackModel *feedback = self.data;
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[feedback.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
//    self.timeL.text = [NSDate longlongToDate:feedback.creationtime];
    self.contentL.text = feedback.content;
    if (feedback.replycontent.length != 0){
        self.stateL.text = @"已回复";
        self.stateL.textColor = RGBCOLOR(113, 213, 78);
    }else {
        self.stateL.text = @"待回复";
        self.stateL.textColor = [UIColor redColor];
    }
}

@end
