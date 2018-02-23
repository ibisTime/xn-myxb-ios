//
//  IntegralOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderListVC.h"

//Macro
//Framework
//Category
#import "NSString+Date.h"
//Extension
//M
#import "IntegralOrderModel.h"
//V
#import "IntegralOrderGoodCell.h"
#import "IntegralOrderFooterView.h"
//C
#import "IntegralOrderDetailVC.h"
#import "NavigationController.h"
//#import "SendCommentVC.h"

@interface IntegralOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <IntegralOrderModel *>*orderGroups;
//暂无订单
@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation IntegralOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirst = YES;
    
    [self initPlaceHolderView];
    
    [self initTableView];
    
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
    
    //--//
    
    //全部（不传） 0 待发货 2待评价 3已完成 4无货取消
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805294";
    helper.isList = YES;
    
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    
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
        
        helper.parameters[@"orderColumn"] = @"update_datetime";
        helper.parameters[@"orderDir"] = @"desc";
        
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

    BaseWeakSelf;

    switch (type) {

        case IntegralOrderEventsTypeReceiptGood:
        {
            TLNetworking *http = [TLNetworking new];
            
            http.showView = self.view;
            http.code = @"808057";
            http.parameters[@"code"] = order.code;
            http.parameters[@"updater"] = [TLUser user].userId;
            http.parameters[@"remark"] = @"确认收货";
            http.parameters[@"token"] = [TLUser user].token;
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"收货成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
                
            } failure:^(NSError *error) {
                
                
            }];
        }break;
            
        case IntegralOrderEventsTypeComment:
        {
            //对宝贝进行评价
//            SendCommentVC *sendCommentVC = [[SendCommentVC alloc] init];
//
//            sendCommentVC.type =  SendCommentActionTypeComment;
//            sendCommentVC.toObjCode = order.code;
//
//            sendCommentVC.titleStr = @"评价";
//
//            [sendCommentVC setCommentSuccess:^(CommentModel *model){
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
//
//            }];
//
//            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:sendCommentVC];
//
//            [self presentViewController:nav animated:YES completion:nil];

        }break;

        default:
            break;
    }

}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    IntegralOrderDetailVC *vc = [[IntegralOrderDetailVC alloc] init];
    
//    vc.order = self.orderGroups[indexPath.section];
//
//    //评价
//    vc.commentSuccess = ^{
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
//    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    IntegralOrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrderNum:model.code date:model.applyDatetime];
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
    
    return 98;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
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

- (UIView *)headerViewWithOrderNum:(NSString *)num date:(NSString *)date {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
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
    lbl1.text = [NSString stringWithFormat:@"订单编号: %@", num];
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:Font(11)
                                  textColor:kTextColor2];;
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    lbl2.text = [date convertDate];
    
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
