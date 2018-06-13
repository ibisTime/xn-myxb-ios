//
//  IntregalTaskHeaderView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, IntregalTaskType) {
    IntregalTaskTypeFlow = 0,   //积分流水
    IntregalTaskTypeExchange,   //积分兑换
    IntregalTaskTypeTask,//积分任务
};

@protocol IntregalTaskDelegate <NSObject>

- (void)didSelectedWithType:(IntregalTaskType)type idx:(NSInteger)idx;

@end

@interface IntregalTaskHeaderView :BaseView

@property (nonatomic, weak) id<IntregalTaskDelegate> delegate;

@property (nonatomic, assign) IntregalTaskType taskType;

@property (nonatomic, copy) NSString *jfNumText;

@property (nonatomic, strong) UILabel *jfLabel;

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) UILabel *textLabel;



@end
