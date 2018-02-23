//
//  TripListView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TripListBlock)(void);

@interface TripListView : UIView

@property (nonatomic, copy) TripListBlock tripBlock;
//显示
- (void)show;
//隐藏
- (void)hide;

@end
