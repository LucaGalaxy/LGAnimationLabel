//
//  EvaporateEffectLabel.m
//  LGAnimationLabel
//
//  Created by luca.li on 2017/4/20.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "EvaporateEffectLabel.h"

@implementation EvaporateEffectLabel

- (void)loadEffect {
    NSString *progressBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectEvaporate, AnimationPhasesProgress];
    AnimationLabelProgressBlock progressBlock = ^(NSInteger index, NSTimeInterval progress, BOOL isNewChar){
        NSInteger j = round(cos((double)index * 1.2f));
        NSTimeInterval delay = isNewChar ? self.animationCharacterDelay * -1.0 : self.animationCharacterDelay;
        return MIN(1.0, MAX(0.0, self.animationProgress + delay * (float)j));
    };
    [self.progressBlocks setObject:progressBlock forKey:progressBlockKey];
    
    NSString *disappearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectEvaporate, AnimationPhasesDisappear];
    AnimationLabelEffectBlock disappearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        NSTimeInterval newProgress = [AnimationEasing easeOutQuintWithT:progress b:0.0 c:1.0 d:1.0];
        CGFloat yOffset = -0.8 * self.font.pointSize * newProgress;
        CGRect currentRect = CGRectOffset([[self.previousRects objectAtIndex:index] CGRectValue], 0, yOffset);
        CGFloat currentAlpha = 1.0 - newProgress;
        
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:currentRect alpha:currentAlpha size:self.font.pointSize andDrawingProgress:0.0];
    };
    [self.effectBlocks setObject:disappearBlock forKey:disappearBlockKey];
    
    NSString *appearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectEvaporate, AnimationPhasesAppear];
    AnimationLabelEffectBlock appearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        NSTimeInterval newProgress = 1.0 - [AnimationEasing easeOutQuintWithT:progress b:0.0 c:1.0 d:1.0];
        CGFloat yOffset = 1.2 * self.font.pointSize * newProgress;
        CGRect currentRect = CGRectOffset([[self.laterRects objectAtIndex:index] CGRectValue], 0, yOffset);
        CGFloat currentAlpha = self.animationProgress;
        
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:currentRect alpha:currentAlpha size:self.font.pointSize andDrawingProgress:0.0];
    };
    [self.effectBlocks setObject:appearBlock forKey:appearBlockKey];
}

@end
