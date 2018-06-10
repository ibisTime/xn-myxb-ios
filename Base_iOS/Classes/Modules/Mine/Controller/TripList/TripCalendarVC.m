//
//  TripCalendarVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TripCalendarVC.h"
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "NSString+Date.h"


#import "TLProgressHUD.h"
#import "CommentModel.h"
#import "TripInfoModel.h"

@interface TripCalendarVC ()
@property (nonatomic , strong)LDCalendarView *calendarView;
@property (nonatomic , copy)NSString *chouseYear;
@property (nonatomic , copy)NSString *chouseMouth;

@end

@implementation TripCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BaseWeakSelf;
    self.title = @"行程日历";
    
    self.chouseYear = [NSString getCurrentTimesTimeStampStr:@"yyyy"];
    self.chouseMouth = [NSString getCurrentTimesTimeStampStr:@"MM"];
    
    self.calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,300)];
    self.calendarView.todayDate = [NSString getCurrentTimesTimeStampStr:@"yyy-MM-dd"];
    self.calendarView.clickMounteh = ^(NSString *date) {
        NSLog(@"----->当前%@",date);
        
        NSArray *arry = [date componentsSeparatedByString:@"-"];
        
        weakSelf.chouseMouth = [arry objectAtIndex:1];
        weakSelf.chouseYear = [arry firstObject];
        [weakSelf requestCalendar];
        
    };
    [self.view addSubview:self.calendarView];
    
    [self.calendarView show];
    
    [self requestCalendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCalendar
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805509";
//    helper.limit = 10;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"month"] = self.chouseMouth;
    http.parameters[@"year"] = self.chouseYear;
    
    
//    [helper modelClass:[CommentModel class]];
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"---->%@",responseObject);
        NSMutableArray *arry = [TripInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.calendarView.dateArr =arry;
    } failure:^(NSError *error) {
        
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
