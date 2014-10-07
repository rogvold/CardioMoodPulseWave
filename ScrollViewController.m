//
//  ScrollViewController.m
//  CMPulseWave
//
//  Created by nastia on 07.10.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.graphWidth.constant = self.view.bounds.size.width;
    self.view.backgroundColor = [UIColor greenColor];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateWidth) userInfo:nil repeats:YES];
}

- (void)updateWidth{
    self.graphWidth.constant += self.view.bounds.size.width;
    NSLog(@"%f", self.view.bounds.size.width);
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentOffset = CGPointMake(self.graphWidth.constant, 0);
//    [self.scrollView setContentOffset:CGPointMake(self.graphWidth.constant, 0) animated:YES];
//    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
