//
//  PropertyAddressCell.m
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  缴费地址cell

#import "PropertyAddressCell.h"

@interface PropertyAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation PropertyAddressCell

- (void)dataDidChange
{
    if ( [self.data isKindOfClass:[PaymentAddressModel class]] )
    {
        PaymentAddressModel * address = self.data;
        
        self.communityLabel.text = address.communityName;
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",address.build,address.room];
    }
    
}

@end
