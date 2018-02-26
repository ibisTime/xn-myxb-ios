 //
//  TLUser.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserExt.h"

@class TLUserExt;

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
//等级
@property (nonatomic, copy) NSString *level;
//邮箱
@property (nonatomic, copy) NSString *email;
//积分账户
@property (nonatomic, copy) NSString *jfAccountNumber;
//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//邀请人个数
@property (nonatomic, copy) NSString *referrerNum;


+ (instancetype)user;

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

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;
