//
//  JHInputLimit.m
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

#import "JHInputLimit.h"

@interface JHInputLimit()
@property (nonatomic,    weak) UITextField *textField;
@property (nonatomic,    weak) UITextView *textView;

@property (nonatomic,    copy) NSString *originText;
@end

@implementation JHInputLimit

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextField:(UITextField *)textField{
    _textField = textField;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:textField];
}

- (void)setTextView:(UITextView *)textView{
    _textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:textView];
}

- (void)textFieldTextDidChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    if (textField == _textField) {
        _originText = textField.text;

        [self shouldHandleText:textView type:1];
        
        if (_textFieldDidChangeTextBlock) {
            _textFieldDidChangeTextBlock(self, _textField);
        }
    }
}

- (void)textViewTextDidChanged:(NSNotification *)noti
{
    UITextView *textView = (UITextView *)noti.object;
    if (textView == _textView) {
        _originText = textView.text;

        [self shouldHandleText:textField type:2];
        
        if (_textViewDidChangeTextBlock) {
            _textViewDidChangeTextBlock(self, _textView);
        }
    }
}

- (void)shouldHandleText:(id<UITextInput>)input type:(NSInteger)type
{
    BOOL work = YES;
    // 当前语言
    NSString *language = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    // 系统自带的中文输入法
    if ([language isEqualToString:@"zh-Hans"]) {
        // 获取高亮部分
        UITextPosition *position = [input positionFromPosition:input.markedTextRange.start offset:0];
        // 有高亮选择的文字时，不进行处理
        if (position) {
            work = NO;
        }
    }
    
    if (work) {
        NSString *text = [self handleText:_originText];
        if (![_originText isEqualToString:text]) {
            if (type == 1) {
                _textField.text = text;
            }else if (type == 2) {
                _textView.text = text;
            }
        }
    }
}

- (NSString *)handleText:(NSString *)text{
    NSString *outputString;
    
    if (_length > 0 && _type == JHInputLimitType_None) {
        if (text.length > _length) {
            outputString = [text substringToIndex:[text rangeOfComposedCharacterSequenceAtIndex:_length].location];
        }else{
            outputString = text;
        }
    }else{
        
        NSMutableString *mString = @"".mutableCopy;
        for (int i = 0; i < text.length; i++) {
            NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:i];
            unichar c = [text characterAtIndex:range.location];
            
            if (_type & JHInputLimitType_Alphabet) {
                if ((c >= 'A' && c <= 'Z') ||
                    (c >= 'a' && c <= 'z')) {
                    [mString appendFormat:@"%c",c];
                }
            }
            if (_type & JHInputLimitType_Digital) {
                if ((c >= '0' && c <= '9')) {
                    [mString appendFormat:@"%c",c];
                }
            }
            if (_type & JHInputLimitType_Alphabet_Upper) {
                if ((c >= 'A' && c <= 'Z')) {
                    [mString appendFormat:@"%c",c];
                }
            }
            if (_type & JHInputLimitType_Alphabet_Lower) {
                if ((c >= 'a' && c <= 'z')) {
                    [mString appendFormat:@"%c",c];
                }
            }
            if (_type & JHInputLimitType_Chinese) {
                if ((c >= 0x4E00 && c <= 0x9FA5)) {
                    [mString appendFormat:@"%@",[NSString stringWithCharacters:&c length:range.length]];
                }
            }
            if ((_type & JHInputLimitType_MyCharacters) &&
                _myCharacter.count > 0) {
                NSString *s = [NSString stringWithCharacters:&c length:range.length];
                if ([_myCharacter containsObject:s]) {
                    [mString appendFormat:@"%@",s];
                }
            }
            
            if (_length > 0) {
                if (mString.length < _length) {
                    outputString = mString;
                }else if (mString.length == _length) {
                    outputString = mString;
                    break;
                }
            }else{
                outputString = mString;
            }
        }
    }
    
    return outputString;
}

@end
