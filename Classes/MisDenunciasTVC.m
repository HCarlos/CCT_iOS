//
//  MisDenunciasTableViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/3/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "MisDenunciasTVC.h"
#import "SWRevealViewController.h"
#import "Opciones.h"
#import "Singleton.h"
#import "MisDenunciasTVCell.h"
#import "MiDenunciaVC.h"

@interface MisDenunciasTVC ()
@end

@implementation MisDenunciasTVC{
    NSMutableArray *Combo;
    NSMutableArray *filteredOpciones;
    BOOL isFiltered;
}
@synthesize tableView, barButtom, btnRefresh, Singleton, opciones ;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];
    [self.Singleton getUrlMisDenuncias];
    
    [self getDataOptions:self.Singleton.urlMisDenuncias];
    
    
    isFiltered = false;
    
}

#pragma Trabajando con el TextSearch

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        isFiltered = false;
    }else{
        isFiltered = true;
        filteredOpciones = [[NSMutableArray alloc] init];
        for(Opciones *opc in opciones){
            NSString *txtSearch = [NSString stringWithFormat:@"%@%@%@",opc.Value, opc.VString1, opc.VString2];
            NSRange nameRange = [txtSearch rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredOpciones addObject:[Opciones newDataObject:opc.Key value:opc.Value VString1:opc.VString1 VString2:opc.VString2]];
            }
            
        }
        
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered)
        return [filteredOpciones count];
    return [opciones count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Opciones *opt = opciones[indexPath.row];
    if (isFiltered) {
        opt = filteredOpciones[indexPath.row];
    }
    self.Key = opt.Key;
    self.Value = opt.Value;
    return indexPath;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString* txtCel = [[NSString alloc] init];
    txtCel = @"CellMiDenuncia";
    MisDenunciasTVCell *cell = [tableView dequeueReusableCellWithIdentifier:txtCel forIndexPath:indexPath];
    if (isFiltered) {
        Opciones *opt = filteredOpciones[indexPath.row];
        cell.lblTitulo.text = opt.Value;
        cell.lblSubtitulo.text = opt.VString1;
    } else {
        Opciones *opt = opciones[indexPath.row];
        cell.lblTitulo.text = opt.Value;
        cell.lblSubtitulo.text = opt.VString1;
    }

    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"FOLIOS ASIGNADOS";
}

-(void)getDataOptions:(NSString *)Url {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.tableView setHidden:YES];
    [self.Indicator setHidden:NO];
    [self.Indicator startAnimating];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: Url]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            NSError *jsonError;
            
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if(!jsonError)
            {
                //NSLog(@"Respode Mis Denuncias %@",responseBody);
                
                self->opciones = [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->Combo = (NSMutableArray *)responseBody;
                    for (int i=0; i<self->Combo.count; i++) {
                        int Key = [ [[self->Combo objectAtIndex:i]objectForKey:@"data"] intValue];
                        int idtipodenuncia = [ [[self->Combo objectAtIndex:i]objectForKey:@"idtipodenuncia"] intValue];
                        NSString *creado_el = [[self->Combo objectAtIndex:i]objectForKey:@"creado_el"];
                        NSString *tipo_denuncia = @"PERSONAL";
                        if (idtipodenuncia == 1) {
                            tipo_denuncia = @"ANÓNIMA";
                        }
                        NSString *Valor = [NSString stringWithFormat:@"Folio UIPE-%d-TAB", Key];
                        NSString *FechaHora = [NSString stringWithFormat:@"%@   %@", creado_el, tipo_denuncia];

                        [self->opciones addObject:[Opciones newDataObject:Key value:Valor VString1:FechaHora VString2:@""]];
                        
                    }
                    [self.Indicator stopAnimating];
                    [self.Indicator setHidden:YES];
                    [self.tableView setHidden:NO];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [self->tableView reloadData];
                    
                });
                
            }else{
                NSLog(@"Error for @DevCH: 102");
            }
            
        }else{
            NSLog(@"Mi Error: %@", error.description);
        }
    }];
    [task resume];
}



- (IBAction)btnRefresh:(id)sender {

    [self getDataOptions:self.Singleton.urlMisDenuncias];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cero Corrupción Tabasco"
                                                                   message:@"Lista Actualizada"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Aceptado");
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Denuncia"]) {
        MiDenunciaVC *mvc = (MiDenunciaVC *) segue.destinationViewController;
        mvc.IdDenuncia = self.Key;
        mvc.Titulo = self.Value;
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



@end
