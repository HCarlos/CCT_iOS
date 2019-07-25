//
//  Singleton.h
//  New Financial Personal for iPad
//
//  Created by DevCH on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Opciones.h"

@interface Singleton : NSObject{
    NSString *pathPList;
    NSMutableDictionary *dataPList;
	BOOL IsDelete;
    NSString *NombreCompletoUsuario;
    NSString *Version;
    
}



@property (nonatomic, retain) NSString *NombreCompletoUsuario;
@property (nonatomic, retain) NSString *Version;
@property (nonatomic, retain) NSString *currentVersion;

@property (nonatomic, retain) NSString *Latitud;
@property (nonatomic, retain) NSString *Longitud;
@property (nonatomic, retain) NSString *Altitud;


// URL's
@property (nonatomic, retain) NSString *urlBase;
@property (nonatomic, retain) NSString *urlLogin;
@property (nonatomic, retain) NSString *urlPagos;
@property (nonatomic, retain) NSURL *urlVideo;
@property (nonatomic, retain) NSURL *urlArchivo;
@property (nonatomic, retain) NSString *urlMediaData;


@property (nonatomic) NSInteger applicationIconBadgeNumber;
@property (nonatomic) NSInteger noIngresos;

@property (nonatomic) BOOL IsDelete;
@property (nonatomic) BOOL IsInit;

@property(nonatomic, retain) NSString    *typeDevice;  // a string unique to each device based on various
@property(nonatomic, retain) NSString    *uniqueIdentifier;  // a string unique to each device based on various
@property(nonatomic, retain) NSUUID *identifierForVendor;

@property(nonatomic,retain) NSString *tokenUser;              // e.g. "My iPhone"
@property(nonatomic,retain) NSString *FCMToken;
@property(nonatomic,retain) NSString *APNSToken;
@property(nonatomic,retain) NSMutableDictionary *dataPList;
@property(nonatomic,retain) NSString *pathPList;
@property(nonatomic,retain) NSMutableDictionary *dataOpciones;
@property(nonatomic,retain) NSString *pathOpciones;

// Init For App UIPE
@property (nonatomic) int IdTarget;

@property (nonatomic, retain) NSString* Valor;
@property (nonatomic, retain) Opciones *objSingleData;

@property (nonatomic, retain) NSString *urlMunicipios;
@property (nonatomic, retain) NSString *urlDependencias;
@property (nonatomic, retain) NSString *urlArea;
@property (nonatomic, retain) NSString *urlMisDenuncias;
@property (nonatomic, retain) NSString *urlMiDenuncia;
@property (nonatomic, retain) NSString *urlArchivosDenuncia;

@property (nonatomic, retain) NSString *urlGuardarDenuncia;

@property (nonatomic, retain) NSString *urlAgregarArchivo;
@property (nonatomic, retain) NSString *urlQuitarArchivo;

@property (nonatomic, retain) NSString *urlAvisoPrivacidad;
@property (nonatomic, retain) NSString *urlAcercaDe;


@property (nonatomic) int IdDenuncia;
@property (nonatomic) int IdTipoDenuncia;
@property (nonatomic) int IdTipoGobierno;
@property (nonatomic) int IdMunicipio;
@property (nonatomic) int IdDependencia;
@property (nonatomic) int IdArea;
@property (nonatomic) int IdArchivo;
@property (nonatomic, retain) NSString *Archivo;
@property (nonatomic, retain) NSString *Apellido_Paterno;
@property (nonatomic, retain) NSString *Apellido_Materno;
@property (nonatomic, retain) NSString *Nombre;
@property (nonatomic, retain) NSString *Correo_Electronico;
@property (nonatomic, retain) NSString *Celular;
@property (nonatomic, retain) NSString *Fecha;
@property (nonatomic, retain) NSString *Hora;
@property (nonatomic, retain) NSString *Lugar_Denuncia;
@property (nonatomic, retain) NSString *Denuncia;
@property (nonatomic, retain) NSString *UIDD;
@property (nonatomic, retain) NSString *Device;





// End For App UIPE

+(Singleton*)sharedMySingleton;

- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validatePhone: (NSString *) candidate;

-(NSString *) getDeviceData:(int )field;

-(NSString*) sha1:(NSString*)input;
-(NSString *)makeUniqueString;

-(int)intInRangeMinimum:(int)min andMaximum:(int)max;
-(double)intInRangeDouble:(double)min andMaximum:(double)max;

-(void)setPlist;
-(void)insertUser:(NSString *) User insertPass:(NSString *) PWD;
-(void)deleteUser;

-(NSString *) getUser;
-(NSString *) getPassword;
-(NSArray*)explodeString:(NSString*)stringToBeExploded WithDelimiter:(NSString*)delimiter;

-(NSInteger) addAccess;
-(NSInteger) getAccess;

-(NSInteger) getBadge;
-(NSInteger) incrementBadge;
-(NSInteger) decrementBadge;

-(void)setTarget:(int)oIdTarget;
-(int)getIdTarget;

-(void)setTipoDenuncia:(int)idtipodenuncia;
-(int)getIdTipoDenuncia;

-(NSString *) getUrlDependencias;
-(NSString *) getUrlAreas;
-(NSString *) getUrlMisDenuncias;
-(NSString *) getUrlMiDenuncia;
-(NSString *) getUrlArchivosDenuncia;

-(void)insertOpciones:(NSMutableArray *) opciones;
-(void)deleteOpciones:(NSString *) key;
-(void)clearAllOpciones;
-(NSMutableArray *) getOpciones;

-(void) removeBadge;



@end
