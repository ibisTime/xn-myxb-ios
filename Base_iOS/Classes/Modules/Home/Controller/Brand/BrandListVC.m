//
//  BrandListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandListVC.h"
//M
#import "BrandModel.h"
//V
#import "BrandListTableView.h"
#import "TLPlaceholderView.h"
#import "BrandHeaderView.h"
//C
#import "BrandDetailVC.h"

@interface BrandListVC ()<RefreshDelegate>

@property (nonatomic, strong) BrandListTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <BrandModel *>*brands;

@property (nonatomic, strong) BrandHeaderView *headerView;

@end

@implementation BrandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self initTableView];
    //获取产品列表
    [self requestBrandGoods];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    
    self.descriptionStr = [NSString stringWithFormat:@"品牌简介:\n\n%@",self.descriptionStr];

    self.headerView.descriptionStr = self.descriptionStr;
    
    
//    CGSize size = [self.headerView.descLabel sizeThatFits:CGSizeMake(kScreenWidth - 30, 30)];
//
//    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, size.height + 20);
    
    
    
    self.brands = [NSMutableArray array];
    
    self.tableView = [[BrandListTableView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无产品"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Data
- (void)requestBrandGoods {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805266";
    
    helper.parameters[@"brandCode"] = self.brandCode;
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[BrandModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.brands = objs;
            weakSelf.tableView.brands = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.brands = objs;
            weakSelf.tableView.brands = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}
- (BrandHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[BrandHeaderView alloc]init];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}
#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandModel *brand = self.brands[indexPath.row];
    
    BrandDetailVC *detailVC = [BrandDetailVC new];
    
    detailVC.title = @"产品详情";
    
    detailVC.code = brand.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
