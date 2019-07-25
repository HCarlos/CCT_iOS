//
//  SplashVC.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/23/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "SplashVC.h"

@interface SplashVC ()

@end

@implementation SplashVC
@synthesize textView, viewSplash;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    [self AnimateSplash];
}

-(void)AnimateSplash{
    self.viewSplash.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self.view addSubview:self.viewSplash];
    [UIView animateWithDuration:0.3/2 animations:^{
        self.viewSplash.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.viewSplash.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.viewSplash.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}


- (IBAction)btnCerrarVentana:(id)sender {
    [self.delegate cerrarVentana];
}
@end
