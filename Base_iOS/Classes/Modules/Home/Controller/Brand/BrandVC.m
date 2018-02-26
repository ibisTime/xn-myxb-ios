//
//  BrandVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandVC.h"
//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "BrandListModel.h"
//V
#import "SelectScrollView.h"
//C
#import "BrandListVC.h"

@interface BrandVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray <BrandListModel *>*brandList;

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

#pragma mark - Init
- (void)initSelectScrollView {
    
    NSMutableArray *titles = [NSMutableArray array];
    
    [self.brandList enumerateObjectsUsingBlock:^(BrandListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BrandListModel *model = self.brandList[idx];
        
        [titles addObject:model.name];
        
    }];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                         itemTitles:titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.brandList.count; i++) {
        
        BrandListModel *model = self.brandList[i];

        BrandListVC *childVC = [[BrandListVC alloc] init];
        
        childVC.brandCode = model.code;

        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}
#pragma mark - Events

/**
 搜索品牌
 */
- (void)searchBrand {
    
    
}

#pragma mark - Data
- (void)requestBrandList {
    //1 未上架 2已上架 3已下架
    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.isList = YES;
    helper.showView = self.view;
    helper.code = @"805258";
    helper.parameters[@"status"] = @"2";
    
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
