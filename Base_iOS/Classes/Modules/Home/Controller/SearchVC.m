//
//  SearchVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchVC.h"
//Category
#import "UIView+Extension.h"
//Extension
#import <PYSearch.h>
//M
#import "BrandModel.h"
#import "AppointmentListModel.h"
//V
#import "BrandListCell.h"
#import "AppointmentListCell.h"
#import "TLPlaceholderView.h"
//C
#import "NavigationController.h"
#import "SearchVC.h"
#import "AppointmentDetailVC.h"
#import "BrandDetailVC.h"

@interface SearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, PYSearchViewControllerDelegate>
//
@property (nonatomic,strong) TLTableView *tableView;
//产品列表
@property (nonatomic, strong) NSArray <BrandModel *>*brands;
//用户列表
@property (nonatomic, strong) NSMutableArray <AppointmentListModel *>*appointmentList;

@end

@implementation SearchVC
//
static NSString *BrandListCellID = @"BrandListCell";
//
static NSString *AppointmentListCellID = @"AppointmentListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //搜索
    [self initSearchBar];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    if (_searchType == SearchTypeGood) {
        
        //获取产品数据
        [self requestGoodList];
        
        [self.tableView beginRefreshing];
    } else {
        //获取预约对象
        [self requestUserList];
        //
        [self.tableView beginRefreshing];
    }
}

- (void)setSearchType:(SearchType)searchType {
    
    _searchType = searchType;
    
    //商品列表
    [self initTableView];
    
    if (_searchType == SearchTypeGood) {
        
        //获取产品数据
        [self requestGoodList];
        
        [self.tableView beginRefreshing];
    } else {
        //获取预约对象
        [self requestUserList];
        //
        [self.tableView beginRefreshing];
    }
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    [self.tableView registerClass:[BrandListCell class] forCellReuseIdentifier:BrandListCellID];
    
    [self.tableView registerClass:[AppointmentListCell class] forCellReuseIdentifier:AppointmentListCellID];

    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无结果"];
    
    [self.view addSubview:self.tableView];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kClearColor;
    searchBgView.userInteractionEnabled = YES;
    
    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
    }];
    //搜索按钮
    UIButton *btn = [UIButton buttonWithTitle:self.searchText
                                   titleColor:kWhiteColor
                              backgroundColor:[UIColor colorWithUIColor:kWhiteColor alpha:0.4]
                                    titleFont:15.0
                                 cornerRadius:15.0];
    //
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 8, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15);
        
    }];
    //
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.width + 50)];
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(14)
                                       textColor:kTextColor2];
    [searchBgView addSubview:searchLbl];
    
    
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX).offset(0);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];
    
}

#pragma mark - Events
- (void)clickSearch {
    
    BaseWeakSelf;
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"输入关键字搜索", @"输入关键字搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchVC *searchVC = [SearchVC new];
        
        searchVC.searchText = searchText;
        searchVC.searchType = weakSelf.searchType;
        
        [searchViewController.navigationController pushViewController:searchVC animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.showHotSearch = NO;
    
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    
    searchViewController.searchBarBackgroundColor = [UIColor colorWithUIColor:kWhiteColor alpha:0.4];
    
    __weak UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消"
                                                titleColor:kWhiteColor
                                           backgroundColor:kClearColor
                                                 titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    
    searchViewController.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIView* backgroundView = [searchViewController.searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    
//    backgroundView.layer.cornerRadius = 15;
//    backgroundView.clipsToBounds = YES;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)clickCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)requestGoodList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805266";
    
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    helper.parameters[@"name"] = self.searchText;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[BrandModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
                        
            weakSelf.brands = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.brands = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)requestUserList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805120";
    helper.parameters[@"kind"] = self.type;
    helper.parameters[@"status"] = @"0";
    helper.parameters[@"userName"] = self.searchText;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AppointmentListModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.appointmentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.appointmentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_searchType == SearchTypeGood) {
        
        return self.brands.count;
    }
    return self.appointmentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchType == SearchTypeGood) {
        
        BrandListCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandListCellID forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brandModel = self.brands[indexPath.row];
        return cell;
    }
    
    AppointmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:AppointmentListCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.appointmentModel = self.appointmentList[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_searchType == SearchTypeGood) {
        
        BrandModel *brand = self.brands[indexPath.row];
        
        BrandDetailVC *detailVC = [BrandDetailVC new];
        
        detailVC.title = @"产品详情";
        
        detailVC.code = brand.code;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        return ;
    }
    
    AppointmentListModel *appointment = self.appointmentList[indexPath.row];
    
    AppointmentDetailVC *detailVC = [AppointmentDetailVC new];
    
    detailVC.title = self.titleStr;
    detailVC.appomintment = appointment;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchType == SearchTypeGood) {
        
        return 140;
    }
    return self.appointmentList[indexPath.row].cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , 10)];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
