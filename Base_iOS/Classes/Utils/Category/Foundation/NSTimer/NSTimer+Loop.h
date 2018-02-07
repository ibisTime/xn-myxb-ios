//
//  NSTimer+Loop.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Loop)
//暂停定时器
- (void)pauseTimer;
//重启定时器
- (void)resumeTimer;
//多少秒后重启定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
//停止定时器
- (void)stopTimer;

@end
