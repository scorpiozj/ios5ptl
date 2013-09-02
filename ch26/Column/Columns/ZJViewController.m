//
//  ZJViewController.m
//  Columns
//
//  Created by Zhu J on 9/2/13.
//  Copyright (c) 2013 Zhu J. All rights reserved.
//

#import "ZJViewController.h"
#import "ZJColumnView.h"
#import "ZJRealColumnView.h"
#import <CoreText/CoreText.h>
@interface ZJViewController ()

@end

@implementation ZJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    CFMutableAttributedStringRef attrString;
    CTFontRef baseFont, boldFont, italicFont;
    
    // Create the base string.
    // Note how you can define a string over multiple lines.
    CFStringRef string = CFSTR
    (
     "Here is some simple text that includes bold and italics.\n"
     "\n"
     "We can even include some color."
     );
    
    // Create the mutable attributed string
    attrString = CFAttributedStringCreateMutable(NULL, 0);
    CFAttributedStringReplaceString(attrString,
                                    CFRangeMake(0, 0),
                                    string);
    
    // Set the base font
    baseFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                             16.0,
                                             NULL);
    CFIndex length = CFStringGetLength(string);
    CFAttributedStringSetAttribute(attrString,
                                   CFRangeMake(0, length),
                                   kCTFontAttributeName,
                                   baseFont);
    
    // Apply bold by finding the bold version of the current font.
    boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                  0,
                                                  NULL,
                                                  kCTFontBoldTrait,
                                                  kCTFontBoldTrait);
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("bold"),
                                                0),
                                   kCTFontAttributeName,
                                   boldFont);
    
    // Apply italics
    italicFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                    0,
                                                    NULL,
                                                    kCTFontItalicTrait,
                                                    kCTFontItalicTrait);
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("italics"),
                                                0),
                                   kCTFontAttributeName,
                                   italicFont);
    
    // Apply color
    CGColorRef color = [[UIColor redColor] CGColor];
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("color"),
                                                0),
                                   kCTForegroundColorAttributeName,
                                   color);
    /*
    // Center the last line
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting setting = {
        kCTParagraphStyleSpecifierAlignment,
        sizeof(alignment),
        &alignment};
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(&setting, 1);
    CFRange lastLineRange = CFStringFind(string, CFSTR("\n"),
                                         kCFCompareBackwards);
    ++lastLineRange.location;
    lastLineRange.length =
    CFStringGetLength(string) - lastLineRange.location;
    CFAttributedStringSetAttribute(attrString, lastLineRange,
                                   kCTParagraphStyleAttributeName,
                                   style);
    */
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//kCTLineBreakByWordWrapping;
    CTParagraphStyleSetting lineBreakSetting = {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode};
    CTParagraphStyleRef lineBreakStyle = CTParagraphStyleCreate(&lineBreakSetting, 1);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTParagraphStyleAttributeName, lineBreakStyle);
    
    CGRect rect = self.view.bounds;
    rect.size.height /= 2;
    
    ZJColumnView *label = [[ZJColumnView alloc]
                            initWithFrame:CGRectInset(rect,
                                                      10,
                                                      10)];
    label.attributedString = (__bridge id)attrString;
    [self.view addSubview:label];
    
    rect = CGRectMake(5, 300, 300, 150);
    ZJRealColumnView *label2 = [[ZJRealColumnView alloc]
                                initWithFrame:rect];

    label2.attributedString = (__bridge id)attrString;
    [self.view addSubview:label2];
    
    
    
    CFRelease(attrString);
    CFRelease(baseFont);
    CFRelease(boldFont);
    CFRelease(italicFont);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
