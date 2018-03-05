//
//  QRCodeView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@interface QRCodeView : BaseView

@property (nonatomic, copy) NSString *url;

//显示
- (void)show;
//隐藏
- (void)hide;

@end
