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
    [self moveView:self.view2 toX:self.view2.frame.size.width];
    [self moving];
}


- (void)moveView:(UIView *)view toX:(CGFloat)x{
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
                         [self moveView:self.view2 toX:-self.view2.frame.size.width];
                         [self moveView:self.view1 toX:-self.view1.frame.size.width];
//                         
//                         CGRect frame1 = self.view1.frame;
//                         frame1.origin.x -= self.view1.frame.size.width;
//                         self.view1.frame = frame1;
                         
                     }
                     completion:^(BOOL finished) {}];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
