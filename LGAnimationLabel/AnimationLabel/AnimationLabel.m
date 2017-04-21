//
//  AnimationLabel.m
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import "AnimationLabel.h"

@interface AnimationLabel ()

@property (nonatomic, strong) NSMutableArray <AnimationDiffResult *> *diffResults;
@property (nonatomic, strong) NSString *previousText;

@property (nonatomic, assign) NSInteger currentFrame;
@property (nonatomic, assign) NSInteger totalFrames;
@property (nonatomic, assign) NSInteger totalDelayFrames;

@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat charHeight;
@property (nonatomic, assign) NSInteger skipFramesCount;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation AnimationLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.startBlocks = [NSMutableDictionary dictionary];
        self.effectBlocks = [NSMutableDictionary dictionary];
        self.drawingBlocks = [NSMutableDictionary dictionary];
        self.progressBlocks = [NSMutableDictionary dictionary];
        self.skipFrameBlocks = [NSMutableDictionary dictionary];
        self.diffResults = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Functions for subclasses
- (void)loadEffect {
    // 子类自己实现
}

#pragma mark - Overrides
- (NSString *)text {
    return [super text];
}

- (void)setText:(NSString *)text {
    
    if ([self.text isEqualToString:text]) {
        return;
    }
    
    self.previousText = self.text?:@"";
    self.diffResults = [self.previousText diffResultBetweenString:self.previousText andString:text?:@""];
    [super setText:text?:@""];
    
    self.animationProgress = 0.0;
    self.currentFrame = 0;
    self.totalFrames = 0;
    
    [self setNeedsLayout];
    
    if (!self.animationEnable) {
        return;
    }
    
    if (![self.previousText isEqualToString:self.text]) {
        [self.displayLink setPaused:NO];
        NSString *blockKey = [NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesStart];
        AnimationLabelStartBlock block = [self.startBlocks objectForKey:blockKey];
        if (block) {
            block();
        }
        if ([self.delegate respondsToSelector:@selector(animationLabelDidStart:)]) {
            [self.delegate animationLabelDidStart:self];
        }
    }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    self.previousRects = [self rectsOfEachCharacterWithText:self.previousText andFont:self.font];
    self.laterRects = [self rectsOfEachCharacterWithText:self.text?:@"" andFont:self.font];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsLayout];
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayFrameTick)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (AnimationLabelEmitterView *)emitterView {
    if (!_emitterView) {
        AnimationLabelEmitterView *emitterView = [[AnimationLabelEmitterView alloc] initWithFrame:self.bounds];
        [self addSubview:emitterView];
        _emitterView = emitterView;
    }
    return _emitterView;
}

#pragma mark - getters
- (NSMutableDictionary<NSString *,AnimationLabelStartBlock> *)startBlocks {
    if (!_startBlocks) {
        _startBlocks = [NSMutableDictionary dictionary];
    }
    return _startBlocks;
}

- (NSMutableDictionary<NSString *,AnimationLabelEffectBlock> *)effectBlocks {
    if (!_effectBlocks) {
        _effectBlocks = [NSMutableDictionary dictionary];
    }
    return _effectBlocks;
}

- (NSMutableDictionary<NSString *,AnimationLabelProgressBlock> *)progressBlocks {
    if (!_progressBlocks) {
        _progressBlocks = [NSMutableDictionary dictionary];
    }
    return _progressBlocks;
}

- (NSMutableDictionary<NSString *,AnimationLabelDrawingBlock> *)drawingBlocks {
    if (!_drawingBlocks) {
        _drawingBlocks = [NSMutableDictionary dictionary];
    }
    return _drawingBlocks;
}

- (NSMutableDictionary<NSString *,AnimationLabelSkipFrameBlock> *)skipFrameBlocks {
    if (!_skipFrameBlocks) {
        _skipFrameBlocks = [NSMutableDictionary dictionary];
    }
    return _skipFrameBlocks;
}

- (NSMutableArray<NSValue *> *)previousRects {
    if (!_previousRects) {
        _previousRects = [NSMutableArray array];
    }
    return _previousRects;
}

- (NSMutableArray<NSValue *> *)laterRects {
    if (!_laterRects) {
        _laterRects = [NSMutableArray array];
    }
    return _laterRects;
}

- (float)animationDuration {
    if (_animationDuration == 0) {
        _animationDuration = 0.6f;
    }
    return _animationDuration;
}
@end

@implementation AnimationLabel (Animation)

