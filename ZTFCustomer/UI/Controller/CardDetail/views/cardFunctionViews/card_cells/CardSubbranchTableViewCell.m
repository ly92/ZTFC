//
//  CardSubbranchTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardSubbranchTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "MemberCardDetailModel.h"

@interface CardSubbranchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLHeight;

@end

@implementation CardSubbranchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
/**
 @interface CARD_INFO_branch: NSObject
 @property (nonatomic, strong) NSString * addr;//""
 @property (nonatomic, strong) NSString * bid;
 @property (nonatomic, strong) NSString * creationtime;
 @property (nonatomic, strong) NSString * id;
 @property (nonatomic, strong) NSString * isdeleted;
 @property (nonatomic, strong) NSString * isshow;
 @property (nonatomic, strong) NSString * last_update;
 @property (nonatomic, strong) NSString * latitude;
 @property (nonatomic, strong) NSString * longitude;
 @property (nonatomic, strong) NSString * name;
 @property (nonatomic, strong) NSString * tel;
 @end
 */
- (IBAction)callClick:(id)sender {
    self.call();
}

- (void)dataDidChange{
    Branch *branch = self.data;
    
    self.nameL.text = branch.name;
    self.addressL.text = branch.addr;
    
    CGFloat addressHeight = [self.addressL resizeHeight];
    if (addressHeight < 20) {
        self.addressLHeight.constant = 20;
    }else{
        self.addressLHeight.constant = addressHeight;
    }
    
    NSNumber *LatLct = [AppLocation sharedInstance].location.lat;
    NSNumber *LonLct = [AppLocation sharedInstance].location.lon;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[LatLct doubleValue] longitude:[LonLct doubleValue]];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:[branch.latitude doubleValue] longitude:[branch.longitude doubleValue]];
    CLLocationDistance kilometes = [location distanceFromLocation:dist];
    
    self.distanceL.text = [NSString stringWithFormat:@"%0.2fkm",kilometes/1000];
    

}

-(CGFloat)cellHeight{
    return 75-20+self.addressLHeight.constant;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
