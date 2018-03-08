//
//  LoopScrollView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopScrollView : UIView
//滚动间隔时间，默认2s
@property (nonatomic, assign) NSTimeInterval timeinterval;
//默认黑色
@property (nonatomic, strong) UIColor *textColor;
//默认13
@property (nonatomic, strong) UIFont *textFont;
//展示多少条公告
@property (nonatomic, assign) NSInteger count;
//当前的index
@property (nonatomic, assign, readonly) NSInteger currentIndex;
//文本数组
@property (nonatomic, copy) NSArray *titles;
//文本图片数组
@property (nonatomic, copy) NSArray *titleImgs;
//左边图片
@property (nonatomic, strong) UIImage *leftImage;
//触摸事件
@property (nonatomic, copy) void (^loopBlock)(void);

+ (instancetype)loopTitleViewWithFrame:(CGRect)frame titleImgs:(NSArray *)titleImgs;

@end
