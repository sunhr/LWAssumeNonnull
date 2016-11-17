//
//  SourceEditorCommand.m
//  LWNonnullAssume
//
//  Created by sunhr on 2016/11/17.
//  Copyright © 2016年 Uncle Wang Tech. All rights reserved.
//

#import "SourceEditorCommand.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const LWAssumeNonnullBegin = @"NS_ASSUME_NONNULL_BEGIN";
NSString *const LWAssumeNonnullEnd = @"NS_ASSUME_NONNULL_END";

@interface SourceEditorCommand ()

@property (nullable, nonatomic, strong) NSMutableArray<NSString *> *lines;

@end

NS_ASSUME_NONNULL_END

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    self.lines = invocation.buffer.lines;
    
    NSArray<NSValue *> *allInterfaces = [self allInterfaces];
    
    NSUInteger delta = 0;
    
    for (NSValue *value in allInterfaces) {
        
        NSRange range = value.rangeValue;
        
        if ([self shouldAssumeNonnullBeginForInterface:range]) {
            
            delta = [self assumeNonnullBeginForInterface:range withDelta:delta];
        }
        
        if ([self shouldAssumeNonnullEndForInterface:range]) {
            
            delta = [self assumeNonnullEndForInterface:range withDelta:delta];
        }
    }
    
    self.lines = nil;
    
    completionHandler(nil);
}

- (NSArray<NSValue *> *)allInterfaces
{
    NSMutableArray<NSValue *> *interfaces = [NSMutableArray new];
    
    NSUInteger startLine = 0;
    
    for (NSUInteger i = 0; i < self.lines.count; i++) {
        
        NSString *line = self.lines[i];
        
        if ([line hasPrefix:@"@interface "]) {
            
            if (startLine == 0) {
                startLine = i;
            }
            continue;
        }
        
        if (startLine > 0 && [line hasPrefix:@"@end"]) {
            
            NSRange range = NSMakeRange(startLine, i - startLine);
            
            [interfaces addObject:[NSValue valueWithRange:range]];
            
            startLine = 0;
            
            continue;
        }
    }
    
    return interfaces;
}

- (BOOL)shouldAssumeNonnullBeginForInterface:(NSRange)rangeOfInterface
{
    NSUInteger line = rangeOfInterface.location;
    
    if (line > 0) {
        
        NSString *string = self.lines[line - 1];
        
        if ([string hasPrefix:LWAssumeNonnullBegin]) {
            return NO;
        }
    }
    
    if (line > 1) {
        
        NSString *string = self.lines[line - 2];
        
        if ([string hasPrefix:LWAssumeNonnullBegin]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)shouldAssumeNonnullEndForInterface:(NSRange)rangeOfInterface
{
    NSUInteger line = rangeOfInterface.location + rangeOfInterface.length;
    
    if (line + 1 < self.lines.count) {
        
        NSString *string = self.lines[line + 1];
        
        if ([string hasPrefix:LWAssumeNonnullEnd]) {
            return NO;
        }
    }
    
    if (line + 2 < self.lines.count) {
        
        NSString *string = self.lines[line + 2];
        
        if ([string hasPrefix:LWAssumeNonnullEnd]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSUInteger)assumeNonnullBeginForInterface:(NSRange)range withDelta:(NSUInteger)delta
{
    NSUInteger index = range.location;
    
    if (index + delta == 0 || (self.lines[index + delta - 1].length > 0 && ![self.lines[index + delta - 1] isEqualToString:@"\n"])) {
        
        [self.lines insertObject:@"\n" atIndex:index + delta];
        delta ++;
    }
    
    [self.lines insertObject:LWAssumeNonnullBegin atIndex:index + delta];
    delta++;
    
    [self.lines insertObject:@"\n" atIndex:index + delta];
    delta ++;
    
    return delta;
}

- (NSUInteger)assumeNonnullEndForInterface:(NSRange)range withDelta:(NSUInteger)delta
{
    NSUInteger index = range.location + range.length + 1;
    
    [self insertOrAddString:@"\n" atIndex:index + delta];
    delta++;
    
    [self insertOrAddString:LWAssumeNonnullEnd atIndex:index + delta];
    delta++;
    
    return delta;
}

- (void)insertOrAddString:(NSString *)string atIndex:(NSUInteger)index
{
    if (index >= self.lines.count) {
        [self.lines addObject:string];
    } else {
        [self.lines insertObject:string atIndex:index];
    }
}

@end
