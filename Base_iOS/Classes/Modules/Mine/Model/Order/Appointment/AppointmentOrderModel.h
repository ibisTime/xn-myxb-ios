//
//  AppointmentOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
@class AppointmentUser;

@interface AppointmentOrderModel : BaseModel
//订单状态
@property (nonatomic, copy) NSString *status;
//订单编号
@property (nonatomic, copy) NSString *code;
//预约开始时间
@property (nonatomic, copy) NSString *appointDatetime;
//预约天数
@property (nonatomic, assign) NSInteger appointDays;
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

@property (nonatomic, copy) NSString *applyNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, copy) NSString *applyDatetime;

- (NSString *)getStatusName;

- (NSString *)getUserType;

@end

@interface AppointmentUser : NSObject

//角色类型
@property (nonatomic, copy) NSString *kind;
//昵称
@property (nonatomic, copy) NSString *nickname;
//头像
@property (nonatomic, copy) NSString *photo;

@end


FOUNDATION_EXTERN NSString *const kAppointmentOrderStatusWillCheck;    //待审核
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatusWillVisit;    //待上面
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatusWillOverClass;//待下课
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatusDidOverClass; //待录入
FOUNDATION_EXTERN NSString *const kAppointmentOrderStatusDidComplete;  //已完成
