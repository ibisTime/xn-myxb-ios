//
//  AppointmentOrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "AppointmentOrderModel.h"

@interface AppointmentOrderDetailVC : BaseViewController
//
@property (nonatomic, strong) AppointmentOrderModel *order;

@property (nonatomic, copy) NSString *kind;

@end
