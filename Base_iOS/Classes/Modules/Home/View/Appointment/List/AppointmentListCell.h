//
//  AppointmentListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
//M
#import "DataDictionaryModel.h"
#import "AppointmentListModel.h"

@interface AppointmentListCell : BaseTableViewCell

@property (nonatomic, strong) AppointmentListModel *appointmentModel;
//风格
@property (nonatomic, strong) NSArray <DataDictionaryModel *>*styles;

@end
