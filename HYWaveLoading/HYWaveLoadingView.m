//
//  HYWaveLoadingView.m
//  HYWaveLoading
//
//  Created by chy on 16/12/8.
//  Copyright © 2016年 Chy. All rights reserved.
//

#import "HYWaveLoadingView.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSUInteger, HYWaveType) {
    HYWaveTypeSin,
    HYWaveTypeCos,
};

@interface HYWaveLoadingView ()

@property (nonatomic, assign) CGFloat frequency; // frequency
@property (nonatomic, strong) UIView * grayView;
@property (nonatomic, strong) UIView * sinView;
@property (nonatomic, strong) UIView * cosView;
@property (nonatomic, strong) CAShapeLayer * sinShapeLayer;
@property (nonatomic, strong) CAShapeLayer * cosShapeLayer;
///
/// 加入到runloop中，循环执行目标函数
///
@property (nonatomic, strong) CADisplayLink * displayLink;

// 波浪相关的参数
@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveMid;
@property (nonatomic, assign) CGFloat maxAmplitude;

@property (nonatomic, assign) CGFloat phaseShift;
@property (nonatomic, assign) CGFloat phase;

@end

static const CGFloat kHYWaveAnimateDuration = 10;
static NSString * const kHYKeyWaveAnimation = @"positionWave";

@implementation HYWaveLoadingView

// MARK: - Instance methods
//--------------------------------------------------------------------

+ (instancetype)loadingView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

// MARK: - Public methods
//--------------------------------------------------------------------

- (void)animateStart
{
    [self.displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    CGPoint position = self.sinShapeLayer.position;
    position.y = position.y - self.bounds.size.height - 10;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.sinShapeLayer.position];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.duration = kHYWaveAnimateDuration;
    animation.repeatCount = HUGE_VAL;
    animation.removedOnCompletion = YES;
    [self.sinShapeLayer addAnimation:animation forKey:kHYKeyWaveAnimation];
    [self.cosShapeLayer addAnimation:animation forKey:kHYKeyWaveAnimation];
}

- (void)animateStop
{
    [self.displayLink invalidate];
    [self.sinShapeLayer removeAllAnimations];
    [self.cosShapeLayer removeAllAnimations];
    self.sinShapeLayer.path = nil;
    self.cosShapeLayer.path = nil;
}

// MARK: - Private methods
//--------------------------------------------------------------------
- (void)setupUI
{
    _sinShapeLayer = [CAShapeLayer layer];
    _sinShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _sinShapeLayer.fillColor = [UIColor greenColor].CGColor;
    _sinShapeLayer.frame = CGRectMake(0,
                                      self.bounds.size.height / 2 ,
                                      self.bounds.size.width,
                                      self.bounds.size.height);
    
    _cosShapeLayer = [CAShapeLayer layer];
    _cosShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _cosShapeLayer.fillColor = [UIColor greenColor].CGColor;
    _cosShapeLayer.frame = CGRectMake(0,
                                      self.bounds.size.height / 2,
                                      self.bounds.size.width,
                                      self.bounds.size.height);
    
    self.waveHeight = CGRectGetHeight(self.bounds) * 0.5;
    self.waveWidth  = CGRectGetWidth(self.bounds);
    self.frequency = 1;
    self.phase = 0;
    self.phaseShift = 4;
    self.waveMid = self.waveWidth / 2.0f;
    self.maxAmplitude = self.waveHeight * .1;
    
    _grayView = [[UIView alloc] initWithFrame:self.bounds];
    _grayView.backgroundColor = [UIColor grayColor];
    [self addSubview:_grayView];
    
    _sinView = [[UIView alloc] initWithFrame:self.bounds];
    _sinView.backgroundColor = [UIColor greenColor];
    [self addSubview:_sinView];
    
    _cosView = [[UIView alloc] initWithFrame:self.bounds];
    _cosView.backgroundColor = [UIColor brownColor];
    [self addSubview:_cosView];
    
    _sinView.layer.mask = _sinShapeLayer;
    _cosView.layer.mask = _cosShapeLayer;
}

- (void)updateWave:(CADisplayLink *)displayLink
{
    self.phase += self.phaseShift;
    self.sinShapeLayer.path = [self createWavePathWithType:HYWaveTypeSin].CGPath;
    self.cosShapeLayer.path = [self createWavePathWithType:HYWaveTypeCos].CGPath;
}

- (UIBezierPath *)createWavePathWithType:(HYWaveType)type
{
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        endX = x;
        CGFloat y = 0;
        if (type == HYWaveTypeSin) {
            y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
        } else {
            y = self.maxAmplitude * cosf(360.0 / _waveWidth *(x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
        }
        
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(self.bounds) + 10;
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    return wavePath;

}

@end
