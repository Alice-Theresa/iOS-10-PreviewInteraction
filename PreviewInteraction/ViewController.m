//
//  ViewController.m
//  PreviewInteraction
//
//  Created by S.C. on 16/9/20.
//  Copyright © 2016年 Kabylake. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, readwrite, strong) UIPreviewInteraction   *previewInteraction;
@property (nonatomic, readwrite, strong) UIViewPropertyAnimator *animator;
@property (nonatomic, readwrite, strong) UIImageView            *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.previewInteraction          = [[UIPreviewInteraction alloc] initWithView:self.view];
    self.previewInteraction.delegate = self;
}

#pragma mark - Preview阶段，相当于Peek，必须实现

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)transitionProgress ended:(BOOL)ended {

    if (ended) {
        [self previewSetting];
    }
}

#pragma mark - Commit阶段，相当于Pop，可选

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
    
    self.animator.fractionComplete = transitionProgress;
}

#pragma mark - 停止交互，必须实现

- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {

    [self.imageView removeFromSuperview];
}

#pragma mark - Preview设置

- (void)previewSetting {
    
    self.imageView                        = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.image                  = [UIImage imageNamed:@"Image"];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UIVisualEffectView *effectView        = [[UIVisualEffectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    effectView.effect                     = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [self.imageView addSubview:effectView];
    
    UITapGestureRecognizer *tapToClose    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.imageView addGestureRecognizer:tapToClose];

    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
        effectView.effect = nil;
    }];
}

#pragma mark - 关闭Pop出的页面

- (void)close {
    
    [self.imageView removeFromSuperview];
}

@end
