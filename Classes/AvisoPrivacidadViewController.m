//
//  AvisoPrivacidadViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/2/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "AvisoPrivacidadViewController.h"
#import "SWRevealViewController.h"
#import <WebKit/WebKit.h>
#import "Singleton.h"



@interface AvisoPrivacidadViewController ()

@end

@implementation AvisoPrivacidadViewController
@synthesize barButtom, Singleton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barButtom setTarget: self.revealViewController];
        [self.barButtom setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];
    
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    NSURL *nsurl=[NSURL URLWithString:self.Singleton.urlAvisoPrivacidad];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];

    
    
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


@end
