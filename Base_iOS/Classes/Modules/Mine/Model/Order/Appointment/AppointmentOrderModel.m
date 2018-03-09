//
//  AppointmentOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderModel.h"
#import "TLUser.h"

NSString *const kAppointmentOrderStatusWillCheck = @"1";    //待审核
NSString *const kAppointmentOrderStatusWillVisit = @"2";    //待上门
NSString *const kAppointmentOrderStatusDidCancel = @"3";    //无档期
NSString *const kAppointmentOrderStatusWillOverClass = @"4";//待下课
NSString *const kAppointmentOrderStatusDidOverClass = @"5"; //待录入
NSString *const kAppointmentOrderStatusDidComplete = @"6";  //已完成

@implementation AppointmentOrderModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           kAppointmentOrderStatusWillCheck : @"待审核",
                           kAppointmentOrderStatusWillVisit : @"待上门",
                           kAppointmentOrderStatusDidCancel : @"无档期",
                           kAppointmentOrderStatusWillOverClass : @"待下课",
                           kAppointmentOrderStatusDidOverClass : @"待录入",
                           kAppointmentOrderStatusDidComplete : @"已完成",
                           };
    
    return dict[self.status];
}

- (NSString *)getUserType {
    
    NSDictionary *dic = @{
                          kUserTypeBeautyGuide: @"美导",
                          kUserTypeLecturer: @"讲师",
                          kUserTypeExpert: @"专家",
                          };
    
    return dic[self.type];
}

@end

@implementation AppointmentUser

@end

