//
//  BaseViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseViewController.h"

#import "NavigationController.h"
#import "TabbarViewController.h"

#import "UIColor+Extension.h"

#define kAnimationType 1


@interface BaseViewController () <UIGestureRecognizerDelegate, PromptViewDelegate>

@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    [self setViewEdgeInset];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kAppCustomMainColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    //navigation底部分割线
//    self.navigationController.navigationBar.shadowImage = [kLineColor convertToImage];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLayoutSubviews {
    
    //断网显示
    [self setPlaceholderView];
    //
    self.bgSV.frame = self.view.bounds;
//    self.bgSV.contentSize = self.view.bounds.size;
}

#pragma mark - LazyLoad
- (UIScrollView *)bgSV {
    
    if (!_bgSV) {
        
        _bgSV = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        if (@available(iOS 11.0, *)) {
            _bgSV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _bgSV;
}

- (PromptView *)placeholderView {
    
    if (!_placeholderView) {
        
        _placeholderView = [[PromptView alloc] initWithFrame:self.view.bounds];
        _placeholderView.backgroundColor = kBackgroundColor;
        _placeholderView.delegate = self;
        
    }
    return _placeholderView;
}

#pragma mark - Setting
- (void)setTitle:(NSString *)title {
    
    self.navigationItem.titleView = [UILabel labelWithTitle:title frame:CGRectMake(0, 0, 200, 44)];
}

#pragma mark - Private
// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (BOOL)isRootViewController {
    
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - Public
- (void)returnButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPlaceholderView {
    
    if (self.placeholderView) {
        
        [self.view addSubview:self.placeholderView];
    }
}

- (void)removePlaceholderView {
    
    if (self.placeholderView) {
        
        [self.placeholderView removeFromSuperview];
    }
}

- (void)setPlaceholderView {
    
    [self.placeholderView setTitle:@"加载失败, 请检查网络设置"
                          btnTitle:@"点击重试"
                              icon:@"网络错误"];
}

#pragma mark - PromptViewDelegate
- (void)placeholderOperation {
    
    if ([self isMemberOfClass:NSClassFromString(@"BaseViewController")]) {
        
        NSLog(@"子类请重写该方法");
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@类内存大爆炸",[self class]);
}

@end
