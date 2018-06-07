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

@interface TripCalendarVC ()
@property (nonatomic , strong)LDCalendarView *calendarView;

@end

@implementation TripCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"行程日历";
    
    self.calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,300)];
    self.calendarView.todayDate = [NSString getCurrentTimesTimeStampStr:@"yyy-MM-dd"];
    [self.view addSubview:self.calendarView];
    
    [self.calendarView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCalendar
{
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.showView = self.view;
    helper.code = @"805425";
    helper.limit = 10;
    helper.parameters[@"entityCode"] = [TLUser user].userId;
    helper.parameters[@"type"] = [TLUser user].kind;
    helper.parameters[@"status"] = @"AB";
    //    helper.parameters[@"orderColumn"] = @"update_datetime";
    //    helper.parameters[@"orderDir"] = @"desc";
    
    
    [helper modelClass:[CommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [TLProgressHUD dismiss];
        
//        weakSelf.tableView.commentList = objs;
//        weakSelf.tableView.detailModel = weakSelf.appomintment;
//        
//        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
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
