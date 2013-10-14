//
//  RatingView.h
//  RatingView
//
//  Created by Tanguy Hélesbeux on 14/10/13.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
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
