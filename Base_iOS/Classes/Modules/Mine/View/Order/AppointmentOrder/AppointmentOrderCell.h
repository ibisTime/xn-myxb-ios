//
//  AppointmentOrderCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AppointmentOrderModel.h"
#import "AchievementOrderModel.h"

@interface AppointmentOrderCell : BaseTableViewCell
//
@property (nonatomic, strong) AppointmentOrderModel *order;
//
@property (nonatomic, strong) AchievementOrderModel *achievementOrder;

@end
