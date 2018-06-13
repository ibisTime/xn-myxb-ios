//
//  AppointmentOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
@class AppointmentUser, MryUserTwo;

@interface AppointmentOrderModel : BaseModel
//订单状态
@property (nonatomic, copy) NSString *status;
//订单编号
@property (nonatomic, copy) NSString *code;
//预约开始时间
@property (nonatomic, copy) NSString *appointDatetime;
//预约天数
@property (nonatomic, assign) NSInteger appointDays;

@property (nonatomic, assign) NSNumber *deductAmount;

//预约排班时间
@property (nonatomic, copy) NSString *planDatetime;
//预约排班天数
@property (nonatomic, assign) NSInteger planDays;
//审核时间
@property (nonatomic, copy) NSString *approveDatetime;
//是否评论(0 未评论 1 已评论)
@property (nonatomic, copy) NSString *isComment;
//预约用户信息
@property (nonatomic, strong) AppointmentUser *user;
//美容院信息
@property (nonatomic, strong) MryUserTwo *mryUser;

@property (nonatomic, copy) NSString *applyNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, copy) NSString *applyDatetime;
//开始时间
@property (nonatomic, copy) NSString *realDatetime;
//工作天数
@property (nonatomic, copy) NSString *realDays;
//见客户数
@property (nonatomic, copy) NSString *clientNumber;
//c成交客户数
@property (nonatomic, copy) NSString *sucNumber;
//销售业绩
@property (nonatomic, copy) NSString *saleAmount;



- (NSString *)getStatusName;

- (NSString *)getUserType;

@end

@interface AppointmentUser : NSObject

//角色类型
@property (nonatomic, copy) NSString *kind;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//头像
@property (nonatomic, copy) NSString *photo;

@end

@interface MryUserTwo : NSObject

//店名
@property (nonatomic, copy) NSString *storeName;

//角色类型
@property (nonatomic, copy) NSString *kind;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//头像
@property (nonatomic, copy) NSString *photo;

@end

FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_1;    //待接单
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_2;    //待上门
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_3;    //无档期
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_4;//待下课
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_5; //待录入
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_6;  //已录入
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_7;  //经销商审核通过
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_8;  //经销商审核不通过
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_9;  //已支付
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_10;  //已完成
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatus_11;  //后台审核不通过

