//
//  SourceEditorCommand.h
//  LWAssumeNonnull
//
//  Created by sunhr on 2016/11/17.
//  Copyright © 2016年 Uncle Wang Tech. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

typedef NS_ENUM(NSInteger, LWAssumeNonnullErrorType) {
    LWAssumeNonnullErrorTypeUnsupportedFileType = 1,
};

@interface SourceEditorCommand : NSObject <XCSourceEditorCommand>

@end
