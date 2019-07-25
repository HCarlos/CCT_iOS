//
//  LeftTableViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "LeftTableViewController.h"
#import "RightViewController.h"
#import "Opciones.h"
#import "SWRevealViewController.h"
#import "MisDenunciasTVC.h"
#import "AvisoPrivacidadViewController.h"
#import "AcercadeViewController.h"
#import "Singleton.h"


@implementation LeftTableViewController{
    NSInteger _previouslySelectedRow;
}

@synthesize opciones;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    
    
    
    [super viewDidLoad];

    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];
    

    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    
    /*
    self.aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutVC"]; // make sure you give the controller this same identifier in the storyboard
    [self addChildViewController:self.aboutVC];
    [self.aboutVC didMoveToParentViewController:self];
    self.aboutVC.view.frame = self.utilityView.bounds;
    [self.utilityView addSubview:self.aboutVC.aboutView];
*/
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _previouslySelectedRow = -1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [opciones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* txtCel = [[NSString alloc] init];
    switch (indexPath.row) {
        case 0:
            txtCel = @"Denuncias";
            break;
        case 1:
            txtCel = @"MisDenuncias";
            break;
        case 2:
            txtCel = @"Aviso";
            break;
        case 3:
            txtCel = @"Acercade";
            break;
        case 4:
            txtCel = @"SinUso";
            break;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:txtCel forIndexPath:indexPath];

    /*
    Opciones *opt = _opciones[indexPath.row];
    cell.textLabel.text = opt.name;
    */
    
    return cell;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        opciones = [NSMutableArray array];
        [opciones addObject:[Opciones newDataObject:0 value:@"Denuncias"]];
        [opciones addObject:[Opciones newDataObject:1 value:@"Mis denuncias"]];
        [opciones addObject:[Opciones newDataObject:2 value:@"Aviso de Privacidad"]];
        [opciones addObject:[Opciones newDataObject:3 value:@"Acerca DE"]];
        [opciones addObject:[Opciones newDataObject:4 value:@"Sin Uso"]];
    }
    
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[SWRevealViewControllerSegueSetController class]] )
    {
        
        //UINavigationController *navController = segue.destinationViewController;
        //RightViewController* cvc = [navController childViewControllers].firstObject;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
    
    if ( row == _previouslySelectedRow )
    {
        [revealController revealToggleAnimated:YES];
        return;
    }
    
    _previouslySelectedRow = row;
    
    UIViewController *frontController = nil;
    switch ( row )
    {
        case 0:
        {
            RightViewController *denController = [[RightViewController alloc] init];
            frontController = denController;
            break;
        }
        case 1:
        {
            MisDenunciasTVC *misDenunciasController = [[MisDenunciasTVC alloc] init];
            frontController = misDenunciasController;
            break;
        }
        case 2:
        {
            AcercadeViewController *acercadeController = [[AcercadeViewController alloc] init];
            frontController = acercadeController;
            break;
        }
        case 3:
        {
            AcercadeViewController *acercadeController = [[AcercadeViewController alloc] init];
            frontController = acercadeController;
            break;
        }
    }
    
/*
    if ( row != 2 )
    {
        [revealController setFrontViewController:frontController animated:YES];    //sf
        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
    }
    else
    {
        [revealController setFrontViewController:frontController animated:YES];    //sf
        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    }
  */
    
 //   [revealController setFrontViewController:frontController animated:YES];    //sf

}


/*


#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}
*/

@end
