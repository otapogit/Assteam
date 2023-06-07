//TEAM_AXIS
threshold_health(30).
threshold_ammo(20).
myinfo([0, []]).
enemies([]).

+flag (F): team(200)
  <-
  +check;
  .wait(50);
  +mbids([]).


+informaposicion[source(A)]
    <-
    ?position(Pos);
    .send(A,tell,backbid(Pos));
    -informaposicion.

+assignext[source(A)]
  <-
  ?flag(F);
    .register_service("externo");
    .create_control_points(F,40,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .get_service("externo");
    .print("soy ext").

+assignjefe[source(A)]
  <-
    ?flag(F);
    .register_service("jefe");
    .create_control_points(F,5,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .get_service("jefe");
    .print("soy jefe").    

+assignres[source(A)]
  <-
    ?flag(F);
    .register_service("reserva");
    .create_control_points(F,5,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .print("soy res");
    .get_service("reserva");
    .get_service("reserva").    

+assignint[source(A)]
  <-
    ?flag(F);
    .register_service("interno");
    .create_control_points(F,25,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .get_service("interno");
    .print("soy int").

+target_reached(T): patrolling 
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+fuerafov: patrolling 
  <-
  ?patroll_point(P);
  -+patroll_point(P-1);
  -fuerafov.


+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).



+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): jefe(J) & not votacion
  <-
  if(not todosaqui){
    +todosaqui;
    .get_backups;
    .print("obamna");
    .wait(300);
    ?myBackups(B);
    .send(B,tell,refuerzo(Position));
    -myBackups(B);
    .wait(2000);
    -todosaqui;
  }
  .shoot(3,Position).
/*
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): reserva(R)
  <-
*/  

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  ?enemies(Enemies);
  .enemyseen(Enemies,ID,Res);
  if(Res == 1){
    .concat(Enemies,[ID],Enemiesn);
    -+enemies(Enemiesn);
    .print("My enemies", Enemiesn);
  .checkfov(info)
  ?myinfo(previnfo)
  .nth(0,info,counter);
  .nth(1,info,aliados);
  .length(aliados, numa)
  .nth(0,previnfo,prevcounter);
  .nth(1,previnfo,prevaliados);
  .length(prevaliados, prevnuma)
  if (counter != prevcounter || numa != prevnuma) {
    -myinfo(_)
    +myinfo(info)
    // uno para uno
    if(counter == 1) {
        ?health(myHealth)
        if(Health >= myHealth) {
            +ayudita
        }
    } 
    if(counter != 1) {
        if ((counter - 1) <= numa) {
            +ayudita
        } 
        if ((counter - 1) > numa && not votacion) {
            +votacion;
            +posmalo(Position);
            .print("esto tiene que saberlo el moha");
            .get_service("jefe");
        }
    }
    // informar aliados
    if(numa != 0) {
        if(ayudita) {
            .send(aliados,tell,refuerzo(Position));
            -ayudita
        } else {
            .send(aliados,tell,fuerafov)
        }  
    }
  }
  .shoot(3,Position).


 //////////////////////// VOTO SOCIAL 
//Dependiendo de quien llama la votacion si es el ataque enemigo o no, se asigna una puntuacion difgerente
+jefe(F):votacion && interno(I)
  <-
  .print("Se pelea en las urnas");
  .send(F,tell,votando(1));
  .wait(20);
  ?posmalo(P);
  .send(F,tell,objectivo(P));
  -jefe(F).

+jefe(F):votacion && reserva(I)
  <-
  .print("Se pelea en las urnas");
  .send(F,tell,votando(2));
  .wait(20);
  ?posmalo(P);
  .send(F,tell,objectivo(P));
  -jefe(F).

+jefe(F):votacion && externo(I)
  <-
  .print("Se pelea en las urnas");
  .send(F,tell,votando(0));
  .wait(20);
  ?posmalo(P);
  .send(F,tell,objectivo(P));
  -jefe(F).

+objectivo(Pos)[source(A)]
  <-
  +posmalo(Pos).

+votando(Tipo)[source(A)]: not votacion
  <-
  //el jefe apunta que ya esta votando para no repetir votacion
    +votacion;
    .get_backups;
    -+votos([]);
    .wait(1000);
    .print("repartiendo votos");
    ?myBackups(B);
    .send(B,tell,votarEnemies(Tipo));
    -myBackups(B);    //basura
    .wait(1000);
    !!resolvervotos.

+votarEnemies(Tipo)[source(A)]: not jefe(F)
  <-
    -+votacion;
    .get_service("jefe");
    if(interno(I)){
      ?enemies(En);
      .votar(Tipo,En,1,Res);
    }
    if(externo(X)){
      ?enemies(En);
      .votar(Tipo,En,0,Res);
    }
    if(reserva(R)){
      ?enemies(En);
      .votar(Tipo,En,2,Res);
    }
    ?jefe(W);
    .send(W,tell,voto(Res)).

+voto(Res)[source(A)]
  <-
    ?votos(V);
    .concat(V,[Res],VV);
    -+votos(VV).

+!resolvervotos
  <-
  ?votos(V);
  .resolvervotos(V,Res);
  .get_backups;
  .wait(25);
  ?myBackups(B);
  if(Res == 1){
    ?posmalo(P);
    .send(B,tell,ataqui(P))
  }else{
    .send(B,tell,endVoto);
  }
  .print("Decidido").

+ataqui(P)[source(A)]
  <-
    .goto(P);
    !endVoto.


+!endVoto
  <-
    .wait(7000);
    -+enemies([]);
    -votacion.

+endVoto[source(A)]
  <-
    .wait(7000);
    -+enemies([]);
    -votacion.


//////////////////////////
/* HAY QUE ARREGLAR ESTE CONTRACT NET QUE DA ERROR
    CREO QUE ES PORQUE MATAN AL SOLDADO MIENTRAS MANDA EL MENSAJE
+health(H): threshold_health(W) & H<W & not pedirvida
    <-
        +pedirvida;
        .get_medics.
*/

+myMedics(M):pedirvida
    <-
        ?position(P);
        +mbids([]);
        +mehdics([]);
        .send(M,tell,pedirvida(P));
        .wait(500);
        !!elegirmedic;
        -myMedics(_).

+mybidm(Pos)[source(A)]: pedirvida
    <-
        .print("Medic en ",Pos);
        ?mbids(B);
        .concat(B,[Pos],B1);
        -+mbids(B1);
        ?mehdics(M);
        .concat(M,[A],M1);
        -+mehdics(M1);
        -mybidm(Pos).

+!elegirmedic:mbids(B) & mehdics(M)
    <-
        //aqui deberiamos hacer un py para elegir el mejor
        ?position(Mypos);
        .selectbest(Mypos,B,I);
        if(I >= 0){
        .nth(I,M,A);
        .delete(I,M,M1);
        .send(A,tell,acceptmedic);
        //borrar A de la lista
        .send(M1,tell,cancelmedic);
        -+mbids([]);
        -+mehdics([]);
        }
        ?position(G).

+!elegirmedic: not(mbids(Bi))
    <-
        -pedirvida.

+refuerzo(Pos)[source(A)]
  <-
    .goto(Pos);
    .print("defiendan a ",A);
    +alataque.

+healIn(Pos)[source(A)]
    <-
    +acurar;
    .goto(Pos).

+reserva(L)
    <-
    ?position(Pos);
    .send(L,tell,ir_a(Pos));
    -reserva(_).

+interno(L)
    <-
    ?position(Pos);
    .send(L,tell,ir_a(Pos));
    -interno(_).

+externo(L)
    <-
    ?position(Pos);
    .send(L,tell,ir_a(Pos));
    -externo(_).

+ir_a(Pos)[source(A)]
    <-
    .goto(Pos).