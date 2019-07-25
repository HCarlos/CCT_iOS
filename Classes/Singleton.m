//
//  Singleton.m
//  New Financial Personal for iPad
//
//  Created by DevCH on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import <CommonCrypto/CommonDigest.h>
#import "Opciones.h"


@implementation Singleton

@synthesize uniqueIdentifier, UIDD, Device, Latitud, Longitud, Altitud;
@synthesize pathPList, dataPList, IsDelete, dataOpciones, pathOpciones;
@synthesize NombreCompletoUsuario, Valor, noIngresos;
@synthesize tokenUser, typeDevice, Version, currentVersion, FCMToken, APNSToken, IdTarget;
@synthesize applicationIconBadgeNumber, IsInit;
@synthesize urlBase, urlLogin, urlPagos, urlMunicipios, urlDependencias, urlAvisoPrivacidad, urlAcercaDe, urlVideo;
@synthesize IdDenuncia, IdTipoDenuncia, IdTipoGobierno, IdMunicipio, IdDependencia, IdArea, urlGuardarDenuncia;
@synthesize Apellido_Paterno, Apellido_Materno, Nombre, Correo_Electronico, Celular, Fecha, Hora, Lugar_Denuncia,
Denuncia, urlMisDenuncias, urlMiDenuncia, urlArea, urlArchivosDenuncia, urlAgregarArchivo, IdArchivo, urlQuitarArchivo, Archivo, urlMediaData, urlArchivo;




static Singleton* _sharedMySingleton = nil;
//extern NSString* CTSettingCopyMyPhoneNumber();

+(Singleton*)sharedMySingleton
{
    
    
	@synchronized([Singleton class])
    {
        if (!_sharedMySingleton)
            _sharedMySingleton = [[self alloc] init];
        
        return _sharedMySingleton;
    }
    
    return nil;
}

