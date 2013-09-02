//
//  ZJRealColumnView.m
//  Columns
//
//  Created by Zhu J on 9/2/13.
//  Copyright (c) 2013 Zhu J. All rights reserved.
//

#import "ZJRealColumnView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define kColumnCount   (3)
@implementation ZJRealColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        CGAffineTransform
        transform = CGAffineTransformMakeScale(1, -1);
        CGAffineTransformTranslate(transform,
                                   0,
                                   -self.bounds.size.height);
        self.transform = transform;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Drawing code
    
    CGRect *columnRects = [self copyColumnRects];    
    CFMutableArrayRef paths = CFArrayCreateMutable(kCFAllocatorDefault , kColumnCount, &kCFTypeArrayCallBacks);
    
    // Create an array of layout paths, one for each column.
    for (int column = 0; column < kColumnCount; column++)
    {
        CGPathRef path = CGPathCreateWithRect(columnRects[column], NULL);
        CFArrayAppendValue(paths, path);
        CGPathRelease(path);
    }
    free(columnRects);
    
    
    CFAttributedStringRef
    attrString = (__bridge CFTypeRef)self.attributedString;
    
    // Create the framesetter using the attributed string
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    
    
    CFIndex pathCount = CFArrayGetCount(paths);
    CFIndex charIndex = 0;
    for (CFIndex pathIndex = 0; pathIndex < pathCount; ++pathIndex)
    {
        CGPathRef path = CFArrayGetValueAtIndex(paths, pathIndex);
        
//        // A CFDictionary containing the clipping path
//        CFStringRef keys[] = { kCTFramePathClippingPathAttributeName };
//        CFTypeRef values[] = { path };
//        CFDictionaryRef clippingPathDict = CFDictionaryCreate(NULL,
//                                                              (const void **)&keys, (const void **)&values,
//                                                              sizeof(keys) / sizeof(keys[0]),
//                                                              &kCFTypeDictionaryKeyCallBacks,
//                                                              &kCFTypeDictionaryValueCallBacks);
//        
//        // An array of clipping paths -- you can use more than one if needed!
//        NSArray *clippingPaths = [NSArray arrayWithObject:(__bridge NSDictionary*)clippingPathDict];
//        
//        // Create an options dictionary, to pass in to CTFramesetter
//        NSDictionary *optionsDict = [NSDictionary dictionaryWithObject:clippingPaths forKey:(NSString*)kCTFrameClippingPathsAttributeName];
//
//        
//        
//        
//        CTFrameRef  frame = CTFramesetterCreateFrame(framesetter,
//                                         CFRangeMake(charIndex, 0), path,
//                                        (__bridge CFTypeRef) optionsDict);
        
        
        CTFrameRef  frame = CTFramesetterCreateFrame(framesetter,
                                                     CFRangeMake(charIndex, 0), path,
                                                     NULL);
        
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        charIndex += frameRange.length;
        CFRelease(frame);
    }
    
    
    
        
    
    CFRelease(framesetter);

    CFRelease(paths);
}

- (CGRect *)copyColumnRects {
    CGRect bounds = CGRectInset([self bounds], 40, 0);
    int column;
    CGRect* columnRects = (CGRect*)calloc(kColumnCount,
                                          sizeof(*columnRects));
    // Start by setting the first column to cover the entire view.
    columnRects[0] = bounds;
    // Divide the columns equally across the frame’s width.
    CGFloat columnWidth = CGRectGetWidth(bounds) / kColumnCount;
    for (column = 0; column < kColumnCount - 1; column++)
    {
        CGRectDivide(columnRects[column], &columnRects[column],
                     &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    
    // Inset all columns by a few pixels of margin.
    for (column = 0; column < kColumnCount; column++)
    {
        columnRects[column] = CGRectInset(columnRects[column], 10.0, 10.0);
    }
    
    return columnRects;
}

@end
