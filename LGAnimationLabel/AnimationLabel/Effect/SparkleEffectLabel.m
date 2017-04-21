//
//  SparkleEffectLabel.m
//  LGAnimationLabel
//
//  Created by luca.li on 2017/4/21.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "SparkleEffectLabel.h"

@implementation SparkleEffectLabel

- (void)loadEffect {
    
    NSString *starBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesStart];
    AnimationLabelStartBlock startBlock = ^{
        [self.emitterView removeAllEmitters];
    };
    [self.startBlocks setObject:startBlock forKey:starBlockKey];
    
    NSString *progressBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesProgress];
    AnimationLabelProgressBlock progressBlock = ^(NSInteger index, NSTimeInterval progress, BOOL isNewChar){
        if (isNewChar) {
            return MIN(1.0, MAX(0.0, progress));
        }
        CGFloat j = sin((double)index) * 1.5;
        return MIN(1.0, MAX(0.0001, progress + self.animationCharacterDelay * (float)j));
    };
    [self.progressBlocks setObject:progressBlock forKey:progressBlockKey];
    
    NSString *disappearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesDisappear];
    AnimationLabelEffectBlock disappearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.previousRects[index] CGRectValue] alpha:1.0 - progress size:self.font.pointSize andDrawingProgress:0.0];
    };
    [self.effectBlocks setObject:disappearBlock forKey:disappearBlockKey];
    
    NSString *appearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesAppear];
    AnimationLabelEffectBlock appearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        if (character && [character length] > 0) {
            CGRect rect = [self.laterRects[index] CGRectValue];
            CGPoint emitterPosition = CGPointMake(rect.origin.x + rect.size.width / 2.0, progress * rect.size.height * 0.9 + rect.origin.y);

            AnimationLabelEmitter *emitter = [self.emitterView createEmitterWithName:[NSString stringWithFormat:@"c(%zi)", index] particalName:@"Sparkle" duration:self.animationDuration andEmitterConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                layer.emitterSize = CGSizeMake(rect.size.width, 1.0);
                layer.renderMode = kCAEmitterLayerOutline;
                cell.emissionLongitude = M_PI / 2.0;
                cell.scale = self.font.pointSize / 300.0;
                cell.scaleSpeed = self.font.pointSize / 300.0 * - 1.5;
                cell.color = self.textColor.CGColor;
                cell.birthRate = self.font.pointSize * (arc4random_uniform(7) + 3);
            }];
            emitter = [emitter updateWithConfigureBlock:^(CAEmitterLayer *layer, CAEmitterCell *cell) {
                layer.emitterPosition = emitterPosition;
            }];
            [emitter play];
        }
        
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.laterRects[index] CGRectValue] alpha:self.animationProgress size:self.font.pointSize andDrawingProgress:progress];
    };
    [self.effectBlocks setObject:appearBlock forKey:appearBlockKey];
    
    NSString *drawBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesDraw];
    AnimationLabelDrawingBlock drawBlock = ^(AnimationCharacterLimbo *limbo){
        if (limbo.drawingProgress > 0.0) {
            
            NSDictionary * maskedInfo = [self maskedImageForCharLimbo:limbo withProgress:limbo.drawingProgress];
            UIImage *charImage = maskedInfo[@"image"];
            CGRect charRect = [maskedInfo[@"rect"] CGRectValue];
            
            [charImage drawInRect:charRect];
            
            return YES;
        } else {
            return NO;
        }
    };
    [self.drawingBlocks setObject:drawBlock forKey:drawBlockKey];
    
    NSString *skipBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectSparkle, AnimationPhasesSkipFrames];
    AnimationLabelSkipFrameBlock skipBlock = ^{
        return (NSInteger)1;
    };
    [self.skipFrameBlocks setObject:skipBlock forKey:skipBlockKey];
}

// 返回值为键值对
// @"image" : UIImage
// @"rect" : [NSValue of CGRect]
- (NSDictionary *)maskedImageForCharLimbo:(AnimationCharacterLimbo *)charLimbo withProgress:(CGFloat)progress {
    CGFloat maskedHeight = charLimbo.rect.size.height * MAX(0.01, progress);
    CGSize maskedSize = CGSizeMake(charLimbo.rect.size.width, maskedHeight);
    UIGraphicsBeginImageContextWithOptions(maskedSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rect = CGRectMake(0, 0, charLimbo.rect.size.width, maskedHeight);
    [charLimbo.character drawInRect:rect withAttributes:@{NSFontAttributeName: self.font,
                                                          NSForegroundColorAttributeName: self.textColor}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect newRect = CGRectMake(charLimbo.rect.origin.x, charLimbo.rect.origin.y, charLimbo.rect.size.width, maskedHeight);
    
    return @{@"image" : newImage,
             @"rect"  : [NSValue valueWithCGRect:newRect]};
}

@end
