//
//  NSString+AnimationLabel.m
//  Phantom3
//
//  Created by luca.li on 2017/4/19.
//  Copyright © 2017年 LucaGalaxy. All rights reserved.
//

#import "NSString+AnimationLabel.h"

@implementation NSString (AnimationLabel)

- (NSMutableArray <AnimationDiffResult *> *)diffResultBetweenString:(NSString *)lhs andString:(NSString *)rhs {
    
    NSMutableArray <AnimationDiffResult *> *diffResults = [NSMutableArray array];
    
    NSMutableArray *newChars = [NSMutableArray array];
    [rhs enumerateSubstringsInRange:NSMakeRange(0, rhs.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [newChars addObject:substring];
    }];
    NSMutableArray *leftChars = [NSMutableArray array];
    [lhs enumerateSubstringsInRange:NSMakeRange(0, lhs.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [leftChars addObject:substring];
    }];
    
    NSInteger lhsLength = lhs.length;
    NSInteger rhsLength = rhs.length;
    NSMutableArray *skipIndexs = [NSMutableArray array];
    
    NSInteger maxLength = MAX(lhsLength, rhsLength);
    
    // 预创建diffResult进数组
    for (NSInteger i = 0; i < maxLength; i ++) {
        [diffResults addObject:[AnimationDiffResult new]];
    }
    
    for (NSInteger i = 0; i < maxLength; i ++) {
        // If new string is longer than the original one
        if (i > lhsLength - 1) {
            continue;
        }
        
        NSString *leftChar = leftChars[i];
        
        // Search left character in the new string
        BOOL foundCharacterInRhs = NO;
        for (NSString *newChar in newChars) {
            NSInteger j = [newChars indexOfObject:newChar];
            if ([skipIndexs containsObject:@(j)] || ![leftChar isEqualToString:newChar]) {
                continue;
            }
            
            [skipIndexs addObject:@(j)];
            foundCharacterInRhs = YES;
            
            if (i == j) {
                // Character not changed
                diffResults[i].diffType = @(AnimationLabelDiffTypeSame);
            } else {
                // foundCharacterInRhs and move
                diffResults[i].diffType = @(AnimationLabelDiffTypeMove);
                if (i <= rhsLength - 1) {
                    // Move to a new index and add a new character to new original place
                    diffResults[i].diffType = @(AnimationLabelDiffTypeMoveAndAdd);
                }
                diffResults[i].moveOffset = j - i;
            }
            break;
        }
        
        if (!foundCharacterInRhs) {
            if (i < rhsLength - 1) {
                diffResults[i].diffType = @(AnimationLabelDiffTypeReplace);
            } else {
                diffResults[i].diffType = @(AnimationLabelDiffTypeDelete);
            }
        }
    }
    
    NSInteger i = 0;
    for (AnimationDiffResult *result in diffResults) {
        switch ([result.diffType integerValue]) {
            case AnimationLabelDiffTypeMove:
            case AnimationLabelDiffTypeMoveAndAdd: {
                diffResults[i + result.moveOffset].skip = YES;
            }
                break;
            default:
                break;
        }
        i += 1;
    }
    
    return diffResults;
}
@end

@implementation AnimationDiffResult

- (NSNumber *)diffType {
    if (!_diffType) {
        _diffType = @(AnimationLabelDiffTypeAdd);
    }
    return _diffType;
}

@end
