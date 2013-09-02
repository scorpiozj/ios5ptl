//
//  ZJColumnView.m
//  Columns
//
//  Created by Zhu J on 9/2/13.
//  Copyright (c) 2013 Zhu J. All rights reserved.
//

#import "ZJColumnView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define kColumnCount   (3)

@implementation ZJColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Drawing code
    
    CGRect *columnRects = [self copyColumnRects];
    // Create a single path that contains all columns
    CGMutablePathRef path = CGPathCreateMutable();
    for (int column = 0; column < kColumnCount; column++) {
        CGPathAddRect(path, NULL, columnRects[column]);
    }
    free(columnRects);
    
    
    CFAttributedStringRef
    attrString = (__bridge CFTypeRef)self.attributedString;
    
    // Create the framesetter using the attributed string
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CTFrameRef
    frame = CTFramesetterCreateFrame(framesetter,
                                     CFRangeMake(0, 0),
                                     path,
                                     NULL);
    
    // Draw the frame into the current context
    CTFrameDraw(frame, context);

    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
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