+(id)alloc
{
	@synchronized([Singleton class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        
        
		
        NSString * version = nil;
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version) {
            version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        }
        
        self.IdTarget = 0;
        self.IdArchivo = 0;
        self.IdDenuncia = 0;
        self.IdTipoDenuncia = 0; // 0 = Normal, 1 = Anónima
        self.IdTipoGobierno = 0; // 0 = Gobierno Estatal, 1 = Gobierno Municipal
        self.IdMunicipio = 0;
        self.IdDependencia = 0;
        self.IdArea = 0;
        self.Archivo = @"";
        self.Apellido_Paterno = @"";
        self.Apellido_Materno = @"";
        self.Nombre = @"";
        self.Correo_Electronico = @"";
        self.Celular = @"";
        self.Fecha = @"";
        self.Hora = @"";
        self.Lugar_Denuncia = @"";
        self.Denuncia = @"";
        self.UIDD = @"";
        self.Device = @"";
        self.Latitud = @"";
        self.Longitud = @"";
        self.Altitud = @"";
        self.IsInit = YES;

        self.Version = version;
        self.currentVersion = version;
        self.noIngresos = 0;
        self.Valor = @"none";
        self.urlBase = @"https://uipeapp01.uipe.tabascoweb.com/";
        self.urlLogin = [NSString stringWithFormat:@"%@%@", self.urlBase, @"getLoginUserMobile/"];
        self.urlPagos = [NSString stringWithFormat:@"%@%@", self.urlBase, @"php/01/mobile/pagos_layout.php?idedocta=%d&user=%@&iduser=%d@&idconcepto=%ld"];
        self.urlAvisoPrivacidad = [NSString stringWithFormat:@"%@%@", self.urlBase, @"avisodeprivacidad/"];
        self.urlAcercaDe = [NSString stringWithFormat:@"%@%@", self.urlBase, @"acercade/"];
        self.urlVideo = [NSURL URLWithString:@""];
        self.urlArchivo = [NSURL URLWithString:@""];
        

        self.urlMediaData = [NSString stringWithFormat:@"%@up_control_images/", self.urlBase];

        self.urlMunicipios = [NSString stringWithFormat:@"%@%@", self.urlBase, @"getMunicipios/1/"];
        
        self.urlGuardarDenuncia = [NSString stringWithFormat:@"%@%@", self.urlBase, @"setDenuncia/"];

        self.urlAgregarArchivo = [NSString stringWithFormat:@"%@%@", self.urlBase, @"setAddArchivo/"];
        self.urlQuitarArchivo = [NSString stringWithFormat:@"%@%@", self.urlBase, @"setRemoveArchivo/"];

        self.urlMisDenuncias = [NSString stringWithFormat:@"%@%@%@/", self.urlBase, @"getMiDenuncia/",self.uniqueIdentifier];

        self.urlMiDenuncia = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getDenuncia/",self.IdDenuncia];

        self.urlArchivosDenuncia = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getDenunciaArchivos/",self.IdDenuncia];


	}
	
	return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized([Singleton class]) {
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton= [super allocWithZone:zone];
		return _sharedMySingleton; // assignment and return on first allocation
	}
	return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (void)dealloc {
}

-(NSString *) getDeviceData:(int )field{
    
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
    if (!UUID) {
        NSString *newUUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:newUUID forKey:@"deviceID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return UUID;
}

-(NSString *) phoneNumber {
 
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    
	if (phone  == NULL){
		phone = @"iOS8";
	}
    NSLog(@"Phone Number: %@", phone);

    return phone;
}


-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(NSUInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

-(void)setPlist{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0){
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.pathOpciones = [documentsDirectory stringByAppendingPathComponent:@"Opciones.plist"];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.pathOpciones];
        if (fileExists){
            NSLog(@"Fichero encontrado en directorio de documentos OK: %@!",self.pathOpciones);
            self.dataOpciones = [[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOpciones];
        } else {
                NSLog(@"No se encuentra el fichero configUsuario.plist en el directorio de documentos->Lo creamos.");
              NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
              self.pathOpciones = [mainBundlePath stringByAppendingPathComponent:@"Opciones.plist"];
              self.dataOpciones = [[NSMutableDictionary alloc] initWithContentsOfFile:self.pathOpciones];
              [self.dataOpciones writeToFile:self.pathOpciones atomically:YES];
              NSLog(@"plist de configUsuario creado!");
        }
    }
}




-(void)insertUser:(NSString *) User insertPass:(NSString *) PWD{
    ///// INSERTAR ////////
    
    //To insert the data into the plist
    NSString *Usr = User;
    NSString *Pwd = PWD;
    [dataPList setObject:[NSString stringWithString:Usr] forKey:@"username"];
    [dataPList setObject:[NSString stringWithString:Pwd] forKey:@"password"];

    [dataPList writeToFile: pathPList atomically:YES];
    //[data release];
    
}

-(void)deleteUser{

    [dataPList removeObjectForKey:@"username"];
    [dataPList writeToFile:pathPList atomically:YES];

    [dataPList removeObjectForKey:@"password"];
    [dataPList writeToFile:pathPList atomically:YES];
    
}



-(NSString *) getUser{
    
    
    //To reterive the data from the plist
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSString *value1;
    value1 = [savedStock objectForKey:@"username"] ;
    return value1;

}

-(NSString *) getPassword{
    
    
    //To reterive the data from the plist
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSString *value1;
    value1 = [savedStock objectForKey:@"password"] ;
    return value1;
    
}


-(NSInteger) incrementBadge{
    NSInteger valret = [self getBadge] + 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"badge"];
    [dataPList writeToFile: pathPList atomically:YES];
    return valret;
}

-(NSInteger) decrementBadge{
    NSInteger valret = [self getBadge] - 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"badge"];
    [dataPList writeToFile: pathPList atomically:YES];
    return valret;
}

-(NSInteger) getBadge{
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSInteger badge = [[savedStock objectForKey:@"badge"] integerValue] ;
    return badge;
    
}

-(void)removeBadge{
    
    [dataPList removeObjectForKey:@"badge"];
    [dataPList writeToFile:pathPList atomically:YES];
    
}


-(NSInteger) addAccess{
    
    NSInteger valret = [self getAccess] + 1;
    [dataPList setObject:[NSNumber numberWithInteger:valret] forKey:@"numero_de_ingresos"];
    [dataPList writeToFile: pathPList atomically:YES];
    self.noIngresos = valret;
    return valret;
    
}

