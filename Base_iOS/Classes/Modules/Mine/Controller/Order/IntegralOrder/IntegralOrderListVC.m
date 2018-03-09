//
//  IntegralOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderListVC.h"

//Category
#import "NSString+Date.h"
//M
#import "IntegralOrderModel.h"
//V
#import "IntegralOrderGoodCell.h"
#import "IntegralOrderFooterView.h"
#import "TLPlaceholderView.h"
//C
#import "IntegralOrderDetailVC.h"
#import "NavigationController.h"
#import "SendCommentVC.h"

@interface IntegralOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <IntegralOrderModel *>*orderGroups;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation IntegralOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirst = YES;
    
    [self initTableView];
    
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
    
    self.tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)
                                                         delegate:self
                                                       dataSource:self];
    
    self.tableView.rowHeight = 100;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无订单"];

    [self.view addSubview:self.tableView];
        
    //--//
    
    //全部（不传） 0 待发货 2待评价 3已完成 4无货取消
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805294";
    
    helper.parameters[@"applyUser"] = [TLUser user].userId;
//    helper.parameters[@"orderColumn"] = @"update_datetime";
//    helper.parameters[@"orderDir"] = @"desc";
    
    if (self.status == IntegralOrderStatusWillSend) {
        
        helper.parameters[@"status"] = @"0";
        
    }else if (self.status == IntegralOrderStatusWillReceipt)  {
        
        helper.parameters[@"status"] = @"1";
        
    } else if (self.status == IntegralOrderStatusWillComment)  {
        
        helper.parameters[@"status"] = @"2";
        
    } else if(self.status == IntegralOrderStatusDidComplete) {
        
        helper.parameters[@"status"] = @"3";
        
    } else if(self.status == IntegralOrderStatusDidCancel) {
        
        helper.parameters[@"status"] = @"4";
        
    } else {//全部
        
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[IntegralOrderModel class]];
    
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

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:@"RefreshOrderList" object:nil];
}

- (void)refreshOrder {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events
- (void)orderEventsWithType:(IntegralOrderEventsType)type order:(IntegralOrderModel *)order {

    switch (type) {

        case IntegralOrderEventsTypeReceiptGood:
        {
            [TLAlert alertWithTitle:@"" msg:@"确认已收货?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.showView = self.view;
                http.code = @"805296";
                http.parameters[@"orderCode"] = order.code;
                http.parameters[@"updater"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"收货成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
            
        }break;
            
        case IntegralOrderEventsTypeComment:
        {
            //对宝贝进行评价
            SendCommentVC *sendCommentVC = [[SendCommentVC alloc] init];

            sendCommentVC.code = order.code;
            
            [sendCommentVC setCommentSuccess:^(){

                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
            }];

            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:sendCommentVC];

            [self presentViewController:nav animated:YES completion:nil];

        }break;

        default:
            break;
    }

}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IntegralOrderDetailVC *vc = [[IntegralOrderDetailVC alloc] init];
    
    vc.order = self.orderGroups[indexPath.section];

    //评价
    vc.commentSuccess = ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    IntegralOrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrder:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"OrderFooterViewId";
    
    IntegralOrderFooterView *footerView = [[IntegralOrderFooterView alloc] initWithReuseIdentifier:footerId];
    
    IntegralOrderModel *order = self.orderGroups[section];
    
    footerView.orderBlock = ^(IntegralOrderEventsType type) {
        
        [weakSelf orderEventsWithType:type order:order];
        
    };
    
    footerView.order = self.orderGroups[section];
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    IntegralOrderModel *order = self.orderGroups[section];
    
    if ([order.status isEqualToString:kOrderStatusWillReceiveGood] || [order.status isEqualToString:kOrderStatusWillComment]) {
        
        return 50;
    }
    return 0.00001;
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSArray *arr = self.orderGroups[section].productOrderList;
    //    return arr.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *OrderGoodsCellId = @"IntegralOrderGoodCell";
    IntegralOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsCellId];
    if (!cell) {
        
        cell = [[IntegralOrderGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderGoodsCellId];
    }
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}

- (UIView *)headerViewWithOrder:(IntegralOrderModel *)order {
    
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
