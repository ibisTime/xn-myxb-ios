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
#import "UIBarButtonItem+convience.h"
#import "TripListVC.h"


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

@property (nonatomic , strong)NSMutableArray *controArry;

@end

@implementation AppointmentOrderVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAllSubViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controArry = [NSMutableArray arrayWithCapacity:0];
    
    [UIBarButtonItem addRightItemWithTitle:@"行程管理" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(linkService)];
    
    //顶部切换
    [self initSegmentView];
}

#pragma mark - Init
- (void)initSegmentView {
    
    NSArray *titleArr = @[
                          @"服务团队",
                          @"销售精英"];
    
    CGFloat h = 30;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, (44-h), kWidth(129), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kThemeColor;
    self.labelUnil.titleFont = Font(13.0);
    self.labelUnil.lineType = LineTypeTitleLength;
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
    NSArray *kindArr = @[kUserTypeBeautyGuide, kUserTypeExpert];

    
    
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];

//        if ([self.kind isEqualToString:kUserTypeExpert]) {
//
//            self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"待录入", @"已完成"];
//
//        } else {
//
//            self.titles = @[@"全部", @"待审核", @"待上门", @"待下课", @"已完成"];
//        }
        
        self.titles = @[@"全部", @"服务状态", @"待审核", @"已完成"];

        
        SelectScrollView *selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
        
        [self.switchScrollView addSubview:selectScrollView];
        
        self.selectScrollView = selectScrollView;
        
        [self addSubViewControllerwith:[kindArr objectAtIndex:i]];
    }
    
}

- (void)addSubViewControllerwith:(NSString *)type {
    
//    if ([self.kind isEqualToString:kUserTypeExpert]) {
//
//        self.statusList = @[@"", kAppointmentOrderStatus_1, kAppointmentOrderStatus_2, kAppointmentOrderStatus_4, kAppointmentOrderStatus_5, kAppointmentOrderStatus_10];
//
//    } else {
//
//        self.statusList = @[@"", kAppointmentOrderStatus_1, kAppointmentOrderStatus_2, kAppointmentOrderStatus_4, kAppointmentOrderStatus_10];
//    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        AppointmentOrderListVC *childVC = [[AppointmentOrderListVC alloc] init];
        
        childVC.status = self.statusList[i];
        
        childVC.kind = type;
        NSArray *listarry;
        switch (i) {
            case 0:
            {
                listarry = @[@"1",@"2",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
            }
                break;
            case 1:
            {
                listarry = @[@"1",@"2",@"4",@"5",@"8"];
            }
                break;

            case 2:
            {
                listarry = @[@"6",@"7",@"8",@"11"];
                
            }
                break;
            case 3:
            {
                listarry = @[@"10",@"11"];
            }
                break;
                
            default:
                break;
        }
        
        childVC.tatusList = listarry;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [self.selectScrollView.scrollView addSubview:childVC.view];
        [self.controArry addObject:childVC];
        
    }
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchScrollView setContentOffset:CGPointMake((index - 1) * self.switchScrollView.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}
- (void)reloadAllSubViews
{
    for (AppointmentOrderListVC *listview in self.controArry) {
        [listview reloadTableview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)linkService
{
    [self.navigationController pushViewController:[TripListVC new] animated:YES];

}
@end