-(NSInteger) getAccess{
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPList];
    NSInteger _noIngresos = [[savedStock objectForKey:@"numero_de_ingresos"] integerValue];
    self.noIngresos = _noIngresos;
    return noIngresos;
    
}

-(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validatePhone: (NSString *) candidate {
    NSString *phoneRegex = @"^+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];
}

-(NSArray*)explodeString:(NSString*)stringToBeExploded WithDelimiter:(NSString*)delimiter
{
    return [stringToBeExploded componentsSeparatedByString: delimiter];
}

-(NSString *)makeUniqueString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //[dateFormatter release];
    int randomValue = arc4random() % 100000;
    NSString *unique = [NSString stringWithFormat:@"%@h%d",dateString,randomValue];
    return unique;
}

-(int)intInRangeMinimum:(int)min andMaximum:(int)max {
    if (min > max) { return -1; }
    int adjustedMax = (max + 1) - min; // arc4random returns within the set {min, (max - 1)}
    int random = arc4random() % adjustedMax;
    int result = random + min;
    return result;
}
-(double)intInRangeDouble:(double)min andMaximum:(double)max {
    return (double)rand()/RAND_MAX * (max - min) + min;
}


-(void)insertOpciones:(NSMutableArray *) opciones{
    //NSMutableDictionary *dataOp = [[NSMutableDictionary alloc] initWithContentsOfFile: pathOpciones];
    int i = 0;
    for (Opciones *optc in opciones) {
        Opciones *opt =  optc;
        NSString *strKey = [NSString stringWithFormat:@"%d",i];
//        NSLog(@"Insertanto : %@",opt.Value);
        [self.dataOpciones setObject:[Opciones newDataObjectMedia:opt.Key value:opt.Value VString1:opt.VString1 Imagen:opt.Imagen Data:opt.Data ] forKey:strKey];
        i++;
    }
    [self.dataOpciones writeToFile: self.pathOpciones atomically:YES];

}

-(void)deleteOpciones:(NSString *) key{
    [self.dataOpciones removeObjectForKey:key];
    [self.dataOpciones writeToFile:self.pathOpciones atomically:YES];
}

-(void)clearAllOpciones{
    [[NSFileManager defaultManager] removeItemAtPath:self.pathOpciones error:NULL];
}

-(NSMutableArray *) getOpciones{
    //NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: self.pathOpciones];
    NSMutableArray *array = [NSMutableArray array];
    
    for(int i=0; i < [self.dataOpciones count]; i++){
         NSString *strKey = [NSString stringWithFormat:@"%d",i];
        Opciones *opt = (Opciones *) [self.dataOpciones objectForKey:strKey];
//        NSLog(@"NSMUTABLE ARRAY IN SINGLETON Value : %@",opt.Value);
        [array addObject:[Opciones newDataObjectMedia:opt.Key value:opt.Value VString1:opt.VString1 Imagen:opt.Imagen Data:opt.Data ]];
    }
    
//    NSLog(@"NSMUTABLE ARRAY IN SINGLETON : %@",array);
    return array;
    
}

-(void)setTarget:(int)oIdTarget{
    self.IdTarget = oIdTarget;
}

-(int)getIdTarget{
    return self.IdTarget;
}

-(NSString *) getUrlDependencias{
    return self.urlDependencias = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getDependencias/",self.IdTipoGobierno];
}

-(NSString *) getUrlAreas{
    return self.urlArea = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getAreas/",self.IdDependencia];
}

-(void)setTipoDenuncia:(int)idtipodenuncia{
    self.IdTipoDenuncia = idtipodenuncia;
}

-(int)getIdTipoDenuncia{
    return self.IdTipoDenuncia;
}

-(NSString *) getUrlMisDenuncias{
    self.UIDD = self.uniqueIdentifier;
    return self.urlMisDenuncias = [NSString stringWithFormat:@"%@%@%@/", self.urlBase, @"getMisDenuncias/",self.UIDD];
}

-(NSString *) getUrlMiDenuncia{
    return self.urlMiDenuncia = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getDenuncia/",self.IdDenuncia];
}
-(NSString *) getUrlArchivosDenuncia{
    return self.urlArchivosDenuncia = [NSString stringWithFormat:@"%@%@%d/", self.urlBase, @"getDenunciaArchivos/",self.IdDenuncia];
}


@end
