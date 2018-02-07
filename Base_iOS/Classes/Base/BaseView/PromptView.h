//
//  PromptView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromptView;

/**
 站位操作
 */
@protocol PromptViewDelegate<NSObject>

- (void)placeholderOperation;

@end
/**
 无网络时显示
 */
@interface PromptView : UIView

@property (nonatomic, weak) id <PromptViewDelegate> delegate;

- (void)setTitle:(NSString *)title btnTitle:(NSString *)btnTitle icon:(NSString *)icon;

@end
