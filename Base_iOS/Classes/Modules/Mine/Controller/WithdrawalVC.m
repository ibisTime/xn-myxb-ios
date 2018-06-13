//
//  WithdrawalVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WithdrawalVC.h"
#import "UIControl+Block.h"
#import "WithdrawalTable.h"
#import "IntregalRecordModel.h"
#import "WithdrawalDetailsVC.h"
#import "TopUpVC.h"

@interface WithdrawalVC ()
@property (nonatomic , strong)WithdrawalTable *tableview;
@property (nonatomic , strong)NSArray <IntregalRecordModel *>*modelArry;

@end

@implementation WithdrawalVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的账户";
    
    [self initTableView];
    
    [self requestTripList];
    
    UIButton *extractbtn = [UIButton buttonWithTitle:@"提现" titleColor:kWhiteColor backgroundColor:[UIColor colorWithHexString:@"#36BD81"] titleFont:18.0];
    [extractbtn bk_addEventHandler:^(id sender) {
        [self.navigationController pushViewController:[WithdrawalDetailsVC new] animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:extractbtn];
    [extractbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
    }];
    
    UIButton *topUptbtn = [UIButton buttonWithTitle:@"充值" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [topUptbtn bk_addEventHandler:^(id sender) {
        
        [self.navigationController pushViewController:[TopUpVC new] animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topUptbtn];
    [topUptbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
    }];
    
    [self.tableview beginRefreshing];

    
}
- (void)initTableView
{
    self.tableview = [[WithdrawalTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight- kBottomInsetHeight - kBottomInsetHeight) style:UITableViewStylePlain];
    self.tableview.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无行程"];
    
    [self.view addSubview:self.tableview];
}
#pragma mark - Data
- (void)requestTripList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.showView = self.view;
    helper.code = @"802524";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"currency"] = @"CNY";
    helper.parameters[@"accountNumber"] = [TLUser user].rmbAccountNumber;

    [helper modelClass:[IntregalRecordModel class]];
    
    [self.tableview addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableview.modelArry = objs;
            
            [weakSelf.tableview reloadData_tl];
            [weakSelf.tableview.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableview addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableview.modelArry = objs;
            
            [weakSelf.tableview reloadData_tl];
            [weakSelf.tableview.mj_footer endRefreshing];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableview endRefreshingWithNoMoreData_tl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
