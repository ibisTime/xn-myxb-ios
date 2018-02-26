//
//  AppointmentTripCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AppointmentListModel.h"

@interface AppointmentTripCell : BaseTableViewCell

//image
@property (nonatomic, strong) UIImageView *iconIV;
//arrow
@property (nonatomic, strong) UIImageView *arrowIV;
//
@property (nonatomic, strong) AppointmentListModel *detailModel;
@end
