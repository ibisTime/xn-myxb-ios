//
//  MyCommentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCommentVC.h"
//V
#import "SelectScrollView.h"
//C
#import "MyCommentListVC.h"

@interface MyCommentVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation MyCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的评论";
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"美导", @"讲师", @"专家", @"品牌"];

    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    //    self.selectScrollView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    NSArray *types = @[kUserTypeBeautyGuide, kUserTypeLecturer, kUserTypeExpert, @"P"];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        MyCommentListVC *childVC = [[MyCommentListVC alloc] init];
        
        childVC.type = types[i];
        
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
