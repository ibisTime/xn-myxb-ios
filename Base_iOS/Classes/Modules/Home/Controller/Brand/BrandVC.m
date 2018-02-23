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
//V
#import "SelectScrollView.h"
//C
#import "BrandListVC.h"

@interface BrandVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation BrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(searchBrand)];
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"资生堂", @"资生堂", @"资生堂", @"资生堂", @"资生堂", @"资生堂"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                         itemTitles:self.titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        BrandListVC *childVC = [[BrandListVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
//        childVC.status = i;
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
