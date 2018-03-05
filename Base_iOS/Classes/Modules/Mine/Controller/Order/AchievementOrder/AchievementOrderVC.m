//
//  AchievementOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AchievementOrderVC.h"
//M
#import "AchievementOrderModel.h"
//V
#import "SelectScrollView.h"
//C
#import "AchievementOrderListVC.h"

@interface AchievementOrderVC ()

//
@property (nonatomic, strong) SelectScrollView *selectScrollView;
//
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, strong) NSArray *statusList;

@end

@implementation AchievementOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成果列表";
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
    
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    if ([[TLUser user].kind isEqualToString:kUserTypeExpert]) {
        
        self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"待录入", @"已完成"];
        
    } else {
        
        self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"已完成"];
    }
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    if ([[TLUser user].kind isEqualToString:kUserTypeExpert]) {
        
        self.statusList = @[@"", kAchievementOrderStatusWillCheck, kAchievementOrderStatusWillVisit, kAchievementOrderStatusWillOverClass, kAchievementOrderStatusDidOverClass, kAchievementOrderStatusDidComplete];
        
    } else {
        
        self.statusList = @[@"", kAchievementOrderStatusWillCheck, kAchievementOrderStatusWillVisit, kAchievementOrderStatusWillOverClass, kAchievementOrderStatusDidComplete];
    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        AchievementOrderListVC *childVC = [[AchievementOrderListVC alloc] init];
        
        childVC.status = self.statusList[i];
        
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
