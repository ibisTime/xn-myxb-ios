//
//  AppointmentListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "AppointmentListModel.h"

@interface AppointmentListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <AppointmentListModel *>*appointmentList;

@end
