//
//  BrandOrderDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderDetailVC.h"

//Macro
#import "AppMacro.h"
//Category
#import "NSString+Date.h"
#import "NSString+Check.h"
//V
#import "ZHAddressChooseView.h"
#import "BrandOrderDetailCell.h"
#import "OrderParamCell.h"
//C
#import "NavigationController.h"
#import "BrandCommentVC.h"

@interface BrandOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic,strong) UILabel *totalPriceLbl;
//
@property (nonatomic,strong) ZHAddressChooseView *addressView;
//支付方式
@property (nonatomic, strong) UILabel *payLbl;
//物流公司
@property (nonatomic,strong) UILabel *expressNameLbl;
//物流单号
@property (nonatomic,strong) UILabel *expressCodeLbl;

@end

@implementation BrandOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
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

- (UIView *)footerViewWithStatus:(NSString *)status {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    footerView.backgroundColor = kClearColor;
    
    if ([status isEqualToString:kBrandOrderStatusWillSendGood]) {
        
        return footerView;
    }
    
    UIView *expressView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 70)];
    
    expressView.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:expressView];
    
    self.expressNameLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 16, kScreenWidth - 30, [Font(13) lineHeight])
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:Font(13)
                                        textColor:kTextColor];
    [expressView addSubview:self.expressNameLbl];
    
    self.expressCodeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin,  self.expressNameLbl.yy + 16, kScreenWidth - 30, self.expressNameLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:Font(13)
                                        textColor:kTextColor];
    [expressView addSubview:self.expressCodeLbl];
    
    return footerView;
}

- (void)loadData {
    
    //********headerView 数据
    self.addressView.nameLbl.text = [@"收货人：" add:self.order.receiver];
    self.addressView.mobileLbl.text = self.order.reMobile;
    self.addressView.addressLbl.text = [@"收货地址：" add:self.order.reAddress];
    //********headerView 数据
}

- (void)initEventsButton {
    
    if ([self.order.status isEqualToString:kBrandOrderStatusWillComment] || [self.order.status isEqualToString:kBrandOrderStatusDidComplete]) {// 已发货
        
        //footer
        self.tableView.tableFooterView = [self footerViewWithStatus:self.order.status];
        
        NSString *name = [self.order getExpressName];
        
        self.expressCodeLbl.text = [@"物流单号：" add:self.order.logisiticsCode];
        self.expressNameLbl.text = [@"物流公司：" add:name];
        
        if ([self.order.status isEqualToString:kBrandOrderStatusWillComment]) {
            
            //评价
            self.tableView.height = kSuperViewHeight - kTabBarHeight;
            
            UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.yy, kScreenWidth, 49) title:@"评价" backgroundColor:kAppCustomMainColor];
            
            [self.view addSubview:commentBtn];
            [commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
        }
    }
}

#pragma mark - Events
//评价
- (void)comment {
    
    //对宝贝进行评价
    BrandCommentVC *commentVC = [[BrandCommentVC alloc] init];
    
    commentVC.code = self.order.code;
    
    [commentVC setCommentSuccess:^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
    }];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *orderDetailCellId = @"BrandOrderDetailCell";
        BrandOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
        if (!cell) {
            
            cell = [[BrandOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
        }
        
        cell.order = self.order;
        
        return cell;
    }
    
    NSArray *textArr = @[@"产品名称", @"产品总价", @"下单数量", @"订单号", @"下单时间", @"状态"];
    //
    NSString *name = self.order.productName;
    STRING_NIL_NULL(name);
    //
    CGFloat totalAmount = [_order.amount doubleValue];
    NSString *amountStr = [NSString stringWithFormat:@"%@", [@(totalAmount) convertToSimpleRealMoney]];
    STRING_NIL_NULL(amountStr);
    //
    NSString *quantity = [self.order.quantity stringValue];
    STRING_NIL_NULL(quantity);
    //
    NSString *orderCode = self.order.code;
    STRING_NIL_NULL(orderCode);
    //
    NSString *date = [self.order.applyDatetime convertToDetailDate];
    STRING_NIL_NULL(date)
    //
    NSString *status = [self.order getStatusName];
    STRING_NIL_NULL(status);
    
    NSArray *contentArr = @[name, amountStr, quantity, orderCode, date, status];
    
    static NSString *orderDetailCellId = @"OrderParamCell";
    OrderParamCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
    if (!cell) {
        
        cell = [[OrderParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
        
    }
    
    cell.textLbl.text = textArr[indexPath.row];
    cell.contentLbl.text = contentArr[indexPath.row];
    
    if (indexPath.row == 5) {
        
        cell.contentLbl.textColor = kThemeColor;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 110;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    //
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    lineV.backgroundColor = kBackgroundColor;
    
    [sectionFooterView addSubview:lineV];
    
    if (section == 1) {
        
        //收货信息
        self.addressView = [[ZHAddressChooseView alloc] initWithFrame:CGRectMake(0, lineV.yy, kScreenWidth, 90)];
        self.addressView.type = ZHAddressChooseTypeDisplay;
        [sectionFooterView addSubview:self.addressView];
        //
        [self loadData];
        
        sectionFooterView.height = 100;
        
    }
    
    return sectionFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
