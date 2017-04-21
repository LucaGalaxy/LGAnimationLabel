//
//  AnimationLabelEmitterView.m
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import "AnimationLabelEmitterView.h"

@implementation AnimationLabelEmitter

- (instancetype)initWithName:(NSString *)name particalName:(NSString *)particalName duration:(NSTimeInterval)duration {
    
    if (self = [super init]) {
        self.cell.name = name;
        self.duration = duration;
        
        UIImage *image;
        image = [UIImage imageNamed:particalName];

        self.cell.contents = (__bridge id _Nullable)(image.CGImage);
    }
    return self;
}

- (CAEmitterLayer *)layer {
    if (!_layer) {
        CAEmitterLayer *layer = [CAEmitterLayer layer];
        layer.emitterPosition = CGPointMake(10.f, 10.f);
        layer.emitterSize = CGSizeMake(10.f, 1.f);
        layer.renderMode = kCAEmitterLayerOutline;
        layer.emitterShape = kCAEmitterLayerLine;
        _layer = layer;
    }
    return _layer;
}

- (CAEmitterCell *)cell {
    if (!_cell) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name = @"sparkle";
        cell.birthRate = 150.f;
        cell.velocity = 50.f;
        cell.velocityRange = -80.f;
        cell.lifetime = 0.16;
        cell.lifetimeRange = 0.1;
        cell.emissionLongitude = (M_PI_2 * 2.0);
        cell.emissionRange = (M_PI_2 * 2.0);
        cell.scale = 0.1;
        cell.yAcceleration = 100;
        cell.scaleSpeed = -0.06;
        cell.scaleRange = 0.1;
        _cell = cell;
    }
    return _cell;
}

- (NSTimeInterval)duration {
    return _duration;
}

- (void)play {
    
    if (self.layer.emitterCells.count > 0) {
        return;
    }
    
    self.layer.emitterCells = @[self.cell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.birthRate = 0.0;
    });
}

- (void)stop {
    if (self.layer.superlayer) {
        [self.layer removeFromSuperlayer];
    }
}

- (AnimationLabelEmitter *)updateWithConfigureBlock:(AnimationLabelEmitterConfigureBlock)configureBlock {
    if (configureBlock) {
       configureBlock(self.layer, self.cell);
    }
    return self;
}
@end

@implementation AnimationLabelEmitterView

- (NSMutableDictionary<NSString *,AnimationLabelEmitter *> *)emitters {
    if (!_emitters) {
        _emitters = [NSMutableDictionary dictionary];
    }
    return _emitters;
}

- (AnimationLabelEmitter *)createEmitterWithName:(NSString *)name particalName:(NSString *)particalName duration:(NSTimeInterval)duration andEmitterConfigureBlock:(AnimationLabelEmitterConfigureBlock)configureBlock {
    
    AnimationLabelEmitter *emitter = [[AnimationLabelEmitter alloc] initWithName:name particalName:particalName duration:duration];
    AnimationLabelEmitter *e = [self emitterByName:name];
    if (e) {
        emitter = e;
    } else {
        if (configureBlock) {
            configureBlock(emitter.layer, emitter.cell);
        }
        [self.layer addSublayer:emitter.layer];
        [self.emitters setObject:emitter forKey:name];
    }
    
    return emitter;
}

- (AnimationLabelEmitter *)emitterByName:(NSString *)name {
    return [self.emitters objectForKey:name];
}

- (void)removeAllEmitters {
    [self.emitters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, AnimationLabelEmitter * _Nonnull emitter, BOOL * _Nonnull stop) {
        [emitter stop];
    }];
    [self.emitters removeAllObjects];
}

@end
