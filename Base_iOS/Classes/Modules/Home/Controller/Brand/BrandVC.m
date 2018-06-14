//
//  BrandVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandVC.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "UIView+Extension.h"
#import "NSString+Check.h"
#import "UIControl+Block.h"

//Extension
#import <PYSearch.h>
//M
#import "BrandListModel.h"
#import "BigCategoriesModel.h"
//V
#import "SelectScrollView.h"
//C
#import "BrandListVC.h"
#import "NavigationController.h"
#import "SearchVC.h"
#import "ShoppingCartVC.h"
#import "TLUserLoginVC.h"
#import "SmallCategoriesVC.h"

@interface BrandVC ()<PYSearchViewControllerDelegate>

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *brandList;

@end

@implementation BrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(searchBrand)];
    //获取品牌列表
    [self requestBrandList];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //获取品牌列表
    [self requestBrandList];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    NSMutableArray *titles = [NSMutableArray array];
    
    [self.brandList enumerateObjectsUsingBlock:^(BigCategoriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        BigCategoriesModel *model = self.brandList[idx];
        
        [titles addObject:obj.name];
        
        
//        BrandListModel *model = self.brandList[idx];
//        
//        if ([model.name valid]) {
//            
//            [titles addObject:model.name];
//        }
        
    }];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                         itemTitles:titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    
    
    
    for (NSInteger i = 0; i < self.brandList.count; i++) {
        
        BigCategoriesModel *model = self.brandList[i];
        
        SmallCategoriesVC *small = [[SmallCategoriesVC alloc]init];
        
        small.code = model.code;
        
        small.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);

        [self addChildViewController:small];

        [_selectScrollView.scrollView addSubview:small.view];
//        BrandListModel *model = self.brandList[i];
//
//        BrandListVC *childVC = [[BrandListVC alloc] init];
//
//        childVC.descriptionStr = model.desc;
//
//        childVC.brandCode = model.code;
//
//        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
//
//        [self addChildViewController:childVC];
//
//        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
    
    
    [self addShopCar];
}
#pragma mark - Events

- (void)addShopCar
{
    UIButton *choopcar = [UIButton buttonWithTitle:@""
                                       titleColor:kTextColor
                                  backgroundColor:kShallowGreyColor
                                        titleFont:18.0];
    [choopcar setImage:kImage(@"购物车") forState:UIControlStateNormal];
    choopcar.layer.cornerRadius = 25;
    
    [choopcar bk_addEventHandler:^(id sender) {
        
        if (![TLUser user].isLogin) {
            
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            
            loginVC.loginSuccess = ^{
                
                [self.navigationController pushViewController:[ShoppingCartVC new] animated:YES];
            };
            
            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:nav animated:YES completion:nil];
            
            return;
        }
        

        
        [self.navigationController pushViewController:[ShoppingCartVC new] animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:choopcar];
    
    [choopcar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-70);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
}
/**
 搜索品牌
 */
- (void)searchBrand {

    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"输入关键字搜索", @"输入关键字搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchVC *searchVC = [SearchVC new];
        
        searchVC.searchText = searchText;
        searchVC.searchType = SearchTypeGood;
        
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
- (void)requestBrandList {
    
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"805247";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] =@"100";
    
    [http postWithSuccess:^(id responseObject) {
        NSArray *arry = responseObject[@"data"];
        
        
        self.brandList = [BigCategoriesModel mj_objectArrayWithKeyValuesArray:arry];
        [self initSelectScrollView];
        [self addSubViewController];
        
    } failure:^(NSError *error) {
        
    }];
   

    
    return;
    //1 未上架 2已上架 3已下架
    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.isList = YES;
    helper.showView = self.view;
    helper.code = @"805258";
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[BrandListModel class]];
    
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.brandList = objs;
        //
        [self initSelectScrollView];
        //
        [self addSubViewController];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
