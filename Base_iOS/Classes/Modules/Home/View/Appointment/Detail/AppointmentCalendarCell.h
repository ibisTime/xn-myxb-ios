//
//  AppointmentCalendarCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "AppointmentListModel.h"
#import "TripInfoModel.h"

@interface AppointmentCalendarCell : BaseTableViewCell
//
@property (nonatomic, strong) AppointmentListModel *appointment;
//
@property (nonatomic, strong) NSArray <TripInfoModel *>*trips;

@end
