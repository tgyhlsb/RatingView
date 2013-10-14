//
//  RatingView.h
//  RatingView
//
//  Created by Tanguy on 19/07/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingViewDelegate;


@interface RatingView : UIView <UIGestureRecognizerDelegate>

@property (assign) id <RatingViewDelegate>  delegate;

@property (readwrite, nonatomic) CGFloat value;

@property (strong, readonly, nonatomic) NSString *selectedImageName;
@property (strong, readonly, nonatomic) NSString *unSelectedImageName;

- (id)initWithFrame:(CGRect)frame
  selectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage
           minValue:(NSInteger)min maxValue:(NSInteger)max
      intervalValue:(CGFloat)interval
         stepByStep:(BOOL)stepByStep;

@end

@protocol RatingViewDelegate <NSObject>
@optional

- (void)rateChanged:(RatingView *)sender;

@end
