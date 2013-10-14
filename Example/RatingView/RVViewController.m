//
//  RVViewController.h
//  RatingView
//
//  Created by Tanguy Hélesbeux on 14/10/13.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
//

#import "RVViewController.h"
#import "RatingView.h"

@interface RVViewController ()

@property (strong, nonatomic) RatingView *ratingView;

@end

@implementation RVViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.ratingView = [[RatingView alloc] initWithFrame:CGRectMake(60, 50, 200, 40)
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:0.5
                                             stepByStep:NO];
    self.ratingView.delegate = self;
    [self.view addSubview:self.ratingView];
    
    
    RatingView *RV0 = [[RatingView alloc] initWithFrame:CGRectMake(60, 150, 200, 40)
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:0.5
                                             stepByStep:YES];
    RV0.delegate = self;
    [self.view addSubview:RV0];
    
    RatingView *RV1 = [[RatingView alloc] initWithFrame:CGRectMake(60, 250, 200, 40)
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:10
                                          intervalValue:0.5
                                             stepByStep:NO];
    RV1.delegate = self;
    [self.view addSubview:RV1];
    
    RatingView *RV2 = [[RatingView alloc] initWithFrame:CGRectMake(60, 350, 200, 40)
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:2
                                          intervalValue:0.5
                                             stepByStep:NO];
    RV2.delegate = self;
    [self.view addSubview:RV2];
}

- (IBAction)increaseRating:(id)sender
{
    self.ratingView.value = self.ratingView.value + 1;
}

#pragma mark RatingView delegate

- (void)rateChanged:(RatingView *)ratingView
{
    NSLog(@"rate value = %f", ratingView.value);
}

@end
