//
//  AppointmentListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentListVC.h"

//Category
#import "UIBarButtonItem+convience.h"
#import "UIView+Extension.h"
//Extension
#import <PYSearch.h>
//M
#import "AppointmentListModel.h"
//V
#import "AppointmentListTableView.h"
//C
#import "AppointmentDetailVC.h"
#import "NavigationController.h"
#import "SearchVC.h"

@interface AppointmentListVC ()<RefreshDelegate, PYSearchViewControllerDelegate>
//
@property (nonatomic, strong) AppointmentListTableView *tableView;
//用户列表
@property (nonatomic, strong) NSMutableArray <AppointmentListModel *>*appointmentList;

@end

@implementation AppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //搜索
    [self setSearchItem];
    //
    [self initTableView];
    //获取用户列表
    [self requestUserList];
    //刷新列表
    [self.tableView beginRefreshing];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //刷新列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)setSearchItem {
    
    [UIBarButtonItem addRightItemWithImageName:@"搜索"
                                         frame:CGRectMake(0, 0, 40, 40)
                                            vc:self
                                        action:@selector(clickSearch)];
}

- (void)initTableView {
    
    self.tableView = [[AppointmentListTableView alloc] initWithFrame:CGRectZero
                                                               style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Events
- (void)clickSearch {
    
    BaseWeakSelf;
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"输入关键字搜索", @"输入关键字搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchVC *searchVC = [SearchVC new];
        
        searchVC.type = weakSelf.userType;
        searchVC.searchText = searchText;
        searchVC.searchType = SearchTypePerson;
        
        [searchViewController.navigationController pushViewController:searchVC animated:YES];
    }];
    
    // 3. Set style for popular search and search history
    searchViewController.showHotSearch = NO;
    
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    
    searchViewController.searchBarBackgroundColor = [UIColor colorWithUIColor:kWhiteColor alpha:0.4];

    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消"
                                         titleColor:kWhiteColor
                                    backgroundColor:kClearColor
                                          titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    
    searchViewController.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];;
    
    UIView* backgroundView = [searchViewController.searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    
    backgroundView.layer.cornerRadius = 22;
    backgroundView.clipsToBounds = YES;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navi animated:YES completion:nil];
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;

}

- (void)clickCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)requestUserList {
    //0 可预约
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805120";
    helper.parameters[@"kind"] = self.userType;
    helper.parameters[@"status"] = @"0";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AppointmentListModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.appointmentList = objs;
            
            weakSelf.tableView.appointmentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.appointmentList = objs;
            
            weakSelf.tableView.appointmentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppointmentListModel *appointment = self.appointmentList[indexPath.row];
    
    AppointmentDetailVC *detailVC = [AppointmentDetailVC new];
    
    detailVC.title = self.titleStr;
    detailVC.appomintment = appointment;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
