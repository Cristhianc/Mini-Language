/*Funcion que retorna un puntero del tipo de dato estructurado simbolo. Esta se encarga
de inicializar la tabla de simbolos, asignando al simbolo que vamos a llamar 'posicion
inicial' el valor NULL.*/
#ifdef _TABLA_SIMBOLO_H_
simbolo* inicTabla() 
{
	return NULL;
};

/*Procedimiento que se encarga de insertar un nuevo simbolo en la tabla de simbolos,
tomando como parametros al simbolo de posicion inicial y el nuevo simbolo a ser 
introducido en la tabla, el cual se le va a asignar un apuntador que referencie a
la direccion en memoria del simbolo de posicion inicial y luego este ultimo apun-
tara a la direccion de memoria del nuevo simbolo que fue insertado.*/
void insertar(simbolo **pos_ini, simbolo *nuevo_sim)
{
	nuevo_sim->sig = (*pos_ini);
	(*pos_ini) = nuevo_sim;
};

/*Funcion que busca un simbolo indicado en la tabla de simbolos y trata de encontrar si
existe en el momento, verificando por medio de un nombre que se le paso a la funcion y compa-
rando con los nombres de cada uno de los simbolos de la tabla hasta que lo encuentre y lo empareje.
Si no logra emparejar nada (no ha sido introducido el simbolo en la tabla todavia) entonces retorna
el puntero a NULL. Y el desplazamiento en la tabla de simbolos (la que en realidad es una lista 
enlazada) lo realiza mediante un simbolo especial que llamaremos 'simbolo de posicion inicial'.
Este se pasa por valor a la funcion para que no altere el contenido del original y asi se pueda
realizar un paseo por la tabla de simbolos tantas veces como se necesite sin tener que volver al
inicio de la tabla.

	-*pos_ini: Simbolo de posicion inicial pasado a la funcion por valor

	-nombre[4]: Nombre que va a ser usado para comparar cada uno de los simbolos en la tabla
				con la intencion de buscar si existe o no el simbolo inidicado mediante este
				arreglo.*/
simbolo* buscar(simbolo *pos_init, char name[4])
{
	while ((pos_init != NULL) && (strcmp(name, pos_init->nombre)))
		pos_init = pos_init->sig;
	return (pos_init);
};
#endif
