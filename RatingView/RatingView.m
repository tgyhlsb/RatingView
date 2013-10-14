//
//  RatingView.m
//  RatingView
//
//  Created by Tanguy on 19/07/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "RatingView.h"

@interface RatingView()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *frontImageView;

@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UIImage *frontImage;

@property (strong, readwrite, nonatomic) NSString *selectedImageName;
@property (strong, readwrite, nonatomic) NSString *unSelectedImageName;

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic) CGFloat intervalValue;

@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) NSInteger itemWidth;

@property (nonatomic) NSInteger clipInterval;
@property (nonatomic) NSInteger clipsCount;

@property (nonatomic) BOOL stepByStep;

@end

@implementation RatingView

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        CGRect backViewFrame = self.bounds;
        backViewFrame.size.height = self.itemWidth;
        backViewFrame.size.width = self.itemWidth * self.itemsCount;
        backViewFrame.origin.y = (self.bounds.size.height - backViewFrame.size.height)/2;
        backViewFrame.origin.x = (self.bounds.size.width - backViewFrame.size.width)/2;
        _backImageView = [[UIImageView alloc] initWithFrame:backViewFrame];
        [_backImageView setBackgroundColor:[UIColor colorWithPatternImage:self.backImage]];
    }
    return _backImageView;
}

- (UIImageView *)frontImageView
{
    if (!_frontImageView)
    {
        CGRect frontViewFrame = self.bounds;
        frontViewFrame.size.height = self.itemWidth;
        frontViewFrame.size.width = self.itemWidth * self.itemsCount;
        frontViewFrame.origin.y = (self.bounds.size.height - frontViewFrame.size.height)/2;
        frontViewFrame.origin.x = (self.bounds.size.width - frontViewFrame.size.width)/2;
        _frontImageView = [[UIImageView alloc] initWithFrame:frontViewFrame];
        [_frontImageView setBackgroundColor:[UIColor colorWithPatternImage:self.frontImage]];
    }
    return _frontImageView;
}

- (UIImage *)backImage
{
    if (!_backImage)
    {
        CGSize backImgSize = CGSizeMake(self.itemWidth, self.itemWidth);
        _backImage = [self imageWithImage:[UIImage imageNamed:self.unSelectedImageName] scaledToSize:backImgSize];
    }
    return _backImage;
}

- (UIImage *)frontImage
{
    if (!_frontImage)
    {
        CGSize frontImgSize = CGSizeMake(self.itemWidth, self.itemWidth);
        _frontImage = [self imageWithImage:[UIImage imageNamed:self.selectedImageName] scaledToSize:frontImgSize];
    }
    return _frontImage;
}

#define EXCEPTION_NAME @"RatingView : Invalid settings."
#define EXCEPTION_MESSAGE @"Could not determine items size with min, max and interval values defined."
- (id)initWithFrame:(CGRect)frame
  selectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage
           minValue:(NSInteger)min maxValue:(NSInteger)max
      intervalValue:(CGFloat)interval
         stepByStep:(BOOL)stepByStep
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _stepByStep = stepByStep;
        _maxValue = max;
        _minValue = min;
        _intervalValue = interval;
        
        _selectedImageName = selectedImage;
        _unSelectedImageName = unSelectedImage;
        
        _itemsCount = _maxValue - _minValue;
        _itemWidth = frame.size.width / _itemsCount;
        _itemWidth = MIN(_itemWidth, frame.size.height);
        
        float testClipCounts = (_maxValue - _minValue)/_intervalValue;
        _clipsCount = round(testClipCounts);
        
        if (testClipCounts == _clipsCount) {
            _clipInterval = _itemWidth * _itemsCount / _clipsCount;
        } else {
            [NSException raise:EXCEPTION_NAME format:EXCEPTION_MESSAGE];
        }
        
        [self addSubview:self.backImageView];
        [self addSubview:self.frontImageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.delegate = self;
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delegate = self;
        
        
        [self addGestureRecognizer:panRecognizer];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self.frontImageView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self selectItemWithLocation:translation withCallback:NO];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            [self selectItemWithLocation:[recognizer locationInView:self] withCallback:YES];
            break;
        }
            
        default: // When moving
        {
            if (self.stepByStep)
            {
                [self selectItemWithLocation:translation withCallback:NO];
            } else {
                if ((translation.x >= 0) && (translation.x <= self.clipsCount * self.clipInterval))
                {
                    CGRect newFrame = self.frontImageView.frame;
                    newFrame.size.width = translation.x;
                    self.frontImageView.frame = newFrame;
                }
            }
        }
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.frontImageView];
    [self selectItemWithLocation:location withCallback:YES];
}

- (void)selectItemWithLocation:(CGPoint)location withCallback:(BOOL)callBack
{
    NSInteger intX = round(location.x);
    
    NSInteger remaining = intX % self.clipInterval;
    NSInteger fullClipsNumber = (intX - remaining) / self.clipInterval;
    
    if ((remaining - self.clipInterval/2) > 0)
    {
        fullClipsNumber ++; // rounded correction
    }
    
    
    self.value = (fullClipsNumber * self.intervalValue);
    
    if ([self.delegate respondsToSelector:@selector(rateChanged:)] && callBack)
    {
        [self.delegate rateChanged:self];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setValue:(CGFloat)value
{
    _value = MAX(value, self.minValue);
    _value =  MIN(_value, self.maxValue);
    CGRect tempFrame = self.frontImageView.frame;
    tempFrame.size.width = _value * self.itemWidth;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frontImageView.frame = tempFrame;
    }];
}


@end
