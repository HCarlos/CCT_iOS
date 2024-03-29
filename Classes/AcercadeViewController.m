//
//  AcercadeViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/2/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "AcercadeViewController.h"
#import "SWRevealViewController.h"
#import <WebKit/WebKit.h>
#import "Singleton.h"


@interface AcercadeViewController ()

@end

@implementation AcercadeViewController
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
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    NSURL *nsurl = [NSURL URLWithString:self.Singleton.urlAcercaDe];

    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                            timeoutInterval: 10.0];
    
    [webView loadRequest:nsrequest];
    [webView reload];
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
