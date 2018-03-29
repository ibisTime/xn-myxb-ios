//
//  AppointmentOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderVC.h"
//M
#import "AppointmentOrderModel.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "AppointmentOrderListVC.h"

@interface AppointmentOrderVC ()<SegmentDelegate>

//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//
@property (nonatomic, strong) UIScrollView *switchScrollView;
//
@property (nonatomic, strong) SelectScrollView *selectScrollView;
//
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, strong) NSArray *statusList;
//类型
@property (nonatomic, copy) NSString *kind;

@end

@implementation AppointmentOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //顶部切换
    [self initSegmentView];
}

#pragma mark - Init
- (void)initSegmentView {
    
    NSArray *titleArr = @[
                          @"美导",
                          @"讲师",
                          @"专家"];
    
    CGFloat h = 30;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, (44-h), kWidth(179), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kThemeColor;
    self.labelUnil.titleFont = Font(16.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    
    //1.切换背景
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchScrollView];
    [self.switchScrollView setContentSize:CGSizeMake(titleArr.count*self.switchScrollView.width, self.switchScrollView.height)];
    self.switchScrollView.scrollEnabled = NO;
    //2.订单列表
    NSArray *kindArr = @[kUserTypeBeautyGuide, kUserTypeLecturer, kUserTypeExpert];

    
    
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];

        if ([self.kind isEqualToString:kUserTypeExpert]) {
            
            self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"待录入", @"已完成"];
            
        } else {
            
            self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"已完成"];
        }
        
        SelectScrollView *selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
        
        [self.switchScrollView addSubview:selectScrollView];
        
        self.selectScrollView = selectScrollView;
        
        [self addSubViewController];
    }
    
}

- (void)addSubViewController {
    
    if ([self.kind isEqualToString:kUserTypeExpert]) {
        
        self.statusList = @[@"", kAppointmentOrderStatusWillCheck, kAppointmentOrderStatusWillVisit, kAppointmentOrderStatusWillOverClass, kAppointmentOrderStatusDidOverClass, kAppointmentOrderStatusDidComplete];
        
    } else {
        
        self.statusList = @[@"", kAppointmentOrderStatusWillCheck, kAppointmentOrderStatusWillVisit, kAppointmentOrderStatusWillOverClass, kAppointmentOrderStatusDidComplete];
    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        AppointmentOrderListVC *childVC = [[AppointmentOrderListVC alloc] init];
        
        childVC.status = self.statusList[i];
        childVC.kind = self.kind;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [self.selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchScrollView setContentOffset:CGPointMake((index - 1) * self.switchScrollView.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
