//
//  AnimationLabelEmitterView.h
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^AnimationLabelEmitterConfigureBlock)(CAEmitterLayer *layer, CAEmitterCell *cell);

@interface AnimationLabelEmitter : NSObject

@property (nonatomic, strong) CAEmitterLayer *layer;
@property (nonatomic, strong) CAEmitterCell *cell;
@property (nonatomic, assign) NSTimeInterval duration;

- (instancetype)initWithName:(NSString *)name particalName:(NSString *)particalName duration:(NSTimeInterval)duration;

- (void)play;
- (void)stop;
- (AnimationLabelEmitter *)updateWithConfigureBlock:(AnimationLabelEmitterConfigureBlock)configureBlock;

@end

@interface AnimationLabelEmitterView : UIView

@property (nonatomic, strong) NSMutableDictionary <NSString *, AnimationLabelEmitter *> *emitters;

- (AnimationLabelEmitter *)createEmitterWithName:(NSString *)name
                                    particalName:(NSString *)particalName
                                        duration:(NSTimeInterval)duration
                        andEmitterConfigureBlock:(AnimationLabelEmitterConfigureBlock)configureBlock;

- (void)removeAllEmitters;

@end
