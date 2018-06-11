//
//  AppointmentCalendarCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentCalendarCell.h"
#import "TLNetworking.h"
//V
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import <MJExtension/MJExtension.h>

@interface AppointmentCalendarCell()
//日历
@property (nonatomic, strong) LDCalendarView *calendarView;
//
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic , copy)NSString *chouseYear;
@property (nonatomic , copy)NSString *chouseMouth;

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
    _calendarView.clickMounteh = ^(NSString *date) {
        
        NSArray *arry = [date componentsSeparatedByString:@"-"];
        
        weakSelf.chouseMouth = [arry objectAtIndex:1];
        weakSelf.chouseYear = [arry firstObject];
        [weakSelf requestCalendar];
        
    };
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

- (void)requestCalendar
{
    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
    http.code = @"805509";
    //    helper.limit = 10;
    http.parameters[@"userId"] = self.appointment.userId;
    http.parameters[@"month"] = self.chouseMouth;
    http.parameters[@"year"] = self.chouseYear;
    
    
    [http postWithSuccess:^(id responseObject) {
        self.trips = [TripInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
}
@end