- (void)displayFrameTick {
    if (self.displayLink.duration > 0.0 && self.totalFrames == 0) {
        float frameRate = (float)self.displayLink.duration / (float)self.displayLink.frameInterval;
        self.totalFrames = ceil(self.animationDuration / frameRate);
        
        float totalDelay = (float)self.text.length * self.animationCharacterDelay;
        self.totalDelayFrames = ceil(totalDelay / frameRate);
    }
    
    self.currentFrame += 1;
    
    if (![self.previousText isEqualToString:self.text] && self.currentFrame < self.totalFrames + self.totalDelayFrames + 5) {
        self.animationProgress += 1.0 / (float)self.totalFrames;
        NSString *blockKey = [NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesSkipFrames];
        AnimationLabelSkipFrameBlock block = [self.skipFrameBlocks objectForKey:blockKey];
        if (block) {
            self.skipFramesCount ++;
            if (self.skipFramesCount > block()) {
                self.skipFramesCount = 0;
                [self setNeedsDisplay];
            }
        } else {
            [self setNeedsDisplay];
        }
        
        if ([self.delegate respondsToSelector:@selector(animationLabelOnProgress:progress:)]) {
            [self.delegate animationLabelOnProgress:self progress:self.animationProgress];
        }
    } else {
        [self.displayLink setPaused:YES];
        if ([self.delegate respondsToSelector:@selector(animationLabelDidComplete:)]) {
            [self.delegate animationLabelDidComplete:self];
        }
    }
}

