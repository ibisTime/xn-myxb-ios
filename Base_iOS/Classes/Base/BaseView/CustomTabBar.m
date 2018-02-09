//
//  CustomTabBar.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "CustomTabBar.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "UIImage+Tint.h"
//Extension
#import "UIButton+WebCache.h"
#import <UIView+Frame.h>
//V
#import "BarButton.h"

#define kButtonItemCount 5

@interface CustomTabBar ()

@property (nonatomic, strong) UIView *falseTabBar;
@property (nonatomic, strong) NSMutableArray <BarButton *>*btns;
//邀请按钮
@property (nonatomic, strong) UIButton *middleBtn;
//
@property (nonatomic, strong) UIImageView *middleIV;

@end

@implementation CustomTabBar
{
    BarButton *_lastTabBarBtn;
}

#pragma mark - LazyLoad

- (UIView *)falseTabBar {
    
    if (!_falseTabBar) {
        
        _falseTabBar = [[UIView alloc] initWithFrame:self.bounds];
        _falseTabBar.userInteractionEnabled = YES;
        _falseTabBar.backgroundColor = [UIColor whiteColor];
        _falseTabBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //添加5个按钮
        CGFloat w  = self.width/(kButtonItemCount*1.0);
        self.btns = [NSMutableArray arrayWithCapacity:kButtonItemCount];
        for (NSInteger i = 0; i < kButtonItemCount; i ++) {
            
//            if (i == 2) {
//                continue;
//            }
            
            BarButton *btn = [[BarButton alloc] initWithFrame:CGRectMake(i*w, 0, w, _falseTabBar.height)];
            
            btn.titleLbl.textColor = kTextColor;
            [btn addTarget:self action:@selector(hasChoose:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            [_falseTabBar addSubview:btn];

            [self.btns addObject:btn];
            
            if (i == 0) {
                
                _lastTabBarBtn = btn;
                _lastTabBarBtn.selected = YES;
                btn.isCurrentSelected = YES;
                _lastTabBarBtn.titleLbl.textColor = kAppCustomMainColor;
            }
        }
        
        //曲线
        
        UIButton *middleBtn = [UIButton buttonWithImageName:@"invite"
                                               cornerRadius:28];
        
        middleBtn.backgroundColor = kWhiteColor;
        middleBtn.adjustsImageWhenHighlighted = NO;
        middleBtn.contentMode = UIViewContentModeScaleAspectFill;
        
        middleBtn.tag = 102;
        [middleBtn setEnlargeEdgeWithTop:0 right:0 bottom:21 left:0];
        [middleBtn addTarget:self action:@selector(selectInvite:) forControlEvents:UIControlEventTouchUpInside];

        [_falseTabBar addSubview:middleBtn];
        [middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(_falseTabBar.mas_centerX);
            make.top.equalTo(_falseTabBar.mas_top).offset(-28);
            make.width.height.equalTo(@(56));
        }];
        
//        middleBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        
        self.middleBtn = middleBtn;
    
    }
    
    return _falseTabBar;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self addSubview:self.falseTabBar];
}

#pragma mark - Setting

- (void)setTabBarItems:(NSArray<TabBarModel *> *)tabBarItems {
    
    _tabBarItems = [tabBarItems copy];
    //
    if (_tabBarItems && (_tabBarItems.count == self.btns.count)) {
        
        [_tabBarItems enumerateObjectsUsingBlock:^(TabBarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BarButton *barBtn = self.btns[idx];
            barBtn.titleLbl.text = obj.title;
            //图片
            NSString *imgUrl = barBtn.isCurrentSelected ? obj.selectedImgUrl: obj.unSelectedImgUrl;
            barBtn.iconImageView.image = kImage(imgUrl);
        }];
    }
}

- (void)setSelectedIdx:(NSInteger)selectedIdx {
    
    _selectedIdx = selectedIdx;
    
    [self.btns enumerateObjectsUsingBlock:^(BarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == selectedIdx) {
            
            //上一个选中改变
            _lastTabBarBtn.titleLbl.textColor = kTextColor;
            _lastTabBarBtn.isCurrentSelected = NO;
            NSString *lastUrlStr = self.tabBarItems[_lastTabBarBtn.tag - 100].unSelectedImgUrl;
            _lastTabBarBtn.iconImageView.image = kImage(lastUrlStr);
            
            //---//
            //当前选中改变
            obj.titleLbl.textColor = kAppCustomMainColor;
            obj.isCurrentSelected = YES;
            NSString *currentUrlStr = self.tabBarItems[idx].selectedImgUrl;
            obj.iconImageView.image = kImage(currentUrlStr);
            
            _lastTabBarBtn = obj;
            
            //
            *stop = YES;
            
        }
    }];
}

#pragma mark - Events
//点击按钮，
- (void)hasChoose:(BarButton *)btn {
    
    if ([_lastTabBarBtn isEqual:btn]) {
        
        return;
    }
    
    //当前选中的小标
    NSInteger idx = btn.tag - 100;
    
    if (idx == 2) {
        
        return;
    }
    //--//
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        
        if([self.delegate didSelected:idx tabBar:self]) {
            
            [self changeUIWithCurrentSelectedBtn:btn idx:idx];
        }
        
    } else {
        
        [self changeUIWithCurrentSelectedBtn:btn idx:idx];
    }
}

- (void)changeUIWithCurrentSelectedBtn:(BarButton *)btn idx:(NSInteger)idx {
    
    _lastTabBarBtn.isCurrentSelected = NO;
    btn.isCurrentSelected = YES;
    
    NSInteger lastIdx = _lastTabBarBtn.tag - 100;
    //上次选中改变图片
    NSString *unselectedStr = self.tabBarItems[lastIdx].unSelectedImgUrl;
    _lastTabBarBtn.iconImageView.image = kImage(unselectedStr);
    _lastTabBarBtn.titleLbl.textColor = kTextColor;
    
//    //当前选中改变图片
    NSString *selectedStr = self.tabBarItems[idx].selectedImgUrl;
    btn.iconImageView.image = kImage(selectedStr);
    btn.titleLbl.textColor = kAppCustomMainColor;
    
    //--//
    btn.selected = NO;
    _lastTabBarBtn = btn;
    _lastTabBarBtn.selected = YES;
    
}

- (void)selectInvite:(UIButton *)sender {
    
    NSInteger idx = sender.tag - 100;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        
        [self.delegate didSelected:idx tabBar:self];
    }
}

#pragma mark - HitTest
//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newPoint = [self convertPoint:point toView:self.middleBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.middleBtn pointInside:newPoint withEvent:event]) {
            
            return self.middleBtn;
            
        }else{
            //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    
    else {
        //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
