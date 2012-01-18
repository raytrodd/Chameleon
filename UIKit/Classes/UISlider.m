//
//  UISlider.m
//  UIKit
//
//  Created by Peter Steinberger on 24.03.11.
//
/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UISlider.h"
#import "UITouch.h"
#import "UIColor.h"
#import "UIStringDrawing.h"
#import "UIGraphics.h"
#import "UIImage.h"
#import "UIImage+UIPrivate.h"

#define kUISliderTrackHeight 14
#define kUISliderViewHeight 29
#define kUISliderKnobWidth 27

@interface UISlider(Privates)
- (CGRect)knobRect;
- (CGRect)trackRect;
@end

@implementation UISlider

@synthesize value = _value;
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize position = _position;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor clearColor];
    _value = 0;
    _minimumValue = 0;
    _maximumValue = 10;
    
    _knobImage = [[UIImage _sliderKnobImage] retain];
    _trackImage = [[UIImage _sliderTrackImage] retain];
    _knobImageDisabled = [[UIImage _sliderKnobImageDisabled] retain];
  }
  return self;
}

- (void)dealloc
{
  [_knobImage release];
  [_trackImage release];
  [_knobImageDisabled release];;
  [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
  CGRect knobRect = [self knobRect];
  CGRect trackRect = CGRectInset(self.bounds, knobRect.size.width / 2, (kUISliderViewHeight - kUISliderTrackHeight) / 2);
  
  [_trackImage drawInRect:trackRect];
  UIImage* knobImage = self.enabled ? _knobImage : _knobImageDisabled;
  [knobImage drawInRect:knobRect];
}

- (CGRect)knobRect
{
  return CGRectMake(_position, 0, kUISliderKnobWidth, kUISliderViewHeight);
}

- (void)setValue:(float)value
{
  if (value != _value) {
    CGFloat valueDistance = _maximumValue - _minimumValue;
    CGFloat pixelDistance = self.bounds.size.width - [self knobRect].size.width;
    CGFloat progress = value / valueDistance;
    _position = (pixelDistance * progress);
    _value = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];  
    [self setNeedsDisplay];
  }
}

- (void)setPosition:(float)position
{
  if (position != _position) {
    CGFloat valueDistance = _maximumValue - _minimumValue;
    CGFloat pixelDistance = self.bounds.size.width - [self knobRect].size.width;
    CGFloat progress = position / pixelDistance;
    CGFloat value = (valueDistance * progress) + _minimumValue;
    _position = position;
    _value = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
  }
}

- (void)setFrame:(CGRect)frame
{
  [super setFrame:frame];
  float value = _value;
  _value = 0;
  [self setValue:value];
}

#pragma mark UIResponder

- (void)handleTouchAt:(CGFloat)x
{
  CGRect knobRect = [self knobRect];
  
  x = x - knobRect.size.width / 2;
  
  if (x < self.bounds.origin.x) {
    x = self.bounds.origin.x;
  } else if (x > (self.bounds.size.width - knobRect.size.width)) {
    x = self.bounds.size.width - knobRect.size.width;
  } 
  self.position = x;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGFloat x = [touch locationInView:self].x;
  [self handleTouchAt:x];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGFloat x = [touch locationInView:self].x;
  [self handleTouchAt:x];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; frame = (%.0f %.0f; %.0f %.0f); opaque = %@; layer = %@; value = %f>", [self className], self, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, (self.opaque ? @"YES" : @"NO"), self.layer, self.value];
}

@end
