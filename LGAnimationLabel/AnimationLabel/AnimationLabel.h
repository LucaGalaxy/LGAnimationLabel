//
//  AnimationLabel.h
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "AnimationLabelEffect.h"
#import "NSString+AnimationLabel.h"
#import "AnimationCharacterLimbo.h"
#import "AnimationEasing.h"
#import "AnimationLabelEmitterView.h"

@class AnimationLabel, AnimationCharacterLimbo;

typedef NS_ENUM(NSUInteger, AnimationPhases) {
    AnimationPhasesStart,
    AnimationPhasesAppear,
    AnimationPhasesDisappear,
    AnimationPhasesDraw,
    AnimationPhasesProgress,
    AnimationPhasesSkipFrames,
};

typedef void(^AnimationLabelStartBlock)(void);
typedef AnimationCharacterLimbo*(^AnimationLabelEffectBlock)(NSString *character, NSInteger index, NSTimeInterval progress);
typedef BOOL(^AnimationLabelDrawingBlock)(AnimationCharacterLimbo *limbo);
typedef CGFloat(^AnimationLabelProgressBlock)(NSInteger index, NSTimeInterval progress, BOOL isNewChar);
typedef NSInteger(^AnimationLabelSkipFrameBlock)(void);

@protocol AnimationLabelDelegate <NSObject>

- (void)animationLabelDidStart:(AnimationLabel *)label;
- (void)animationLabelDidComplete:(AnimationLabel *)label;
- (void)animationLabelOnProgress:(AnimationLabel *)label progress:(NSTimeInterval)progress;

@end

@interface AnimationLabel : UILabel

@property (nonatomic, weak) id <AnimationLabelDelegate> delegate;

@property (nonatomic, assign) float animationProgress;  // default 0.0
@property (nonatomic, assign) float animationDuration;  // defalut 0.6
@property (nonatomic, assign) float animationCharacterDelay;     // default 0.026
@property (nonatomic, assign) float animationEnable;    // default YES
@property (nonatomic, assign) AnimationLabelEffect animationEffect; // default SCALE

// -------------- 子类调用部分开始 --------------
// 注：这里的Key值格式如下 @"(%zi)(%zi)", AnimationEffect, AnimationPhases
@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelStartBlock> *startBlocks;
@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelEffectBlock> *effectBlocks;
@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelDrawingBlock> *drawingBlocks;
@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelProgressBlock> *progressBlocks;
@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelSkipFrameBlock> *skipFrameBlocks;
@property (nonatomic, strong) NSMutableArray <NSValue *> *previousRects;
@property (nonatomic, strong) NSMutableArray <NSValue *> *laterRects;
@property (nonatomic, strong) AnimationLabelEmitterView *emitterView;

// 效果装载接口，子类需要实现
- (void)loadEffect;
// -------------- 子类调用部分结束 --------------

@end

@interface AnimationLabel (Animation)

- (void)displayFrameTick;
- (NSMutableArray <NSValue *>*)rectsOfEachCharacterWithText:(NSString *)text andFont:(UIFont *)font;

@end

@interface AnimationLabel (Drawing)

- (void)didMoveToSuperview;
- (void)drawTextInRect:(CGRect)rect;

@end
