 //
//  TLUser.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class AdviserUser, HandlerUser;

@interface TLUser : TLBaseModel

/*
 基础需求
 */
//用户ID
@property (nonatomic, copy) NSString *userId;
//Token
@property (nonatomic, copy) NSString *token;
//手机号
@property (nonatomic, copy) NSString *mobile;
//前端类型
@property (nonatomic, copy) NSString *kind;
//头像
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickname;
//性别
@property (nonatomic, copy) NSString *gender;
//登录名
@property (nonatomic, copy) NSString *loginName;
//用户名
@property (nonatomic, strong) NSString *userName;
//用户密码
@property (nonatomic, strong) NSString *userPassward;
/*
 业务需求
 */
//真实姓名
@property (nonatomic, copy) NSString *realName;
//个人简介
@property (nonatomic, copy) NSString *introduce;
//账号状态  0.游客  1待签约   2 已签约
@property (nonatomic, assign) NSString *signStatus;

@property (nonatomic , assign)BOOL isSing;
//广告语
@property (nonatomic, copy) NSString *slogan;
//擅长领域
@property (nonatomic, copy) NSString *speciality;
//授课风格
@property (nonatomic, copy) NSString *style;
//等级
@property (nonatomic, copy) NSString *level;
//团队顾问信息
@property (nonatomic, strong) AdviserUser *adviserUser;
//经纪人信息
@property (nonatomic, strong) HandlerUser *handlerUser;
//积分账户
@property (nonatomic, copy) NSString *jfAccountNumber;
//人民币
@property (nonatomic, copy) NSString *rmbAccountNumber;

//人民币余额
@property (nonatomic, copy) NSString *rmbamount;
//积分余额
@property (nonatomic, copy) NSString *jfamount;
//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//邀请人个数
@property (nonatomic, copy) NSString *referrerNum;
//待支付数量
@property (nonatomic) NSInteger toPayCount;
//待收货数量
@property (nonatomic) NSInteger toReceiceCount;
//服务商专家待录入
@property (nonatomic) NSInteger fwInputCount;
//服务商专家待上门
@property (nonatomic) NSInteger fwToClassCount;
//服务商专家待接单
@property (nonatomic) NSInteger fwToBookCount;
//服务商专家待下课
@property (nonatomic) NSInteger fwClassEndCount;
//经销商待审核数量
@property (nonatomic) NSInteger jxsToApproveCount;


+ (instancetype)user;
//获取角色
- (NSString *)getUserType;
//
- (NSString *)getUserTypeWithKind:(NSString *)kind;

//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;
//用户已登录状态，则重新登录
- (void)reLogin;
//保存登录账号和密码
- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd;
//登出
- (void)loginOut;
//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;
//设置用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;
//异步更新用户信息
- (void)updateUserInfo;
//查询账户余额
- (void)requestAccountNumberWith:(NSString *)type;

//获取订单维度数
- (void)requestOrederNorReadNumber;
//获取预约未读数
- (void)requestAppointmentNorReadNumber;


@end

@interface AdviserUser: NSObject

//团队顾问手机号
@property (nonatomic, copy) NSString *mobile;

@end

@interface HandlerUser: NSObject

//经纪人手机号
@property (nonatomic, copy) NSString *mobile;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;
FOUNDATION_EXTERN  NSString *const kUserNotReadNumberNotification;
//角色类型
FOUNDATION_EXTERN  NSString *const kUserTypeSalon;
FOUNDATION_EXTERN  NSString *const kUserTypeBeautyGuide;
FOUNDATION_EXTERN  NSString *const kUserTypeLecturer;
FOUNDATION_EXTERN  NSString *const kUserTypeExpert;
FOUNDATION_EXTERN  NSString *const kUserTypePartner;


