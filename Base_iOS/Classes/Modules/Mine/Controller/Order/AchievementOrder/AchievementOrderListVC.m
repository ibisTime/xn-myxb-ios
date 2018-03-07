//
//  AchievementOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AchievementOrderListVC.h"
//Category
#import "NSString+Date.h"
//M
#import "AchievementOrderModel.h"
//V
#import "AppointmentOrderCell.h"
#import "OrderFooterView.h"
#import "TLPlaceholderView.h"
//C
#import "AchievementOrderDetailVC.h"
#import "NavigationController.h"

@interface AchievementOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <AchievementOrderModel *>*orderGroups;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation AchievementOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    //
    [self initTableView];
    //获取订单列表
    [self requestOrderList];
    //
    [self.tableView beginRefreshing];
    //通知
    [self addNotification];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //重新获取订单列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)
                                                         delegate:self
                                                       dataSource:self];
    
    tableView.rowHeight = 100;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无订单"];

    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:@"RefreshOrderList" object:nil];
}

- (void)refreshOrder {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events
- (void)orderEventsWithType:(OrderEventsType)type order:(AchievementOrderModel *)order {
    
    switch (type) {
            
        case OrderEventsTypeVisit:
        {
            [TLAlert alertWithTitle:@"" msg:@"确认已上门?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"805512";
                http.parameters[@"code"] = order.code;
                http.parameters[@"updater"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"上门成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
        }break;
            
        case OrderEventsTypeOverClass:
        {
            [TLAlert alertWithTitle:@"" msg:@"确认已下课?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"805513";
                http.parameters[@"code"] = order.code;
                http.parameters[@"updater"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"下课成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Data
- (void)requestOrderList {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805520";
    
    helper.parameters[@"owner"] = [TLUser user].userId;
//    helper.parameters[@"orderColumn"] = @"apply_datetime";
//    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"type"] = [TLUser user].kind;
    helper.parameters[@"status"] = self.status;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AchievementOrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AchievementOrderDetailVC *vc = [[AchievementOrderDetailVC alloc] init];
    
    vc.order = self.orderGroups[indexPath.section];
    
    //上门
    vc.visitSuccess = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
    };
    //下课
    vc.overClassSuccess = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    AchievementOrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrder:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"OrderFooterViewId";
    
    OrderFooterView *footerView = [[OrderFooterView alloc] initWithReuseIdentifier:footerId];
    
    AchievementOrderModel *order = self.orderGroups[section];
    
    footerView.orderBlock = ^(OrderEventsType type) {
        
        [weakSelf orderEventsWithType:type order:order];
        
    };
    
    footerView.achievementOrder = self.orderGroups[section];
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    AchievementOrderModel *order = self.orderGroups[section];
    
    //上门、下课
    if ([order.status isEqualToString:kAppointmentOrderStatusWillVisit] || [order.status isEqualToString:kAppointmentOrderStatusWillOverClass]) {
        
        return 50;
    }
    return 0.00001;
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *OrderGoodsCellId = @"AppointmentOrderCell";
    AppointmentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsCellId];
    if (!cell) {
        
        cell = [[AppointmentOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderGoodsCellId];
    }
    
    cell.achievementOrder = self.orderGroups[indexPath.section];
    
    return cell;
    
}

- (UIView *)headerViewWithOrder:(AchievementOrderModel *)order {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerV.backgroundColor = kBackgroundColor;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:Font(11)
                                  textColor:kTextColor2];
    [headerV addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.top.equalTo(headerV.mas_top).offset(10);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"订单编号: %@", order.code];
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:Font(12)
                                  textColor:kThemeColor];
    lbl2.text = [order getStatusName];
    
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerV.height - 0.7, kScreenWidth, 0.7)];
    line.backgroundColor = kLineColor;
    [headerV addSubview:line];
    
    return headerV;
    
}


@end
