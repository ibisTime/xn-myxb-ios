//
//  AchievementOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class MryUser;
@interface AchievementOrderModel : BaseModel

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
//实际上门时间
@property (nonatomic, copy) NSString *realDatetime;
//实际天数
@property (nonatomic, assign) NSInteger realDays;
//见客户量
@property (nonatomic, assign) NSInteger clientNumber;
//成交客户量
@property (nonatomic, assign) NSInteger sucNumber;
//销售额
@property (nonatomic, strong) NSNumber *saleAmount;
//是否评论(0 未评论 1 已评论)
@property (nonatomic, copy) NSString *isComment;
//美容院信息
@property (nonatomic, strong) MryUser *mryUser;

@property (nonatomic, copy) NSString *applyNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, copy) NSString *applyDatetime;

- (NSString *)getStatusName;

- (NSString *)getUserType;

@end

@interface MryUser : NSObject

//角色类型
@property (nonatomic, copy) NSString *kind;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//头像
@property (nonatomic, copy) NSString *photo;

@end

FOUNDATION_EXTERN NSString *const kAchievementOrderStatusWillCheck;    //待审核
FOUNDATION_EXTERN NSString *const kAchievementOrderStatusWillVisit;    //待上面
FOUNDATION_EXTERN NSString *const kAchievementOrderStatusWillOverClass;//待下课
FOUNDATION_EXTERN NSString *const kAchievementOrderStatusDidOverClass; //待录入
FOUNDATION_EXTERN NSString *const kAchievementOrderStatusDidComplete;  //已完成
