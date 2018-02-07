//
//  HomeScrollView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomeScrollView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import <UIScrollView+TLAdd.h>

@interface HomeScrollView ()

@end

@implementation HomeScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kBackgroundColor;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self adjustsContentInsets];
    }
    return self;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    return YES;
//}
@end
