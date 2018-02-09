//
//  HelpCenterVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HelpCenterVC.h"

//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "QuestionModel.h"
//V
#import "HelpCenterTableView.h"
//C
#import "LinkServiceVC.h"

@interface HelpCenterVC ()
//
@property (nonatomic, strong) HelpCenterTableView *tableView;

@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    
    //联系客服
    [self initItem];
    //问题列表
    [self initTableView];
    //获取问题列表
    [self requestQuestionList];
}

#pragma mark - Init
- (void)initItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"联系客服" titleColor:kWhiteColor frame:CGRectMake(0, 0, 100, 44) vc:self action:@selector(linkService)];
}

- (void)initTableView {
    
    self.tableView = [[HelpCenterTableView alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
}

#pragma mark - Events
- (void)linkService {
    
    LinkServiceVC *linkServiceVC = [LinkServiceVC new];
    
    [self.navigationController pushViewController:linkServiceVC animated:YES];
}

#pragma mark - Data
- (void)requestQuestionList {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        
        QuestionModel *question = [QuestionModel new];
        
        question.title = @"美业销帮是什么?";
        question.content = @"我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？";
        [arr addObject:question];
        
    }
    self.tableView.questions = arr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
