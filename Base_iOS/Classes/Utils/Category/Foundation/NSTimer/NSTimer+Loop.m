//
//  NSTimer+Loop.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NSTimer+Loop.h"

@implementation NSTimer (Loop)

-(void)pauseTimer
{
    if (![self isValid]) {
        
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

- (void)stopTimer
{
    if ([self isValid]) {
        
        [self invalidate];
    }
}

@end
