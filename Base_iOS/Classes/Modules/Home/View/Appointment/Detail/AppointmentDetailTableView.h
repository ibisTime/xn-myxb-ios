//
//  AppointmentDetailTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "AppointmentDetailModel.h"

@interface AppointmentDetailTableView : TLTableView
//
@property (nonatomic, strong) AppointmentDetailModel *detailModel;

@end
