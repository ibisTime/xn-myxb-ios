//
//  ChousePayView.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@protocol ChousePayViewDelegate<NSObject>


-(void)commitMoneyButtonClickWithMoneyType:(NSInteger)type;

@end
@interface ChousePayView : BaseView
- (instancetype)initWithFrame:(CGRect)frame become:(BOOL)become;

@property (nonatomic , weak)id<ChousePayViewDelegate>delegate;

@end
