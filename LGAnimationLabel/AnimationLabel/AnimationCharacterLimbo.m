//
//  AnimationCharacterLimbo.m
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import "AnimationCharacterLimbo.h"

@implementation AnimationCharacterLimbo

- (instancetype)initWithCharaceter:(NSString *)character rect:(CGRect)rect alpha:(CGFloat)alpha size:(CGFloat)size andDrawingProgress:(NSTimeInterval)progress {
    if (self = [super init]) {
        self.character = character;
        self.rect = rect;
        self.alpha = alpha;
        self.size = size;
        self.drawingProgress = progress;
    }
    return self;
}

@end
