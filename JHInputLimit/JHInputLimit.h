//
//  JHInputLimit.h
//  JHKit
//
//  Created by HaoCold on 2018/9/3.
//  Copyright © 2018年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JHInputLimit;

typedef void(^JHInputLimitTextFieldDidChangeText)(JHInputLimit *inputLimit, UITextField *textField);
typedef void(^JHInputLimitTextViewDidChangeText)(JHInputLimit *inputLimit, UITextView *textView);

typedef NS_OPTIONS(NSUInteger, JHInputLimitType) {
    JHInputLimitType_None           = 0,        /* 任何字符*/
    JHInputLimitType_Alphabet       = 1 << 0,   /* 字母*/
    JHInputLimitType_Digital        = 1 << 1,   /* 数字*/
    JHInputLimitType_Alphabet_Upper = 1 << 2,   /* 大写字母*/
    JHInputLimitType_Alphabet_Lower = 1 << 3,   /* 小写字母*/
    JHInputLimitType_Chinese        = 1 << 4,   /* 中文，基本汉字，Unicode:0x4E00-0x9FA5 */
    JHInputLimitType_MyCharacters   = 1 << 5,   /* 自定义的字符串，custom characters*/
};

@interface JHInputLimit : NSObject

/** Default is 0, it means no limit of max length.*/
@property (nonatomic,  assign) NSUInteger  length;

/** Limit type of input.*/
@property (nonatomic,  assign) JHInputLimitType  type;

/** Customt characters, the 'type' should contain 'JHInputLimitType_MyCharacters'.*/
@property (nonatomic,  strong) NSSet *myCharacter;

/** textField'text change block.*/
@property (nonatomic,    copy) JHInputLimitTextFieldDidChangeText textFieldDidChangeTextBlock;

/** textView'text change block.*/
@property (nonatomic,    copy) JHInputLimitTextViewDidChangeText textViewDidChangeTextBlock;

/** input text */
@property (nonatomic,    copy,   readonly) NSString *originText;

@end
