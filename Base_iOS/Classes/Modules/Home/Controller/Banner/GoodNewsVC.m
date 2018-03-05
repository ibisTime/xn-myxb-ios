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
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = [self.type isEqualToString:kBannerTypeGoodNews] ? @"喜报展示": @"预报展示";
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

- (void)initTableView {
    
    self.tableView = [[GoodNewsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Setting
- (void)setType:(NSString *)type {
    
    _type = type;
    
    self.title = [type isEqualToString:kBannerTypeGoodNews] ? @"喜报展示": @"预报展示";
    //
    [self initPlaceHolderView];
}

#pragma mark - Data
- (void)requestGoodNewsList {
    
    //status: 0 待上架 1已上架 2已下架
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805435";
    
    helper.parameters[@"type"] = [self.type isEqualToString:kBannerTypeGoodNews] ? @"0": @"1";
    helper.parameters[@"status"] = @"1";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[GoodNewsModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.newsList = objs;
            
            weakSelf.tableView.newsList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.newsList = objs;

            weakSelf.tableView.newsList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodNewsDetailVC *detailVC = [GoodNewsDetailVC new];
    
    detailVC.news = self.newsList[indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
