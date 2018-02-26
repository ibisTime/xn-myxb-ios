//
//  IntegralOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderVC.h"

//V
#import "SelectScrollView.h"
//C
#import "IntegralOrderListVC.h"

@interface IntegralOrderVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation IntegralOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分订单";
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"全部", @"待发货", @"待收货", @"待评价", @"已完成", @"无货取消"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
//    self.selectScrollView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        IntegralOrderListVC *childVC = [[IntegralOrderListVC alloc] init];
        
        childVC.status = i-1;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
