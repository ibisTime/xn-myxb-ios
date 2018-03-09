//
//  BrandOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderListVC.h"

//Category
#import "NSString+Date.h"
//M
#import "BrandOrderModel.h"
//V
#import "BrandOrderGoodCell.h"
#import "BrandOrderFooterView.h"
#import "TLPlaceholderView.h"
//C
#import "BrandOrderDetailVC.h"
#import "NavigationController.h"
#import "BrandCommentVC.h"

@interface BrandOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <BrandOrderModel *>*orderGroups;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation BrandOrderListVC

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
    
    self.tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)
                                                         delegate:self
                                                       dataSource:self];
    
    self.tableView.rowHeight = 100;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无订单"];

    [self.view addSubview:self.tableView];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:@"RefreshOrderList" object:nil];
}

- (void)refreshOrder {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events
- (void)orderEventsWithType:(BrandOrderEventsType)type order:(BrandOrderModel *)order {
    
    BaseWeakSelf;
    
    switch (type) {
            
        case BrandOrderEventsTypeComment:
        {
            //对宝贝进行评价
            BrandCommentVC *commentVC = [[BrandCommentVC alloc] init];
            
            commentVC.code = order.code;
            commentVC.commentKind = @"P";
            commentVC.type = OrderCommentTypeGood;
            commentVC.placeholder = @"宝贝满足你的期待吗? 说是它的优点吧";
            
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
    
    helper.code = @"805273";
    
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    helper.parameters[@"orderColumn"] = @"apply_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    
    if (self.status == BrandOrderStatusWillCheck) {
        
        helper.parameters[@"status"] = @"0";
        
    }else if (self.status == BrandOrderStatusWillSend) {
        
        helper.parameters[@"status"] = @"2";
        
    }else if (self.status == BrandOrderStatusWillComment)  {
        
        helper.parameters[@"status"] = @"3";
        
    } else if(self.status == BrandOrderStatusDidComplete) {
        
        helper.parameters[@"status"] = @"4";
        
    } else {//全部
        
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[BrandOrderModel class]];
    
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
    
    BaseWeakSelf;
    
    BrandOrderDetailVC *vc = [[BrandOrderDetailVC alloc] init];
    
    vc.order = self.orderGroups[indexPath.section];
    
    //评价
    vc.commentSuccess = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BrandOrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrder:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"OrderFooterViewId";
    
    BrandOrderFooterView *footerView = [[BrandOrderFooterView alloc] initWithReuseIdentifier:footerId];
    
    BrandOrderModel *order = self.orderGroups[section];
    
    footerView.orderBlock = ^(BrandOrderEventsType type) {
        
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
    
    BrandOrderModel *order = self.orderGroups[section];
    
    if ([order.status isEqualToString:kBrandOrderStatusWillComment]) {
        
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
    
    static NSString *OrderGoodsCellId = @"BrandOrderGoodCell";
    BrandOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsCellId];
    if (!cell) {
        
        cell = [[BrandOrderGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderGoodsCellId];
    }
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}

- (UIView *)headerViewWithOrder:(BrandOrderModel *)order {
    
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
