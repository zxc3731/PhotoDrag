//
//  ViewController.m
//  playImagetestdemo
//
//  Created by 江 on 16/7/5.
//  Copyright © 2016年 江. All rights reserved.
//

#import "ViewController.h"
#import "Myview.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    Myview *vi = [[Myview alloc] initWithFrame:CGRectMake(0, 30, 320, 320) withImages:@[[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], [UIImage imageNamed:@"3"]]];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
