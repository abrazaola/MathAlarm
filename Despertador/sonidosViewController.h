//
//  sonidosViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 02/06/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Alarma.h"

@interface sonidosViewController : UITableViewController<AVAudioPlayerDelegate>
{
    NSMutableArray *arraySonidos;
    UINavigationItem *navigationItem;
    
    NSString *sonidoElegido;
    
    NSIndexPath *lastIndexPath;
    
    AVAudioPlayer *audioPlayer;
    
    Alarma *editingAlarma;
}
@property (nonatomic) Alarma *editingAlarma;
@property (nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic) NSMutableArray *arraySonidos;
@property (nonatomic) NSString *sonidoElegido;

@end
