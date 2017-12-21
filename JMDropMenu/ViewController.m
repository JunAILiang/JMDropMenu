//
//  ViewController.m
//  JMDropMenu
//
//  Created by JM on 2017/12/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "ViewController.h"
#import "JMDropMenu.h"

@interface ViewController ()<JMDropMenuDelegate>

/** 按钮 */
@property (nonatomic, strong) UIButton *btn;
/** titleArr */
@property (nonatomic, strong) NSArray *titleArr;
/** imgArr */
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"超强封装";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navRightClick)];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navLeftClick)];
    
    self.titleArr = @[@"创建群聊",@"加好友/群",@"扫一扫",@"付款",@"拍摄"];
    self.imageArr = @[@"img1",@"img2",@"img3",@"img4",@"img5"];
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"自定义样式" forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor redColor];
    self.btn.frame = CGRectMake(140, 120, 100, 50);
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
}

#pragma mark - 左边
- (void)navLeftClick {
    [JMDropMenu showDropMenuFrame:CGRectMake(8, 64, 120, 208) ArrowOffset:16.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
}

#pragma mark - 右边
- (void)navRightClick {
    [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 128, 64, 120, 208) ArrowOffset:102.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeQQ LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
}

#pragma mark - 自定义按钮
- (void)btnClick {
    JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(126, 170, 130, 208) ArrowOffset:60.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
    dropMenu.titleColor = [UIColor redColor];
    dropMenu.lineColor = [UIColor greenColor];
    dropMenu.arrowColor = [UIColor blueColor];
//    dropMenu.LayoutType = JMDropMenuLayoutTypeTitle;
//    dropMenu.arrowColor = [UIColor redColor];
}

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, image);
}

@end






