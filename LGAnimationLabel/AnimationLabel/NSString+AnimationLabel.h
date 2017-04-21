//
//  NSString+AnimationLabel.h
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AnimationDiffResult;

typedef NS_ENUM(NSUInteger, AnimationLabelDiffType) {
    AnimationLabelDiffTypeSame = 0,
    AnimationLabelDiffTypeAdd = 1,
    AnimationLabelDiffTypeDelete,
    AnimationLabelDiffTypeMove,
    AnimationLabelDiffTypeMoveAndAdd,
    AnimationLabelDiffTypeReplace,
};

@interface NSString (AnimationLabel)

- (NSMutableArray <AnimationDiffResult *> *)diffResultBetweenString:(NSString *)lhs andString:(NSString *)rhs;

@end

@interface AnimationDiffResult : NSObject

@property (nonatomic, strong) NSNumber *diffType;   // 内容为AnimationLabelDiffType
@property (nonatomic, assign) NSInteger moveOffset;
@property (nonatomic, assign) BOOL skip;

@end
