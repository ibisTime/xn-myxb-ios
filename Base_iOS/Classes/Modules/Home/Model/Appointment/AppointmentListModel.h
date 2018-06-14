//
//  AppointmentListModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface AppointmentListModel : BaseModel

//签约状态 0 游客 1未签约  2 已签约
@property (nonatomic, copy) NSString *signStatus;

//用户编号
@property (nonatomic, copy) NSString *userId;
//头像
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickname;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//经纪人手机号
@property (nonatomic, copy) NSString *mobile;
//经纪人编号
@property (nonatomic, copy) NSString *handler;
//性别
@property (nonatomic, copy) NSString *gender;
//职业
@property (nonatomic, copy) NSString *job;
//专长
@property (nonatomic, copy) NSString *speciality;
//风格
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *styleName;

@property (nonatomic, strong) NSArray <NSString *>*styles;
@property (nonatomic, strong) NSArray <UIColor *>*styleColor;
//评分
@property (nonatomic, copy) NSString *level;
//个人简介
@property (nonatomic, copy) NSString *introduce;
//预约状态
@property (nonatomic, copy) NSString *status;
//类型
@property (nonatomic, copy) NSString *kind;
//广告语
@property (nonatomic, copy) NSString *slogan;
//
@property (nonatomic, assign) CGFloat cellHeight;
//是否折叠
@property (nonatomic, assign) BOOL isFold;
//
@property (nonatomic, assign) CGFloat tripHeight;
//
@property (nonatomic, assign) CGFloat commentHeight;
//
@property (nonatomic, assign) CGFloat contentHeight;
//总条数
@property (nonatomic, assign) NSInteger totalCount;
//平均分
@property (nonatomic, assign) CGFloat average;
//当前服务器时间
@property (nonatomic, copy) NSString *currentTime;

//
- (NSString *)getUserType;

@end
