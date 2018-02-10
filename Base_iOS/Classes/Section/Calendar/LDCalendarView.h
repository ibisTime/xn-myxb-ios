//
//  LDCalendarView.h
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDCalendarConst.h"

typedef void(^DaysSelectedBlock)(NSArray *result);

@interface LDCalendarView : UIView

@property (nonatomic, strong) NSArray *defaultDays;

@property (nonatomic, copy) DaysSelectedBlock complete;
//签到日期
@property (nonatomic, strong) NSArray <NSString *>*dateArr;

- (id)initWithFrame:(CGRect)frame;

- (void)show;

@end
