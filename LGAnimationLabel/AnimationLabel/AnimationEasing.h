//
//  AnimationEasing.h
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationEasing : NSObject

// http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// t = currentTime
// b = beginning
// c = change
// d = duration default 1.0

+ (CGFloat)easeOutQuintWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)easeInQuintWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)easeOutBackWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)easeOutBounceWithT:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

@end
