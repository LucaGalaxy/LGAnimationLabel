//
//  FallLabel.m
//  LGAnimationLabel
//
//  Created by luca.li on 2017/4/20.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "FallEffectLabel.h"

@implementation FallEffectLabel

- (void)loadEffect {
    NSString *progressBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectFall, AnimationPhasesProgress];
    AnimationLabelProgressBlock progressBlock = ^(NSInteger index, NSTimeInterval progress, BOOL isNewChar){
        if (isNewChar) {
            return MIN(1.0, MAX(0.0, progress - self.animationCharacterDelay * (float)index / 1.7));
        }
        CGFloat j = sin((double)index) * 1.7;
        return MIN(1.0, MAX(0.0001, progress + self.animationCharacterDelay * (float)j));
    };
    [self.progressBlocks setObject:progressBlock forKey:progressBlockKey];
    
    NSString *disappearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectFall, AnimationPhasesDisappear];
    AnimationLabelEffectBlock disappearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.previousRects[index] CGRectValue] alpha:1.0 - progress size:self.font.pointSize andDrawingProgress:progress];
    };
    [self.effectBlocks setObject:disappearBlock forKey:disappearBlockKey];
    
    NSString *appearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectFall, AnimationPhasesAppear];
    AnimationLabelEffectBlock appearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        CGFloat currentFontSize = [AnimationEasing easeOutQuintWithT:progress b:0.0 c:self.font.pointSize d:1.0];
        CGFloat yOffset = self.font.pointSize - currentFontSize;
        
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:CGRectOffset([self.laterRects[index] CGRectValue], 0, yOffset) alpha:self.animationProgress size:currentFontSize andDrawingProgress:0.0];
    };
    [self.effectBlocks setObject:appearBlock forKey:appearBlockKey];
    
    NSString *drawBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectFall, AnimationPhasesDraw];
    AnimationLabelDrawingBlock drawBlock = ^(AnimationCharacterLimbo *limbo){
        if (limbo.drawingProgress > 0.0) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGRect charRect = limbo.rect;
            CGContextSaveGState(context);
            CGFloat charCenterX = charRect.origin.x + charRect.size.width / 2.0;
            CGFloat charBottomY = charRect.origin.y + charRect.size.height - self.font.pointSize / 6.0;
            UIColor *charColor = self.textColor;
            
            if (limbo.drawingProgress > 0.5) {
                CGFloat ease = [AnimationEasing easeInQuintWithT:limbo.drawingProgress - 0.4 b:0.0 c:1.0 d:0.5];
                charBottomY = charBottomY + ease * 10.0;
                CGFloat fadeOutAlpha = MIN(1.0, MAX(0.0, limbo.drawingProgress * - 2.0 + 2.0 + 0.01));
                charColor = [self.textColor colorWithAlphaComponent:fadeOutAlpha];
            }
            
            charRect = CGRectMake(charRect.size.width / -2.0, charRect.size.height * -1.0 + self.font.pointSize / 6.0, charRect.size.width, charRect.size.height);
            CGContextTranslateCTM(context, charCenterX, charBottomY);
            
            CGFloat angle = sin((double)limbo.rect.origin.x) > 0.5 ? 168 : -168;
            CGFloat rotation = [AnimationEasing easeOutBackWithT:MIN(1.0, limbo.drawingProgress) b:0.0 c:1.0 d:1.0] * angle;
            CGContextRotateCTM(context, rotation * M_PI / 180.0);
            NSString *s = limbo.character;
            [s drawInRect:charRect withAttributes:@{NSFontAttributeName: [self.font fontWithSize:limbo.size],
                                                    NSForegroundColorAttributeName: charColor}];
            CGContextRestoreGState(context);
            
            return YES;
        } else {
            return NO;
        }
    };
    [self.drawingBlocks setObject:drawBlock forKey:drawBlockKey];
}

@end
