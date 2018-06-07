//
//  ChousePayView.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@protocol ChousePayViewDelegate<NSObject>
/**
 *  提交续费按钮事件
 *
 *  @param moneyCount 钱的数目
 */
-(void)commitMoneyButtonClickWithMoney:(BOOL)isWeixin;

@end
@interface ChousePayView : BaseView

@property (nonatomic , weak)id<ChousePayViewDelegate>delegate;

@end
