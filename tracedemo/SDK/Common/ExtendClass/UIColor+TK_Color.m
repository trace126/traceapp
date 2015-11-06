//
//  UIColor+TK_Color.m
//  tracedemo
//
//  Created by cmcc on 15/9/12.
//  Copyright (c) 2015年 trace. All rights reserved.
//

#import "UIColor+TK_Color.h"

@implementation UIColor (TK_Color)


+ (UIColor *)TKcolorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    
    NSString * alphaString = @"FF";
    
    if([cString length ]== 8){
    
        alphaString = [cString substringToIndex:2];
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b,a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:alphaString] scanHexInt:&a];
    
    CGFloat  alphaValue = (float)a/255.0f;
    if(alpha == 1.0f){
    
//        DDLogInfo(@"get color alpha == %d",a);
        alpha = alphaValue;
    }
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)TKcolorWithHexString:(NSString *)color
{
    return [self TKcolorWithHexString:color alpha:1.0f];
}


@end