//
// Authors: Mats Hauge <mats@agens.no>
//          Håvard Fossli <hfossli@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "ANYSubscriber.h"
#import "ANYActivity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANYAnimation : NSObject

+ (instancetype)createAnimation:(ANYActivity * (^)(ANYSubscriber *subscriber))create;

- (ANYActivity *)start;

- (ANYActivity *)subscribe:(ANYSubscriber *)subscriber;

@end

@interface ANYAnimation (Operators)

- (instancetype)onError:(nullable dispatch_block_t)onError;
- (instancetype)onError:(nullable dispatch_block_t)onError onCompletion:(nullable dispatch_block_t)onCompletion;

- (instancetype)onCompletion:(nullable dispatch_block_t)onCompletion;
- (instancetype)onCompletion:(nullable dispatch_block_t)onCompletion onError:(nullable dispatch_block_t)onError;

- (instancetype)onCompletionOrError:(void(^)(BOOL success))onCompletionOrError;

- (instancetype)before:(nullable dispatch_block_t)before;
- (instancetype)after:(nullable dispatch_block_t)after;

+ (instancetype)empty;
+ (instancetype)defer:(ANYAnimation *(^)(void))defer;

- (instancetype)groupWith:(ANYAnimation *)animation;
+ (instancetype)group:(NSArray <ANYAnimation *> *)animations;

- (instancetype)delay:(NSTimeInterval)delay;

- (instancetype)chain:(NSArray <ANYAnimation *> *)animations;

- (instancetype)then:(ANYAnimation *)animation;

- (instancetype)repeat;
- (instancetype)repeat:(NSUInteger)count;

@end


@interface ANYAnimation (Debug)

- (instancetype)name:(NSString *)name;
- (instancetype)nameFormat:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
