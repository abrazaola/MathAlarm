//
//  AppDelegate.m
//  Despertador
//
//  Created by Aitor Brazaola on 12/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "AppDelegate.h"
#import "horaViewController.h"
#import "listaAlarmasViewController.h"
#import "FileHelpers.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate

@synthesize window = _window, arrayAlarmas;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //Configuro mi audioSession para que la app suene en segundo plano
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
        
    #pragma mark - Recuperacion de datos de el archivo
    //Obtener la ruta completa de el archivo alarmas
    NSString *rutaAlarmas=[self rutaArrayAlarmas];
    
    //Desarchivarlo en el array
    arrayAlarmas=[NSKeyedUnarchiver unarchiveObjectWithFile:rutaAlarmas];
    
    //Si el archivo no existe que se cree un array
    if(!arrayAlarmas)
    {
        arrayAlarmas=[NSMutableArray array];
        NSLog(@"Nuevo array creado");
    }
    
    #pragma mark - Creacion de la jerarquia de controladores de vistas
    [_window setRootViewController:tbC];
    
    //Inicio los VC que van a ocupar las tabs anidados en futuros navigations
    horaVC=[[HoraViewController alloc]init];
    alarmasVC=[[listaAlarmasViewController alloc]init];
    
    //Le paso el array de el archivo a el VC de la lista de alarmas
    [alarmasVC setArrayAlarmas:arrayAlarmas];
    
    //Pongo titulo e imagan a las tabs
    //Tab reloj
    tabBarItemReloj=[[UITabBarItem alloc]init];
    [tabBarItemReloj setTitle:NSLocalizedString(@"Reloj", @"RelojTabBar")];
    [tabBarItemReloj setImage:[UIImage imageNamed:@"11-clock"]];
    
    //Tab alarma
    tabBarItemAlarmas=[[UITabBarItem alloc]init];
    [tabBarItemAlarmas setTitle:NSLocalizedString(@"Alarmas", @"AlarmasTabbar")];
    [tabBarItemAlarmas setImage:[UIImage imageNamed:@"78-stopwatch"]];
    
    //Anido el VC de la hora en un navigationController
    navigationHora=[[UINavigationController alloc]initWithRootViewController:horaVC];
    [navigationHora setTabBarItem:tabBarItemReloj];
    [[navigationHora navigationBar]setHidden:YES];
    
    //Anido el VC de la lista en un navigationController
    navigationAlarmas=[[UINavigationController alloc]initWithRootViewController:alarmasVC];
    [navigationAlarmas setTabBarItem:tabBarItemAlarmas];
    [[navigationAlarmas navigationBar]setBarStyle:UIBarStyleBlack];
    
    //Creo el array de VC con los dos creados antes
    NSArray *arrayVistas=[[NSArray alloc]initWithObjects:navigationHora, navigationAlarmas, nil];
    
    //Inicio el tabbarController y le pasi el array creado
    tbC=[[UITabBarController alloc]init];
    [tbC setViewControllers:arrayVistas animated:YES];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    [_window setRootViewController:tbC];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self guardarAlarmas];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self guardarAlarmas];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self guardarAlarmas];
}

#pragma mark - Metodos de la clase

-(NSString *)rutaArrayAlarmas
{
    return pathInDocumentDirectory(@"alarmas.data");
}
-(void)guardarAlarmas
{
    //Obtener la ruta completa de el archivo de alarmas
    NSString *rutaAlarmas=[self rutaArrayAlarmas];
    
    //Obtener la lista de alarmas
    arrayAlarmas=[alarmasVC arrayAlarmas];
    //    NSMutableArray *arrayAlarmas=[alarmasVC arrayAlarmas];

    
    //Archivar la lista de alarmas
    [NSKeyedArchiver archiveRootObject:arrayAlarmas toFile:rutaAlarmas];
}

@end