- (NSMutableArray <NSValue *>*)rectsOfEachCharacterWithText:(NSString *)text andFont:(UIFont *)font {
    NSMutableArray *charRects = [NSMutableArray array];
    __block CGFloat leftOffset = 0.0;
    
    self.charHeight = [@"Leg" sizeWithAttributes:@{NSFontAttributeName : font}].height;
    
    CGFloat topOffset = (self.bounds.size.height - self.charHeight) / 2.0;
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        CGSize charSize = [substring sizeWithAttributes:@{NSFontAttributeName : font}];
        [charRects addObject:[NSValue valueWithCGRect:CGRectMake(leftOffset, topOffset, charSize.width, charSize.height)]];
        leftOffset += charSize.width;
    }];
    
    self.totalWidth = (float)leftOffset;
    
    CGFloat stringLeftOffset = 0.0;
    
    switch (self.textAlignment) {
        case NSTextAlignmentCenter: {
            stringLeftOffset = (CGFloat)((self.bounds.size.width) - self.totalWidth) / 2.0;
        }
            break;
        case NSTextAlignmentRight: {
            stringLeftOffset = (CGFloat)((self.bounds.size.width) - self.totalWidth);
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *offsetedCharRects = [NSMutableArray array];
    for (NSValue *rectValue in charRects) {
        CGRect rect = [rectValue CGRectValue];
        [offsetedCharRects addObject:[NSValue valueWithCGRect:CGRectOffset(rect, stringLeftOffset, 0.0)]];
    }
    return offsetedCharRects;
}

- (AnimationCharacterLimbo *)limboOfOriginCharacter:(NSString *)character atIndex:(NSUInteger)index progress:(NSTimeInterval)progress {
    
    CGRect currentRect = [[self.previousRects objectAtIndex:index] CGRectValue];
    CGFloat originX = currentRect.origin.x;
    CGFloat laterX = currentRect.origin.x;
    AnimationDiffResult *diffResult = [self.diffResults objectAtIndex:index];
    CGFloat currentFontSize = self.font.pointSize;
    CGFloat currentAlpha = 1.0;
    
    switch ([diffResult.diffType integerValue]) {
            // Move the character that exists in the new text to current position
        case AnimationLabelDiffTypeMove:
        case AnimationLabelDiffTypeMoveAndAdd:
        case AnimationLabelDiffTypeSame: {
            laterX = [[self.laterRects objectAtIndex:index+diffResult.moveOffset] CGRectValue].origin.x;
            currentRect.origin.x = [AnimationEasing easeOutQuintWithT:progress b:originX c:laterX - originX d:1.0];
        }
            break;
        default: {
            // Otherwise, remove it
            AnimationLabelEffectBlock block = [self.effectBlocks objectForKey:[NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesDisappear]];
            if (block) {
                return block(character, index, progress);
            } else {
                // And scale it by default
                CGFloat fontEase = [AnimationEasing easeOutQuintWithT:progress b:0 c:self.font.pointSize d:1.0];
                // For emojis
                currentFontSize = MAX(0.0001, self.font.pointSize - fontEase);
                currentAlpha = 1.0 - progress;
                currentRect = CGRectOffset([[self.previousRects objectAtIndex:index] CGRectValue], 0, self.font.pointSize - currentFontSize);
            }
        }
            break;
    }
    
    AnimationCharacterLimbo *limbo = [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:currentRect alpha:currentAlpha size:currentFontSize andDrawingProgress:0.0];
    return limbo;
}

- (AnimationCharacterLimbo *)limboOfLaterCharacter:(NSString *)character atIndex:(NSUInteger)index progress:(NSTimeInterval)progress {
    
    CGRect currentRect = [[self.laterRects objectAtIndex:index] CGRectValue];
    CGFloat currentFontSize = [AnimationEasing easeOutQuintWithT:progress b:0 c:self.font.pointSize d:1.0];
    
    AnimationLabelEffectBlock block = [self.effectBlocks objectForKey:[NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesAppear]];
    if (block) {
        return block(character, index, progress);
    } else {
        currentFontSize = [AnimationEasing easeOutQuintWithT:progress b:0.0 c:self.font.pointSize d:1.0];
        // for emojis
        currentFontSize = MAX(0.0001, currentFontSize);
        CGFloat yOffset = self.font.pointSize - currentFontSize;
        return [[AnimationCharacterLimbo alloc] initWithCharaceter:character rect:CGRectOffset(currentRect, 0, yOffset) alpha:self.animationProgress size:currentFontSize andDrawingProgress:0.0];
    }
}

- (NSMutableArray <AnimationCharacterLimbo *>*)limboOfOriginCharacters {
    
    NSMutableArray *limbos = [NSMutableArray array];
    
    [self.previousText enumerateSubstringsInRange:NSMakeRange(0, self.previousText.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSTimeInterval progress = 0.0;
        AnimationLabelProgressBlock block = [self.progressBlocks objectForKey:[NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesProgress]];
        if (block) {
            progress = block(substringRange.location, self.animationProgress, NO);
        } else {
            progress = MIN(1.0, MAX(0.0, self.animationProgress + self.animationCharacterDelay * substringRange.location));
        }
        
        AnimationCharacterLimbo *limboOfChar = [self limboOfOriginCharacter:substring atIndex:substringRange.location progress:progress];
        if (limboOfChar) {
            [limbos addObject:limboOfChar];
        }
    }];
    
    [self.text enumerateSubstringsInRange:NSMakeRange(0, self.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (substringRange.location >= self.diffResults.count) {
            *stop = YES;
        } else {
            NSTimeInterval progress = 0.0;
            AnimationLabelProgressBlock block = [self.progressBlocks objectForKey:[NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesProgress]];
            if (block) {
                progress = block(substringRange.location, self.animationProgress, YES);
            } else {
                progress = MIN(1.0, MAX(0.0, self.animationProgress - self.animationCharacterDelay * substringRange.location));
            }
            
            // Don't draw character that already exists
            AnimationDiffResult *diffResult = [self.diffResults objectAtIndex:substringRange.location];
            if (diffResult.skip) {
                // continue
            } else {
                switch ([diffResult.diffType integerValue]) {
                    case AnimationLabelDiffTypeReplace:
                    case AnimationLabelDiffTypeMoveAndAdd:
                    case AnimationLabelDiffTypeAdd:
                    case AnimationLabelDiffTypeDelete: {
                        AnimationCharacterLimbo *limboOfChar = [self limboOfLaterCharacter:substring atIndex:substringRange.location progress:progress];
                        if (limboOfChar) {
                            [limbos addObject:limboOfChar];
                        }
                    }
                        break;
                    default: {
                        
                    }
                        break;
                }
            }
        }
    }];
    
    return limbos;
}

@end

@implementation AnimationLabel (Drawing)

- (void)didMoveToSuperview {
    // 调用子类的加载方法
    if ([self respondsToSelector:@selector(loadEffect)]) {
        [self performSelector:@selector(loadEffect)];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    if (!self.animationEnable) {
        [super drawTextInRect:rect];
        return;
    }
    
    for (AnimationCharacterLimbo *charLimbo in [self limboOfOriginCharacters]) {
        
        CGRect charRect = charLimbo.rect;

        BOOL willAvoidDefaultDrawing = NO;
        NSString *blockKey = [NSString stringWithFormat:@"(%zi)(%zi)", self.animationEffect, AnimationPhasesDraw];
        AnimationLabelDrawingBlock block = [self.drawingBlocks objectForKey:blockKey];
        if (block) {
            willAvoidDefaultDrawing = block(charLimbo);
        }
        
        if (!willAvoidDefaultDrawing) {
            NSString *s = charLimbo.character;
            [s drawInRect:charRect withAttributes: @{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:charLimbo.size],
                                                     NSForegroundColorAttributeName : [self.textColor colorWithAlphaComponent:charLimbo.alpha]}];
        }
    }
}
@end
