//
//  HYWaveLoadingView.h
//  HYWaveLoading
//
//  Created by chy on 16/12/8.
//  Copyright © 2016年 Chy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYWaveLoadingView : UIView

+ (instancetype)loadingView;

- (void)animateStart;

- (void)animateStop;

@end
