//
//  AppointmentOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderListVC.h"
//Category
#import "NSString+Date.h"
//M
#import "AppointmentOrderModel.h"
//V
#import "AppointmentOrderCell.h"
#import "OrderFooterView.h"
//C
#import "AppointmentOrderDetailVC.h"
#import "NavigationController.h"
#import "BrandCommentVC.h"

@interface AppointmentOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <AppointmentOrderModel *>*orderGroups;
//暂无订单
@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation AppointmentOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取订单列表
    [self requestOrderList];
    //
    [self.tableView beginRefreshing];
    //通知
    [self addNotification];
    
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = @"暂无订单";
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)
                                                         delegate:self
                                                       dataSource:self];
    
    tableView.rowHeight = 100;
    
    tableView.placeHolderView = self.placeHolderView;
    
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
- (void)orderEventsWithType:(OrderEventsType)type order:(AppointmentOrderModel *)order {
    
    switch (type) {
            
        case OrderEventsTypeComment:
        {
            //对宝贝进行评价
            BrandCommentVC *commentVC = [[BrandCommentVC alloc] init];
            
            commentVC.code = order.code;
            commentVC.commentKind = order.type;
            commentVC.placeholder = [NSString stringWithFormat:@"请对%@进行评论", [order getUserType]];

            [commentVC setCommentSuccess:^(){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
            }];
            
            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVC];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Data
- (void)requestOrderList {
    
    //全部（不传） 0 待发货 2待评价 3已完成 4无货取消
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805520";
    
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    helper.parameters[@"orderColumn"] = @"apply_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"type"] = self.kind;
    
    if (self.status == AppointmentOrderStatusWillCheck) {
        
        helper.parameters[@"status"] = @"1";
        
    }else if (self.status == AppointmentOrderStatusWillVisit) {
        
        helper.parameters[@"status"] = @"2";
        
    }else if (self.status == AppointmentOrderStatusWillOverClass)  {
        
        helper.parameters[@"status"] = @"4";
        
    }else if (self.status == AppointmentOrderStatusDidOverClass)  {
        
        helper.parameters[@"status"] = @"5";
        
    }else if(self.status == AppointmentOrderStatusDidComplete) {
        
        helper.parameters[@"status"] = @"6";
        
    } else {//全部
        
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AppointmentOrderModel class]];
    
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
    
    AppointmentOrderDetailVC *vc = [[AppointmentOrderDetailVC alloc] init];
    
    vc.order = self.orderGroups[indexPath.section];
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    AppointmentOrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrder:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"OrderFooterViewId";
    
    OrderFooterView *footerView = [[OrderFooterView alloc] initWithReuseIdentifier:footerId];
    
    AppointmentOrderModel *order = self.orderGroups[section];
    
    footerView.orderBlock = ^(OrderEventsType type) {
        
        [weakSelf orderEventsWithType:type order:order];
        
    };
    
    footerView.appointmentOrder = self.orderGroups[section];
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    AppointmentOrderModel *order = self.orderGroups[section];

    //上门、下课和评价
    if ([order.isComment isEqualToString:@"0"] && [order.status integerValue] > [kAppointmentOrderStatusWillOverClass integerValue]) {

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
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}

- (UIView *)headerViewWithOrder:(AppointmentOrderModel *)order {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
