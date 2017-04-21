//
//  PixelateEffectLabel.m
//  LGAnimationLabel
//
//  Created by luca.li on 2017/4/21.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "PixelateEffectLabel.h"

@implementation PixelateEffectLabel

- (void)loadEffect {
    NSString *disappearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectPixelate, AnimationPhasesDisappear];
    AnimationLabelEffectBlock disappearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.previousRects[index] CGRectValue] alpha:1.0 - progress size:self.font.pointSize andDrawingProgress:progress];
    };
    [self.effectBlocks setObject:disappearBlock forKey:disappearBlockKey];
    
    NSString *appearBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectPixelate, AnimationPhasesAppear];
    AnimationLabelEffectBlock appearBlock = ^(NSString *character, NSInteger index, NSTimeInterval progress){
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:[self.laterRects[index] CGRectValue] alpha:progress size:self.font.pointSize andDrawingProgress:1.0 - progress];
    };
    [self.effectBlocks setObject:appearBlock forKey:appearBlockKey];
    
    NSString *drawBlockKey = [NSString stringWithFormat:@"(%zi)(%zi)", AnimationLabelEffectPixelate, AnimationPhasesDraw];
    AnimationLabelDrawingBlock drawBlock = ^(AnimationCharacterLimbo *limbo){
        if (limbo.drawingProgress > 0.0) {
            UIImage *charImage = [self pixelateImageForCharLimbo:limbo withBlurRadius:limbo.drawingProgress * 6.0];
            [charImage drawInRect:limbo.rect];
            return YES;
        } else {
            return NO;
        }
    };
    [self.drawingBlocks setObject:drawBlock forKey:drawBlockKey];
}

- (UIImage *)pixelateImageForCharLimbo:(AnimationCharacterLimbo *)charLimbo withBlurRadius:(CGFloat)blurRadius {
    CGFloat scale = MIN([UIScreen mainScreen].scale, 1.0 / blurRadius);
    UIGraphicsBeginImageContextWithOptions(charLimbo.rect.size, false, scale);
    CGFloat fadeOutAlpha = MIN(1.0, MAX(0.0, charLimbo.drawingProgress * -2.0 + 2.0 + 0.01));
    CGRect rect = CGRectMake(0, 0, charLimbo.rect.size.width, charLimbo.rect.size.height);
    
    [charLimbo.character drawInRect:rect withAttributes:@{NSFontAttributeName : self.font, NSForegroundColorAttributeName : [self.textColor colorWithAlphaComponent:fadeOutAlpha]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
