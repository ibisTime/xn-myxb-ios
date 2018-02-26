//
//  AppointmentCalendarCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentCalendarCell.h"

//V
#import "LDCalendarView.h"
#import "NSDate+extend.h"

@interface AppointmentCalendarCell()
//日历
@property (nonatomic, strong) LDCalendarView *calendarView;
//
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AppointmentCalendarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
 
    BaseWeakSelf;
    
    _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,300)];
    
    [self addSubview:_calendarView];
    
    [_calendarView show];
    
}

- (void)clickLeft {
    
    
}

#pragma mark - Setting
- (void)setAppointment:(AppointmentListModel *)appointment {
    
    _appointment = appointment;
    _calendarView.todayDate = appointment.currentTime;
}

- (void)setTrips:(NSArray<TripInfoModel *> *)trips {
    
    _trips = trips;
    
    _calendarView.dateArr = trips;
}
@end
