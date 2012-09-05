//
//  FileHelpers.c
//  Despertador
//
//  Created by Aitor Brazaola on 31/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#include "FileHelpers.h"
NSString *pathInDocumentDirectory(NSString *fileName)
{
    //Obtener la lista de documentos de el sandbox
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Obtener el documento de el directorio a partir de la lista
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    //Devolver el anexo pasado en el nombre del archivo en el directorio
    return [documentDirectory stringByAppendingPathComponent:fileName];

}
