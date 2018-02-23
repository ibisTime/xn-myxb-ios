//
//  IntegralGoodDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralGoodDetailVC.h"

//Macro
//Framework
//Category
//Extension
//M
//V
#import "IntegralGoodHeaderView.h"
//C

@interface IntegralGoodDetailVC ()
//
@property (nonatomic, strong) IntegralGoodHeaderView *headerView;

@end

@implementation IntegralGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    //头部
    [self initHeaderView];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[IntegralGoodHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    
    [self.bgSV addSubview:self.headerView];
}

- (void)initContentView {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
