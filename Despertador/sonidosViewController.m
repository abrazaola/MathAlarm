//
//  sonidosViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 02/06/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "sonidosViewController.h"

@interface sonidosViewController ()

@end

@implementation sonidosViewController
@synthesize arraySonidos, sonidoElegido, lastIndexPath, editingAlarma;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        navigationItem=[self navigationItem];
        [navigationItem setTitle:@"Sonidos"];
        
        //Sonido por defecto solo en caso de que no se lo seteen
        if(!sonidoElegido)
        {
            sonidoElegido=@"Piano3";
        }
        
        [[self tableView]setAllowsMultipleSelection:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Creo el array con NSSTrings de los sonidos que tengo
    arraySonidos=[[NSMutableArray alloc]initWithObjects:@"Police",@"Piano1",@"Piano2",@"Piano3",@"Hospital",@"Funky",@"AlarmClock1",@"AlarmClock2",@"AlarmClock3",@"Nuclear",@"Boat", nil];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self tableView]reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@", sonidoElegido);
    //Guardo a la alarma que me han pasado el sonido que se ha quedado en la variable sonidoELegido
    [editingAlarma setSonido:sonidoElegido];
    //Paro la reproduccion en  caso de que aun este sonando.
    [audioPlayer stop];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // El numero de sonidos que existen en el array
    return [arraySonidos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // Pongo el nombre del sonido el la celda pillandolos del array
    [[cell textLabel]setText:[arraySonidos objectAtIndex:[indexPath row]]];
    
    //Si el texto es igual al de el sonidoSeleccionado marcarlo e indica que su indexPath es el antiguo IndexPath para que al pulsar otro se pueda desmarcar.
    if([[[cell textLabel]text]isEqualToString:sonidoElegido])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        lastIndexPath=indexPath;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    //Cojo un puntero a la celda seleccionada
    UITableViewCell *cellSeleccionada=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //Desselecciono con animacion la celda que he tocado
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Cojo un puntero a la celda antigua y le quito el checkmark
    UITableViewCell *celdaAntigua=(UITableViewCell *)[tableView cellForRowAtIndexPath:lastIndexPath];
    [celdaAntigua setAccessoryType:UITableViewCellAccessoryNone];
    
    //Guardo esta posicion como la posicionAnterior para futuras selecciones
    lastIndexPath = indexPath;
    
    //Pongo un checkmark en la celda seleccionada
    [cellSeleccionada setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //Guardo en sonidoElegido el texto de la celda seleccionada.
    sonidoElegido=[[cellSeleccionada textLabel]text];
    
    //Hacer sonar el sonido
    NSString *rutaMusica=[[NSBundle mainBundle]pathForResource:sonidoElegido ofType:@"caf"];
    if(rutaMusica)
    {
        NSURL *urlMusica=[NSURL fileURLWithPath:rutaMusica];
        audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:urlMusica error:nil];
        //Le pongo delegado a mi misma clase y que repita infinitamente
        [audioPlayer setDelegate:self];
        [audioPlayer setNumberOfLoops:1];
        //Reproducir
        [audioPlayer play];
    }
}

@end
