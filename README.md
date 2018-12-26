# JHInputLimit
input limit, length limit, type limit, custom character limit
- 输入限制，长度限制，类型限制，自定义字符限制

---

# What

input limit for 'UITextField' and 'UITextView'
- `UITextField` 与 `UITextView` 的输入限制

input limit:
- input length
- input type
- custom input type

---

# Usage

```
    _textView.jh_inputLimit.length = 9;
    _textView.jh_inputLimit.type = JHInputLimitType_Alphabet | JHInputLimitType_Digital | JHInputLimitType_MyCharacters;
    _textView.jh_inputLimit.myCharacter = [NSSet setWithArray:@[@"!",@","]];
```

---

# API

```
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

@end
```
