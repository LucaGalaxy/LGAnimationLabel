//
//  AnimationEasing.m
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import "AnimationEasing.h"

// http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// t = currentTime
// b = beginning
// c = change
// d = duration 默认1.0

@implementation AnimationEasing

+ (CGFloat)easeOutQuintWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    return (c * (pow((t / d - 1.0), 5) + 1.0) + b);
}

+ (CGFloat)easeInQuintWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    return (c * pow((t / d), 5) + b);
}

+ (CGFloat)easeOutBackWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    CGFloat s = 2.70158;
    CGFloat t2 = t / d - 1.0;
    return (CGFloat)(c * (t2 * t2 * ((s + 1.0) * t2 + s) + 1.0)) + b;
}

+ (CGFloat)easeOutBounceWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    if ((t / d) < 1 / 2.75) {
        return c * 7.5625 * (t / d) * (t / d) + b;
    } else if ((t / d) < 2 / 2.75) {
        t = (t / d) - 1.5 / 2.75;
        return c * (7.5625 * t * t + 0.75) + b;
    } else if ((t / d) < 2.5 / 2.75) {
        t = (t / d) - 2.25 / 2.75;
        return c * (7.5625 * t * t + 0.9375) + b;
    } else {
        t = (t / d) - 2.625 / 2.75;
        return c * (7.5625 * t * t + 0.984375) + b;
    }
}

@end
