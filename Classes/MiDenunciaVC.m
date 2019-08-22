//
//  MiDenunciaVC.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/13/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "MiDenunciaVC.h"
#import "Opciones.h"
#import "Singleton.h"
#import "MisDenunciasTVCell.h"
#import "ArchivosCVC.h"

@interface MiDenunciaVC ()

@end

@implementation MiDenunciaVC{
    NSMutableArray *Combo;
    NSArray *Celdas;
}
@synthesize IdDenuncia, tableView, collectionView, opciones, Titulo;
//@synthesize lbl1, lbl2, lbl3, lbl4;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
}

- (void)customSetup
{
    self->Celdas = [NSArray arrayWithObjects:@"cellUno",@"cellDos",@"cellTres",@"cellCuatro",@"cellCinco",@"cellSeis",@"cellSiete",@"cellOcho",@"cellNueve",@"cellDiez",@"cellOnce",@"cellDoce",@"cellTrece",nil];
    
    self.title = self.Titulo;
    
    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];
    
    self.Singleton.IdDenuncia = self.IdDenuncia;
    [self.Singleton getUrlMiDenuncia];
    
    [self.Singleton getUrlArchivosDenuncia];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getDataOptions:self.Singleton.urlMiDenuncia];
    

    
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString* txtCel = @""; //[[NSString alloc] init];
    txtCel = self->Celdas[indexPath.row];
    MisDenunciasTVCell *cell = [tableView dequeueReusableCellWithIdentifier:txtCel forIndexPath:indexPath];
    
    Opciones *opt = opciones[indexPath.row];
    
    if ([txtCel isEqualToString:@"cellDoce"] || [txtCel isEqualToString:@"cellTrece"]){
        cell.lblTitulo2.text = opt.Value;
        cell.lblTitulo2.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    }else{
        cell.lblTitulo.text = opt.Value;
        [cell.lblTitulo sizeToFit];
    }
    
    
    



    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.opciones count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 60.0;

    NSInteger row = indexPath.row;
    NSInteger sec = indexPath.section;
    Opciones *opt = self.opciones[row];
    if (sec == 0 && (row >= 1 && row <= 3) ){
        height = 44.0;
    }
    
    if (sec == 0 && opt.Key == -1000){
        height = 0.0;
    }

    if (sec == 0 && opt.Key == -2000){
        height = 120.0;

    }

    if (sec == 0 && opt.Key == -3000){
        height = 500.0;
    }

    return height;

}






-(void)getDataOptions:(NSString *)Url {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
                NSLog(@"Respode Mis Denuncias %@",responseBody);
                
                self.opciones = [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getDatos:responseBody];
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


-(void)getDatos:(NSDictionary *)responseBody{

    self->Combo = (NSMutableArray *)responseBody;
    int idmunicipio = [ [[self->Combo objectAtIndex:0]objectForKey:@"idmunicipio"] intValue];
    int idtipodenuncia = [ [[self->Combo objectAtIndex:0]objectForKey:@"idtipodenuncia"] intValue];
    
    int Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idtipogobierno"] intValue];
    NSString *Value = [[self->Combo objectAtIndex:0]objectForKey:@"tipo_gobierno"];
    [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
    
    if (idmunicipio > 0){
        
        Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idmunicipio"] intValue];
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"municipio"];
        [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
        
        Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"iddependencia"] intValue];
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"dependencia"];
        [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
        
        Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idarea"] intValue];
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"area"];
        [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
        
        
    }else{
        
        Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"iddependencia"] intValue];
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"dependencia"];
        [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
        
        Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idarea"] intValue];
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"area"];
        [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
        
        [self.opciones addObject:[Opciones newDataObject:-1000 value:@""]];
        
    }
    
    
    Value = [[self->Combo objectAtIndex:0]objectForKey:@"creado_el"];
    [self.opciones addObject:[Opciones newDataObject:2000 value:Value]];
    
    NSString *Fecha = [[self->Combo objectAtIndex:0]objectForKey:@"fecha"];
    NSString *Hora = [[self->Combo objectAtIndex:0]objectForKey:@"hora"];
    Value = [NSString stringWithFormat:@"%@ %@",Fecha, Hora];
    [self.opciones addObject:[Opciones newDataObject:1000 value:Value]];
    
    Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idstatus"] intValue];
    Value = [[self->Combo objectAtIndex:0]objectForKey:@"estatus"];
    [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
    
    Key = [ [[self->Combo objectAtIndex:0]objectForKey:@"idtipodenuncia"] intValue];
    Value = Key == 0 ? @"PERSONAL" : @"ANÓNIMA";
    [self.opciones addObject:[Opciones newDataObject:Key value:Value]];
    
    if (idtipodenuncia == 0) {
        
        NSString *app = [[self->Combo objectAtIndex:0]objectForKey:@"apellido_paterno"];
        NSString *apm = [[self->Combo objectAtIndex:0]objectForKey:@"apellido_materno"];
        NSString *nom = [[self->Combo objectAtIndex:0]objectForKey:@"nombre"];
        Value = [NSString stringWithFormat:@"%@ %@ %@",app, apm, nom];
        [self.opciones addObject:[Opciones newDataObject:1001 value:Value]];
        
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"correo_electronico"];
        [self.opciones addObject:[Opciones newDataObject:1002 value:Value]];
        
        Value = [[self->Combo objectAtIndex:0]objectForKey:@"celular"];
        [self.opciones addObject:[Opciones newDataObject:1003 value:Value]];
        
    }else{
        [self.opciones addObject:[Opciones newDataObject:-1000 value:@""]];
        [self.opciones addObject:[Opciones newDataObject:-1000 value:@""]];
        [self.opciones addObject:[Opciones newDataObject:-1000 value:@""]];
    }
    
    Value = [[self->Combo objectAtIndex:0]objectForKey:@"lugar_denuncia"];
    [self.opciones addObject:[Opciones newDataObject:-2000 value:Value]];
    
    Value = [[self->Combo objectAtIndex:0]objectForKey:@"denuncia"];
    [self.opciones addObject:[Opciones newDataObject:-3000 value:Value]];
    
    [self.Indicator stopAnimating];
    [self.Indicator setHidden:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.tableView reloadData];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"denunciaArchivosSegue"]) {
        ArchivosCVC *mvc = (ArchivosCVC *) segue.destinationViewController;
        mvc.IdDenuncia = self.IdDenuncia;
    }
}


@end
