//
//  AchievementOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AchievementOrderVC.h"
//V
#import "SelectScrollView.h"
//C

@interface AchievementOrderVC ()

@property (nonatomic, strong) UIScrollView *switchScrollView;
//
@property (nonatomic, strong) SelectScrollView *selectScrollView;
//
@property (nonatomic, strong) NSArray *titles;

@end

@implementation AchievementOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成果列表";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
