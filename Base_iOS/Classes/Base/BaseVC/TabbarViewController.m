//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

//Category
#import "UIImage+Tint.h"
//V
#import "CustomTabBar.h"
//C
#import "NavigationController.h"
#import "TLUserLoginVC.h"

@interface TabbarViewController () <UITabBarControllerDelegate, TabBarDelegate>
//ItemArray
@property (nonatomic, strong) NSMutableArray *tabBarItems;
//自定义tabbar
@property (nonatomic, strong) CustomTabBar *customTabbar;

@end

@implementation TabbarViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建子控制器
    [self createSubControllers];
    // 设置tabbar样式
    [self initTabBar];
}

#pragma mark - Init

- (void)initTabBar {
    
    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //替换系统tabbar
    CustomTabBar *tabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.translucent = NO;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor orangeColor];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [tabBar layoutSubviews];
    
    self.customTabbar = tabBar;
    
    tabBar.tabBarItems = self.tabBarItems.copy;
    
}

- (void)createSubControllers {
    
    self.tabBarItems = [NSMutableArray array];
    
    NSArray *titles = @[@"首页",
                        @"邀请好友",
                        @"平台建议",
                        @"帮助中心",
                        @"我的"];
    
    NSArray *normalImages = @[@"home",
                              @"invite",
                              @"platfrom_proposal",
                              @"help_center",
                              @"mine"];
    
    NSArray *selectImages = @[@"home_select",
                              @"invite_select",
                              @"platfrom_proposal_select",
                              @"help_center_select",
                              @"mine_select"];
    
    NSArray *vcNames = @[@"HomeVC",
                         @"HomeVC",
                         @"HomeVC",
                         @"HomeVC",
                         @"MineVC"];
    
    for (int i = 0; i < normalImages.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                           vcName:vcNames[i]
                        imgNormal:normalImages[i]
                      imgSelected:selectImages[i]];
    }
    
    self.selectedIndex = 2;
}

- (void)addChildVCWithTitle:(NSString *)title
                     vcName:(NSString *)vcName
                  imgNormal:(NSString *)imgNormal
                imgSelected:(NSString *)imgSelected {
    
    //对选中图片进行渲染
    UIImage *selectedImg = [[UIImage imageNamed:imgSelected] tintedImageWithColor:kAppCustomMainColor];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:selectedImg];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    vc.tabBarItem = tabBarItem;
    
    [self addChildViewController:nav];
    
    TabBarModel *item = [TabBarModel new];
    
    item.selectedImgUrl = imgSelected;
    item.unSelectedImgUrl = imgNormal;
    item.title = title;
    
    [self.tabBarItems addObject:item];
}

#pragma mark - Setter
- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    self.customTabbar.selectedIdx = _currentIndex;
    
    self.selectedIndex = _currentIndex;
}

#pragma mark - TabBarDelegate
- (BOOL)didSelected:(NSInteger)idx tabBar:(UITabBar *)tabBar {
    
    if (idx == 4 && ![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    //
    self.selectedIndex = idx;
    
    return YES;
}

@end
