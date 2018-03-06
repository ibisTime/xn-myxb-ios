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
//C
#import "BrandDetailVC.h"

@interface BrandListVC ()<RefreshDelegate>

@property (nonatomic, strong) BrandListTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <BrandModel *>*brands;
//暂无产品
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation BrandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //暂无产品
    [self initPlaceHolderView];
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

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *noticeIV = [[UIImageView alloc] init];
    
    noticeIV.image = kImage(@"暂无订单");
    
    [self.placeHolderView addSubview:noticeIV];
    [noticeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无产品";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(noticeIV.mas_bottom).offset(20);
        make.centerX.equalTo(noticeIV.mas_centerX);
    }];
}

- (void)initTableView {
    
    self.brands = [NSMutableArray array];
    
    self.tableView = [[BrandListTableView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.placeHolderView = self.placeHolderView;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
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
            
            [weakSelf removePlaceholderView];

            weakSelf.brands = objs;
            weakSelf.tableView.brands = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];

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
