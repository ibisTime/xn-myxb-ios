//
//  AutoresizeLabelFlow.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "AutoresizeLabelModel.h"

typedef void(^selectedHandler)(NSUInteger index,NSString *title);

@interface AutoresizeLabelFlow : BaseView

@property (nonatomic,strong) NSArray <AutoresizeLabelModel *>*data;

- (instancetype)initWithFrame:(CGRect)frame
              selectedHandler:(selectedHandler)handler;

//- (void)insertLabelWithTitle:(NSString *)title
//                     atIndex:(NSUInteger)index
//                    animated:(BOOL)animated;
//
//- (void)insertLabelsWithTitles:(NSArray *)titles
//                     atIndexes:(NSIndexSet *)indexes
//                      animated:(BOOL)animated;
//
//- (void)deleteLabelAtIndex:(NSUInteger)index
//                  animated:(BOOL)animated;
//
//- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes
//                     animated:(BOOL)animated;
//
- (void)reloadAllWithTitles:(NSArray *)titles;

@end
