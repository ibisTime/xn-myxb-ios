//
//  LDCalendarView.h
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDCalendarConst.h"
#import "TripInfoModel.h"

typedef void(^DaysSelectedBlock)(NSArray *result);

@interface LDCalendarView : UIView

@property (nonatomic, strong) NSArray *defaultDays;

@property (nonatomic, copy) DaysSelectedBlock complete;
//行程列表
@property (nonatomic, strong) NSArray <TripInfoModel *>*dateArr;
//今天的日期
@property (nonatomic, copy) NSString *todayDate;

- (id)initWithFrame:(CGRect)frame;

- (void)show;

@end
