//
//  SubscribeDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubscribeRecordModel;

@interface SubscribeDetailViewController : UIViewController
- (instancetype)initWithSubscribe:(SubscribeRecordModel *)subscribe;

//-(instancetype)initWithAppointment:(AppointmentModel *)appointmentModel;
@property (nonatomic, copy) NSString *relatedId;
@end
