//
//  IntregalFlowVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalFlowVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//V
#import "IntregalTaskHeaderView.h"
#import "IntregalRecordCell.h"
#import "TLPlaceholderView.h"
//M
#import "CurrencyModel.h"
#import "IntregalRecordModel.h"
//C
#import "HTMLStrVC.h"

@interface IntregalFlowVC ()

@property (nonatomic, strong) IntregalTaskHeaderView *headerView;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSMutableArray <IntregalRecordModel *>*recodes;

@end

@implementation IntregalFlowVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestIntregalRecodeList];
    
    [self requestUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"积分记录";
    
    self.recodes = [NSMutableArray array];

    [self initHeaderView];
    
    [self initTableView];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    //
    [self requestIntregalRecodeList];
    //
    [self requestUserInfo];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[IntregalTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    self.headerView.taskType = IntregalTaskTypeFlow;
    
    [self.view addSubview:self.headerView];
    
}

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, self.headerView.yy + 10, kScreenWidth, kScreenHeight - 64 - self.headerView.yy - 10) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无记录"];

    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestIntregalRecodeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805365";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"currency"] = kJF;
//    helper.parameters[@"accountType"] = @"C";
    helper.parameters[@"accountNumber"] = self.accountNumber;
    
    [helper modelClass:[IntregalRecordModel class]];
    
    //积分记录
    [helper refresh:^(NSMutableArray <IntregalRecordModel *>*objs, BOOL stillHave) {
        
        weakSelf.recodes = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray <IntregalRecordModel *>*objs, BOOL stillHave) {
            
            weakSelf.recodes = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];

}

- (void)requestUserInfo {
    
    BaseWeakSelf;
    
    //刷新rmb和积分
    TLNetworking *http = [TLNetworking new];
    http.code = @"805353";
    http.parameters[@"currency"] = kJF;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kJF]) {
                
                weakSelf.headerView.jfNumText = [obj.amount convertToRealMoney];
            }
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma tableView -- dataSource
//--//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recodes.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    
    IntregalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntregalRecordCell"];
    
    if (!cell) {
        
        cell = [[IntregalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntregalRecordCell"];
    }
    
    cell.task = self.recodes[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    headerView.backgroundColor = kWhiteColor;
    
    UILabel *textLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:13.0];
    
    textLabel.text = @"收支明细";
    
    [headerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
        make.width.lessThanOrEqualTo(@200);
        make.height.lessThanOrEqualTo(@15);
        
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    
    line.backgroundColor = kPaleGreyColor;
    
    [headerView addSubview:line];
    
    return headerView;
}

#pragma mark - Events


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
