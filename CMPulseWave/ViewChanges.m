//
//  ViewChanges.m
//  CMPulseWave
//
//  Created by nastia on 28.09.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "ViewChanges.h"

@interface ViewChanges ()

@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;

@end

@implementation ViewChanges

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self moveView:self.view2 toDeltaX:self.view2.frame.size.width];
    [self moving];
}


- (void)moveView:(UIView *)view toDeltaX:(CGFloat)x{
    CGRect frame1 = view.frame;
    frame1.origin.x += x;
    view.frame = frame1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) moving{
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self moveView:self.view2 toDeltaX:-self.view2.frame.size.width];
                         [self moveView:self.view1 toDeltaX:-self.view1.frame.size.width];
                         
                     }
                     completion:^(BOOL finished) {}];
    
}


-(void) timer{
    
}

@end
