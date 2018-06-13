//
//  AppointmentOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderModel.h"
#import "TLUser.h"

//NSString *const kAppointmentOrderStatusWillCheck = @"1";    //待审核
//NSString *const kAppointmentOrderStatusWillVisit = @"2";    //待上门
//NSString *const kAppointmentOrderStatusDidCancel = @"3";    //无档期
//NSString *const kAppointmentOrderStatusWillOverClass = @"4";//待下课
//NSString *const kAppointmentOrderStatusDidOverClass = @"5"; //待录入
//NSString *const kAppointmentOrderStatusDidComplete = @"6";  //已完成
//
//@implementation AppointmentOrderModel
//
//- (NSString *)getStatusName {
//
//    NSDictionary *dict = @{
//                           kAppointmentOrderStatusWillCheck : @"待审核",
//                           kAppointmentOrderStatusWillVisit : @"待上门",
//                           kAppointmentOrderStatusDidCancel : @"无档期",
//                           kAppointmentOrderStatusWillOverClass : @"待下课",
//                           kAppointmentOrderStatusDidOverClass : @"待录入",
//                           kAppointmentOrderStatusDidComplete : @"已完成",
//                           };
//
//    return dict[self.status];
//}
NSString *const kAppointmentOrderStatus_1 = @"1";    //待接单
NSString *const kAppointmentOrderStatus_2 = @"2";    //待上门
NSString *const kAppointmentOrderStatus_3 = @"3";    //无档期
NSString *const kAppointmentOrderStatus_4 = @"4";//待下课
NSString *const kAppointmentOrderStatus_5 = @"5"; //待录入
NSString *const kAppointmentOrderStatus_6 = @"6";  //已录入
NSString *const kAppointmentOrderStatus_7 = @"7";  //经销商审核通过
NSString *const kAppointmentOrderStatus_8 = @"8";  //经销商审核不通过
NSString *const kAppointmentOrderStatus_9 = @"9";  //已支付
NSString *const kAppointmentOrderStatus_10 = @"10";  //已完成
NSString *const kAppointmentOrderStatus_11 = @"11";  //后台审核不通过


@implementation AppointmentOrderModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           kAppointmentOrderStatus_1 : @"待接单",
                           kAppointmentOrderStatus_2 : @"待上门",
                           kAppointmentOrderStatus_3 : @"无档期",
                           kAppointmentOrderStatus_4 : @"待下课",
                           kAppointmentOrderStatus_5 : @"待录入",
                           kAppointmentOrderStatus_6 : @"已录入",
                           kAppointmentOrderStatus_7 : @"经销商审核通过",
                           kAppointmentOrderStatus_8 : @"经销商审核不通过",
                           kAppointmentOrderStatus_9 : @"已支付",
                           kAppointmentOrderStatus_10 : @"已完成",
                           kAppointmentOrderStatus_11 : @"后台审核不通过",
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
@implementation MryUserTwo : NSObject

@end

