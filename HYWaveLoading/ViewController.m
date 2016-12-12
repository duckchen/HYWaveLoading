//
//  ViewController.m
//  HYWaveLoading
//
//  Created by chy on 16/12/8.
//  Copyright © 2016年 Chy. All rights reserved.
//

#import "ViewController.h"
#import "HYWaveLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HYWaveLoadingView *loadingView = [HYWaveLoadingView loadingView];
    [self.view addSubview:loadingView];
    [loadingView animateStart];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
