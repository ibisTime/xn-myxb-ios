//
//  AchievementOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AchievementOrderModel.h"
#import "TLUser.h"

NSString *const kAchievementOrderStatusWillCheck = @"1";    //待审核
NSString *const kAchievementOrderStatusWillVisit = @"2";    //待上面
NSString *const kAchievementOrderStatusWillOverClass = @"4";//待下课
NSString *const kAchievementOrderStatusDidOverClass = @"5"; //待录入
NSString *const kAchievementOrderStatusDidComplete = @"6";  //已完成

@implementation AchievementOrderModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           kAchievementOrderStatusWillCheck : @"待审核",
                           kAchievementOrderStatusWillVisit : @"待上门",
                           kAchievementOrderStatusWillOverClass : @"待下课",
                           kAchievementOrderStatusDidOverClass : @"待录入",
                           kAchievementOrderStatusDidComplete : @"已完成",
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

@implementation MryUser

@end
