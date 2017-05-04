//
//  ViewController.m
//  labelcoding
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ViewController.h"
#import "EvaporateEffectLabel.h"

@interface ViewController () <AnimationLabelDelegate>
@property (weak, nonatomic) IBOutlet AnimationLabel *label;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *effects;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.texts = @[@"first", @"test", @"start", @"不是吧"];
    
    // now we have implemented effects included in this array
    self.effects = @[@(AnimationLabelEffectScale), @(AnimationLabelEffectEvaporate), @(AnimationLabelEffectFall), @(AnimationLabelEffectPixelate), @(AnimationLabelEffectSparkle), @(AnimationLabelEffectAnvil)];
    
    self.label.text = @"";
    
    self.label.animationEnable = YES;
    self.label.delegate = self;
//    self.label.animationDuration = 0.1;
    
    // if you want to change the previewing effects
    // change the effect value below
    self.label.animationEffect = AnimationLabelEffectEvaporate;
    
    // AND you will also need to change the class name of self.label in storyboard!!
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeAction:(id)sender {
    NSInteger current = [self.texts indexOfObject:self.label.text];
    current ++;
    current = current % [self.texts count];
    self.label.text = [self.texts objectAtIndex:current];
}

- (IBAction)pauseAction:(id)sender {
    [self.label setProgress:0.2 needPause:YES];
}

- (IBAction)sliderAction:(UISlider *)sender {
    [self.label setProgress:sender.value needPause:YES];
}

- (void)animationLabelDidStart:(AnimationLabel *)label {

}

- (void)animationLabelDidComplete:(AnimationLabel *)label {

}

- (void)animationLabelOnProgress:(AnimationLabel *)label progress:(NSTimeInterval)progress {

}

@end
