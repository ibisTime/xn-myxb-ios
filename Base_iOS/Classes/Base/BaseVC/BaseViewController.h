//
//  BaseViewController.h
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoinHeader.h"
#import "PromptView.h"

@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) PromptView *placeholderView;

@property (nonatomic, strong) UIScrollView *bgSV;

- (void)setPlaceholderView;
//移除
- (void)removePlaceholderView;
// 添加
- (void)addPlaceholderView;

- (void)placeholderOperation;

@end
