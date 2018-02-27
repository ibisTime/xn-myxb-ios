//
//  AppointmentOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,AppointmentOrderStatus) {
    
    AppointmentOrderStatusAllOrder = -1,      //全部
    AppointmentOrderStatusWillCheck = 0,      //待审核
    AppointmentOrderStatusWillVisit = 1,      //待上门
    AppointmentOrderStatusWillOverClass = 2,  //待下课
    AppointmentOrderStatusDidOverClass = 3,   //待录入
    AppointmentOrderStatusDidComplete = 4,    //已完成
    
};

@interface AppointmentOrderListVC : BaseViewController
//订单状态
@property (nonatomic,assign) AppointmentOrderStatus status;
//预约类型
@property (nonatomic, copy) NSString *kind;

@property (nonatomic,copy) NSString *statusCode;

@end
