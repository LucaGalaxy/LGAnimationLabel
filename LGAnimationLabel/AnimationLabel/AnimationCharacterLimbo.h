//
//  AnimationCharacterLimbo.h
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationCharacterLimbo : NSObject

@property (nonatomic, strong) NSString *character;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat drawingProgress;

- (instancetype)initWithCharaceter:(NSString *)character rect:(CGRect)rect alpha:(CGFloat)alpha size:(CGFloat)size andDrawingProgress:(NSTimeInterval)progress;

@end
