//
//  AnvilEffectLabel.m
//  LGAnimationLabel
//
//  Created by luca.li on 2017/4/21.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "AnvilEffectLabel.h"

@implementation AnvilEffectLabel

- (void)loadEffect {
    
    NSString *starBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectAnvil, AnimationPhasesStart];
    AnimationLabelStartBlock startBlock = ^{
        [self.emitterView removeAllEmitters];
        
        if (self.laterRects.count == 0) {
            return;
        }
        CGRect centerRect = [self.laterRects[self.laterRects.count / 2] CGRectValue];
        
        [self.emitterView createEmitterWithName:@"leftSmoke" particalName:@"Smoke" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            layer.emitterSize = CGSizeMake(1.0, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x, centerRect.origin.y + centerRect.size.height / 1.3);
            layer.renderMode = kCAEmitterLayerSurface;
            cell.emissionLongitude = M_PI / 2.0;
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 130;
            cell.birthRate = 60;
            cell.velocity = 80 + arc4random_uniform(60);
            cell.velocityRange = 100;
            cell.yAcceleration = -40;
            cell.xAcceleration = 70;
            cell.emissionLongitude = - M_PI_2;
            cell.emissionRange = M_PI_4 / 5.0;
            cell.lifetime = self.animationDuration * 2.0;
            cell.spin = 10;
            cell.alphaSpeed = -0.5 / self.animationDuration;
        }];
        
        [self.emitterView createEmitterWithName:@"rightSmoke" particalName:@"Smoke" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            layer.emitterSize = CGSizeMake(1.0, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x, centerRect.origin.y + centerRect.size.height / 1.3);
            layer.renderMode = kCAEmitterLayerSurface;
            cell.emissionLongitude = M_PI / 2.0;
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 130;
            cell.birthRate = 60;
            cell.velocity = 80 + arc4random_uniform(60);
            cell.velocityRange = 100;
            cell.yAcceleration = -40;
            cell.xAcceleration = -70;
            cell.emissionLongitude = M_PI_2;
            cell.emissionRange = - M_PI_4 / 5.0;
            cell.lifetime = self.animationDuration * 2.0;
            cell.spin = -10;
            cell.alphaSpeed = -0.5 / self.animationDuration;
        }];
        
        [self.emitterView createEmitterWithName:@"leftFragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x, centerRect.origin.y + centerRect.size.height / 1.3);
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 350;
            cell.yAcceleration = 0;
            cell.xAcceleration = (float) 10 * arc4random_uniform(10);
            cell.emissionLongitude = - M_PI_2;
            cell.emissionRange = M_PI_4 / 5.0;
            cell.lifetime = self.animationDuration;
            cell.alphaSpeed = -2;
        }];
        
        [self.emitterView createEmitterWithName:@"rightFragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x, centerRect.origin.y + centerRect.size.height / 1.3);
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 350;
            cell.yAcceleration = 0;
            cell.xAcceleration = (float) - 10 * arc4random_uniform(10);
            cell.emissionLongitude = M_PI_2;
            cell.emissionRange = - M_PI_4 / 5.0;
            cell.lifetime = self.animationDuration;
            cell.alphaSpeed = -2;
        }];
        
        [self.emitterView createEmitterWithName:@"fragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x, centerRect.origin.y + centerRect.size.height / 1.3);
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 250;
            cell.velocityRange = (float) 30 + arc4random_uniform(20);
            cell.yAcceleration = 500;
            cell.emissionLongitude = 0;
            cell.emissionRange = M_PI_2;
            cell.alphaSpeed = -1;
            cell.lifetime = self.animationDuration;
        }];
    };
    [self.startBlocks setObject:startBlock forKey:starBlockKey];
    
    NSString *progressBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectAnvil, AnimationPhasesProgress];
    AnimationLabelProgressBlock progressBlock = ^(NSInteger index, NSTimeInterval progress, BOOL isNewChar){
        if (isNewChar) {
            return MIN(1.0, MAX(0.0, progress));
        }
        CGFloat j = sin((double)index) * 1.7;
        return MIN(1.0, MAX(0.0001, progress + self.animationCharacterDelay * (float)j));
    };
    [self.progressBlocks setObject:progressBlock forKey:progressBlockKey];
    
    NSString *disappearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectAnvil, AnimationPhasesDisappear];
    AnimationLabelEffectBlock disappearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.previousRects[index] CGRectValue] alpha:1.0 - progress size:self.font.pointSize andDrawingProgress:0.0];
    };
    [self.effectBlocks setObject:disappearBlock forKey:disappearBlockKey];
    
    NSString *appearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectAnvil, AnimationPhasesAppear];
    AnimationLabelEffectBlock appearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        
        CGRect rect = [self.laterRects[index] CGRectValue];
        
        if (progress < 1.0) {
            CGFloat easingValue = [AnimationEasing easeOutBounceWithT:progress b:0.0 c:1.0 d:1.0];
            rect.origin.y = rect.origin.y * easingValue;
        }
        
        if (progress > self.animationDuration * 0.5) {
            
            NSTimeInterval end = self.animationDuration * 0.55;
            
            AnimationLabelEmitter *fragmentsEmitter = [self.emitterView createEmitterWithName:@"fragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            }];
            [fragmentsEmitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                if (progress > end) {
                    layer.birthRate = 0.0;
                }
            }];
            [fragmentsEmitter play];
            
            AnimationLabelEmitter *leftFragmentsEmitter = [self.emitterView createEmitterWithName:@"leftFragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
            }];
            [leftFragmentsEmitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                if (progress > end) {
                    layer.birthRate = 0.0;
                }
            }];
            [leftFragmentsEmitter play];
            
            AnimationLabelEmitter *rightFragmentsEmitter = [self.emitterView createEmitterWithName:@"rightFragments" particalName:@"Fragment" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                
            }];
            [rightFragmentsEmitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                if (progress > end) {
                    layer.birthRate = 0.0;
                }
            }];
            [rightFragmentsEmitter play];
            
            if (progress > self.animationDuration * 0.63) {
                
                end = self.animationDuration * 0.7;
                
                AnimationLabelEmitter *leftSmokeEmitter = [self.emitterView createEmitterWithName:@"leftSmoke" particalName:@"Smoke" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                    
                }];
                [leftSmokeEmitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                    if (progress > end) {
                        layer.birthRate = 0.0;
                    }
                }];
                [leftSmokeEmitter play];
                
                AnimationLabelEmitter *rightSmokeEmitter = [self.emitterView createEmitterWithName:@"rightSmoke" particalName:@"Smoke" duration:0.6 andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                }];
                [rightSmokeEmitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                    if (progress > end) {
                        layer.birthRate = 0.0;
                    }
                }];
                [rightSmokeEmitter play];
            }
        }
        
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:rect alpha:self.animationProgress size:self.font.pointSize andDrawingProgress:progress];
    };
    [self.effectBlocks setObject:appearBlock forKey:appearBlockKey];
}

@end
