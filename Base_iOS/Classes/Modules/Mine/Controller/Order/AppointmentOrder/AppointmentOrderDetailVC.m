//
//  AppointmentOrderDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderDetailVC.h"
//Macro
#import "AppMacro.h"
//Category
#import "NSString+Date.h"
#import "NSString+Check.h"
//V
#import "OrderParamCell.h"
//C
#import "NavigationController.h"
#import "BrandCommentVC.h"

@interface AppointmentOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;
//评论
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation AppointmentOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约详情";
    [self initTableView];
    //
    [self initEventsButton];
}

#pragma mark - Init

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight)
                                                    delegate:self
                                                  dataSource:self];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (void)initEventsButton {
    
    if ([self.order.isComment isEqualToString:@"0"] && [self.order.status integerValue] > [kAppointmentOrderStatusWillOverClass integerValue]) {
        
        //评价
        self.tableView.height = kSuperViewHeight - kTabBarHeight;
        
        CGFloat w = kScreenWidth;
        UIColor *bgColor = kAppCustomMainColor;
        UIColor *titleColor =  kWhiteColor;
        
        UIButton *commentBtn = [UIButton buttonWithTitle:@"前往评论"
                                              titleColor:titleColor
                                         backgroundColor:bgColor
                                               titleFont:18.0];
        commentBtn.frame = CGRectMake(0, self.tableView.yy, w, 49);
        
        [commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:commentBtn];
    }
}

#pragma mark - Events
//评价
- (void)comment {
    
    //对宝贝进行评价
    BrandCommentVC *commentVC = [[BrandCommentVC alloc] init];
    
    commentVC.code = self.order.code;
    commentVC.commentKind = self.order.type;
    commentVC.placeholder = [NSString stringWithFormat:@"请对%@进行评论", [self.order getUserType]];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.order.status isEqualToString:kAppointmentOrderStatusWillCheck]) {
        
        return 4;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderDetailCellId = @"OrderParamCell";
    OrderParamCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
    if (!cell) {
        
        cell = [[OrderParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
    }
    
    AppointmentUser *user = self.order.user;
    //
    NSString *name = user.realName;
    STRING_NIL_NULL(name);
    //
    NSString *startDate = [self.order.appointDatetime convertDate];
    STRING_NIL_NULL(startDate);
    //
    NSString *day = [NSString stringWithFormat:@"%ld天", self.order.appointDays];
    STRING_NIL_NULL(day);
    //
    NSString *planDate = [self.order.planDatetime convertToDetailDate];
    STRING_NIL_NULL(planDate)
    //
    NSString *planDay = [NSString stringWithFormat:@"%ld天", self.order.planDays];
    STRING_NIL_NULL(planDay);
    //
    NSString *status = [self.order getStatusName];
    STRING_NIL_NULL(status)
    
    NSArray *textArr;
    NSArray *contentArr;
    
    if ([self.order.status isEqualToString:kAppointmentOrderStatusWillCheck]) {
        
        textArr = @[[NSString stringWithFormat:@"预约%@", [self.order getUserType]], @"预约开始时间", @"预约天数", @"状态"];
        contentArr = @[name, startDate, day, status];

        if (indexPath.row == 3) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
        
    } else {
        
        textArr = @[[NSString stringWithFormat:@"预约%@", [self.order getUserType]], @"预约开始时间", @"预约天数", @"预约排班时间", @"预约排班天数", @"状态"];
        contentArr = @[name, startDate, day, planDate, planDay, status];
        
        if (indexPath.row == 5) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
    }
    
    cell.textLbl.text = textArr[indexPath.row];
    cell.contentLbl.text = contentArr[indexPath.row];
    [cell.contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@110);
        make.centerY.equalTo(@0);
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
