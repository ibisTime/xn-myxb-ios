//
//  GoodNewsVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "GoodNewsVC.h"
//M
#import "GoodNewsModel.h"
#import "BannerModel.h"
//V
#import "GoodNewsTableView.h"
#import "TLPlaceholderView.h"
//C
#import "GoodNewsDetailVC.h"

@interface GoodNewsVC ()<RefreshDelegate>
//
@property (nonatomic, strong) GoodNewsTableView *tableView;
//暂无行程
@property (nonatomic, strong) UIView *placeHolderView;
//喜报列表
@property (nonatomic, strong) NSMutableArray <GoodNewsModel *>*newsList;

@end

@implementation GoodNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    //获取喜报列表
    [self requestGoodNewsList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    NSString *text = [self.type isEqualToString:kBannerTypeGoodNews] ? @"暂无喜报": @"暂无预报";
    
    self.tableView = [[GoodNewsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:text];

    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Setting
- (void)setType:(NSString *)type {
    
    _type = type;
    
    self.title = [type isEqualToString:kBannerTypeGoodNews] ? @"喜报展示": @"预报展示";
}

#pragma mark - Data
- (void)requestGoodNewsList {
    
    //status: 0 待上架 1已上架 2已下架
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805435";
    
    helper.parameters[@"type"] = [self.type isEqualToString:kBannerTypeGoodNews] ? @"0": @"1";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[GoodNewsModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.newsList = objs;
            
            weakSelf.tableView.newsList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
        
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
                        
            weakSelf.newsList = objs;
            
            weakSelf.tableView.newsList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodNewsDetailVC *detailVC = [GoodNewsDetailVC new];
    
    detailVC.news = self.newsList[indexPath.row];
    detailVC.type = self.type;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
