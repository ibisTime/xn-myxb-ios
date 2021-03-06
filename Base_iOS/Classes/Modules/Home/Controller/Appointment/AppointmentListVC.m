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
#import "DataDictionaryModel.h"
//V
#import "AppointmentListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "AppointmentDetailVC.h"
#import "NavigationController.h"
#import "SearchVC.h"
#import "BaseSearchVC.h"

@interface AppointmentListVC ()<RefreshDelegate, PYSearchViewControllerDelegate>
//
@property (nonatomic, strong) AppointmentListTableView *tableView;
//用户列表
@property (nonatomic, strong) NSMutableArray <AppointmentListModel *>*appointmentList;
//风格列表
@property (nonatomic, strong)  NSArray <DataDictionaryModel *>*data;

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
    
    NSString *text = [NSString stringWithFormat:@"暂无%@", [[TLUser user] getUserTypeWithKind:self.userType]];
    
    self.tableView = [[AppointmentListTableView alloc] initWithFrame:CGRectZero
                                                               style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:text];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Events
- (void)clickSearch {
    
    BaseWeakSelf;
    
    __block BaseSearchVC *baseSearchVC = [BaseSearchVC searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"输入关键字搜索", @"输入关键字搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchVC *searchVC = [SearchVC new];
        
        searchVC.type = weakSelf.userType;
        searchVC.searchText = searchText;
        searchVC.searchType = SearchTypePerson;
        searchVC.titleStr = self.titleStr;
        
        [baseSearchVC.navigationController pushViewController:searchVC animated:YES];
    }];
    
    // 3. Set style for popular search and search history
    baseSearchVC.showHotSearch = NO;
    
    baseSearchVC.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    
    baseSearchVC.searchBarBackgroundColor = [UIColor colorWithUIColor:kWhiteColor alpha:0.4];
    baseSearchVC.searchBar.tintColor = kWhiteColor;
    baseSearchVC.searchBar.layer.cornerRadius = 15;
    baseSearchVC.searchBar.layer.masksToBounds = YES;
//
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消"
                                         titleColor:kWhiteColor
                                    backgroundColor:kClearColor
                                          titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    
    baseSearchVC.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];;
    //修改searchbar背景色
//    UIView* backgroundView = [baseSearchVC.searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];

    //修改searchbar文字颜色
    UILabel* label = (UILabel *)[baseSearchVC.searchBar subViewOfClassName:@"UISearchBarTextFieldLabel"];

    label.textColor = kWhiteColor;
    
    // 4. Set delegate
    baseSearchVC.delegate = self;
    // 5. Present a navigation controller
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:baseSearchVC];
    
    [navi.navigationBar setBackgroundImage:[kAppCustomMainColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self presentViewController:navi animated:YES completion:nil];

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
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AppointmentListModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            NSMutableArray *chousrArry = [NSMutableArray arrayWithCapacity:0];
            [objs enumerateObjectsUsingBlock:^(AppointmentListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.signStatus integerValue] == 2) {
                    [chousrArry addObject:obj];
                }
            }];
            
            weakSelf.appointmentList = chousrArry;

            weakSelf.tableView.appointmentList = weakSelf.appointmentList;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            NSMutableArray *chousrArry = [NSMutableArray arrayWithCapacity:0];
            [objs enumerateObjectsUsingBlock:^(AppointmentListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.signStatus integerValue] == 2) {
                    [chousrArry addObject:obj];
                }
            }];
            
            weakSelf.appointmentList = chousrArry;
            
            weakSelf.tableView.appointmentList = weakSelf.appointmentList;
            
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
