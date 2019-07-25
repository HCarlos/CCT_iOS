//
//  RightViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "RightViewController.h"
#import "SWRevealViewController.h"
#import "DenunciaTVC.h"
#import "Singleton.h"
#import "SplashVC.h"

@interface RightViewController () <SplashVCDelegate>
@end

@implementation RightViewController
@synthesize barButtom, arrSegue, Singleton, vista, btnDA, btnDN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];

    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.arrSegue =[NSArray arrayWithObjects:@"sgDN",@"sgDA", nil];
    
    if (self.Singleton.IsInit) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SplashVC *splash = [storyboard instantiateViewControllerWithIdentifier:@"SplashVCSegue"];
        splash.delegate = self;
        [self presentViewController:splash animated:YES completion:nil];
        self.Singleton.IsInit = NO;
    }
    
}

- (void)viewDidAppear:(BOOL)animate{
    // animación boton 1
    [self AnimateDenunciaNormal];
    // animación boton 2
    [self AnimateDenunciaAnonima];
}

-(void)AnimateDenunciaNormal{
    self.btnDN.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self.view addSubview:self.btnDN];
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.btnDN.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.btnDN.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.btnDN.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

-(void)AnimateDenunciaAnonima{
    self.btnDA.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self.view addSubview:self.btnDA];
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.btnDA.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.btnDA.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.btnDA.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController tapGestureRecognizer];

    if ( revealViewController )
    {
        [self.barButtom setTarget: self.revealViewController];
        [self.barButtom setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:arrSegue[ [self.Singleton getIdTipoDenuncia] ]]) {
        DenunciaTVC *sg = (DenunciaTVC *) segue.destinationViewController;
        sg.IdTipoDenuncia = [self.Singleton getIdTipoDenuncia];
        //NSLog(@"Tipo Denuncia: %d", [self.Singleton getIdTipoDenuncia]);
    }
}

- (IBAction)btnDN:(id)sender {
    [self.Singleton setTipoDenuncia:0];

}

- (IBAction)btnDA:(id)sender {
    [self.Singleton setTipoDenuncia:1];
}
         
         
#pragma Métodos del Protocolo
- (void)cerrarVentana {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
