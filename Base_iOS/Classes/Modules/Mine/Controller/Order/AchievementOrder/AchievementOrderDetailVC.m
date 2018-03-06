//
//  AchievementOrderDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AchievementOrderDetailVC.h"
//Macro
#import "AppMacro.h"
//Category
#import "NSString+Date.h"
#import "NSString+Check.h"
//V
#import "OrderParamCell.h"
//C
#import "NavigationController.h"

@interface AchievementOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) TLTableView *tableView;
//标题
@property (nonatomic, strong) NSArray *textArr;
//内容
@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation AchievementOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成果详情";
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
    
    if ([self.order.status isEqualToString:kAchievementOrderStatusWillVisit]) {
        
        //确认上门
        self.tableView.height = kSuperViewHeight - kTabBarHeight;
        
        UIButton *visitBtn = [UIButton buttonWithTitle:@"确认上门"
                                            titleColor:kWhiteColor
                                       backgroundColor:kAppCustomMainColor
                                             titleFont:18.0];
        
        visitBtn.frame = CGRectMake(0, self.tableView.yy, kScreenWidth, 49);
        
        [visitBtn addTarget:self action:@selector(confirmVisit) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:visitBtn];
        
    } else if ([self.order.status isEqualToString:kAchievementOrderStatusWillOverClass]) {
        
        //培训结束
        self.tableView.height = kSuperViewHeight - kTabBarHeight;
        
        CGFloat w = kScreenWidth;
        CGFloat x = 0;
        
        UIButton *overClassBtn = [UIButton buttonWithTitle:@"培训结束"
                                                titleColor:kWhiteColor
                                           backgroundColor:kAppCustomMainColor
                                                 titleFont:18.0];
        overClassBtn.frame = CGRectMake(x, self.tableView.yy, w, 49);
        
        [overClassBtn addTarget:self action:@selector(overClass) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:overClassBtn];
        
    }
    
}

- (void)setOrder:(AchievementOrderModel *)order {
    
    _order = order;
    
    MryUser *user = self.order.mryUser;
    //美容院
    NSString *name = user.realName;
    STRING_NIL_NULL(name);
    //预约开始时间
    NSString *startDate = [self.order.appointDatetime convertToDetailDate];
    STRING_NIL_NULL(startDate);
    //实际开始时间
    NSString *realDate = [self.order.realDatetime convertToDetailDate];
    STRING_NIL_NULL(realDate);
    //预约天数
    NSString *day = [NSString stringWithFormat:@"%ld天", self.order.appointDays];
    //实际天数
    NSString *realDay = [NSString stringWithFormat:@"%ld天", self.order.realDays];
    STRING_NIL_NULL(realDay);
    //预约排班时间
    NSString *planDate = [self.order.planDatetime convertToDetailDate];
    STRING_NIL_NULL(planDate)
    //预约排班天数
    NSString *planDay = [NSString stringWithFormat:@"%ld天", self.order.planDays];
    STRING_NIL_NULL(planDay);
    //见客户量
    NSString *clientNum = [NSString stringWithFormat:@"%ld", self.order.clientNumber];
    STRING_NIL_NULL(clientNum)
    //成交客户量
    NSString *subNum = [NSString stringWithFormat:@"%ld", self.order.sucNumber];
    STRING_NIL_NULL(subNum);
    //销售业绩
    NSString *saleAmount = [self.order.saleAmount convertToRealMoney];
    STRING_NIL_NULL(saleAmount);
    //状态
    NSString *status = [self.order getStatusName];
    STRING_NIL_NULL(status);
//    //积分奖励
//    NSString *integralAmount = @"";
//    STRING_NIL_NULL(integralAmount);

    if ([self.order.status isEqualToString:kAchievementOrderStatusDidComplete] && [[TLUser user].kind isEqualToString:kUserTypeExpert]) {
        
        self.textArr = @[@"美容院", @"开始时间", @"天数", @"见客户量", @"成交客户量", @"销售业绩", @"状态", @"积分奖励"];
        self.contentArr = @[name, realDate, realDay, clientNum, subNum, saleAmount, status, ];
        
    } else if ([self.order.status isEqualToString:kAchievementOrderStatusWillCheck]) {
        
        self.textArr = @[@"美容院", @"预约开始时间", @"预约天数", @"状态"];
        self.contentArr = @[name, startDate, day, status];
        
    } else {
        
        self.textArr = @[@"美容院", @"预约开始时间", @"预约天数", @"预约排班时间", @"预约排班天数", @"状态"];

        self.contentArr = @[name, startDate, day, planDate, planDay, status];
        
    }
    
}

#pragma mark - Events
//上门
- (void)confirmVisit {
    
    [TLAlert alertWithTitle:@"" msg:@"确认已上门?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805512";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        //    http.parameters[@"token"] = [TLUser user].token;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"上门成功"];
            
            if (_overClassSuccess) {
                
                _overClassSuccess();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}

- (void)overClass {
    
    [TLAlert alertWithTitle:@"" msg:@"确认已下课?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"805513";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"下课成功"];
            
            if (_visitSuccess) {
                
                _visitSuccess();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //订单是已完成并且角色是专家的情况下有录入信息
    if ([self.order.status isEqualToString:kAchievementOrderStatusDidComplete] && [[TLUser user].kind isEqualToString:kUserTypeExpert]) {
        
        return 7;
    } else {
        
        if ([self.order.status isEqualToString:kAchievementOrderStatusWillCheck]) {
            
            return 4;
        }
        return 6;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderDetailCellId = @"OrderParamCell";
    OrderParamCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
    if (!cell) {
        
        cell = [[OrderParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
    }
    
    if ([self.order.status isEqualToString:kAchievementOrderStatusDidComplete] && [[TLUser user].kind isEqualToString:kUserTypeExpert]) {
        
        if (indexPath.row == 6 || indexPath.row == 7) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
        
    } else if ([self.order.status isEqualToString:kAchievementOrderStatusWillCheck]) {
        
        if (indexPath.row == 3) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
        
    } else {
        
        if (indexPath.row == 5) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
    }
    
    cell.textLbl.text = self.textArr[indexPath.row];
    cell.contentLbl.text = self.contentArr[indexPath.row];
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
