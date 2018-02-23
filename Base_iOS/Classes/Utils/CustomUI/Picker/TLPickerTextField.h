//
//  XNPickerTextField.h
//  MOOM
//
//  Created by 田磊 on 16/6/23.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "AccountTf.h"

@interface TLPickerTextField : AccountTf

@property (nonatomic,copy) NSArray *tagNames;

@property (nonatomic,copy)  void (^didSelectBlock)(NSInteger index);
//当前选择
@property (nonatomic, assign) NSInteger selectIndex;

@end
