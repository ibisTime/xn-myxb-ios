//
//  BrandBuyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandBuyVC.h"

//Macro
//Framework
//Category
//Extension
//M
//V
#import "TLTextField.h"
#import "TLTextView.h"
//C

@interface BrandBuyVC ()
//下单数量
@property (nonatomic, strong) TLTextField *numTF;
//下单说明
@property (nonatomic, strong) TLTextView *remarkTV;

@end

@implementation BrandBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下单";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    //下单数量
    self.numTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)
                                          leftTitle:@"下单数量"
                                         titleWidth:100
                                        placeholder:@"请输入数量"];
    
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.numTF];
    //下单说明
    self.remarkTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.numTF.yy + 10, kScreenWidth, 180)];
    
    self.remarkTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.remarkTV.placeholderLbl.font = Font(13.0);
    self.remarkTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.remarkTV.placholder = @"下单说明";
    
    [self.view addSubview:self.remarkTV];
    //确定下单
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定下单"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:18.0
                                        cornerRadius:7.5];
    confirmBtn.frame = CGRectMake(15, self.remarkTV.yy + 40, kScreenWidth - 30, 44);
    
    [confirmBtn addTarget:self action:@selector(confirmBuy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
}

#pragma mark - Events
- (void)confirmBuy {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
