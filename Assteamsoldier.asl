//TEAM_AXIS
threshold_health(35).
threshold_ammo(90).
myinfo([0, []]).
enemies([]).

+flag (F): team(200)
  <-
  +check;
  .wait(50);
  +mbids([]).

+flag_taken: team(200)
  <-
  .enemybase(Pos);
  .goto(Pos).

+informaposicion[source(A)]
    <-
    ?position(Pos);
    .send(A,tell,backbid(Pos));
    -informaposicion.

+assignext[source(A)]
  <-
  ?flag(F);
    .register_service("externo");
    .create_control_points(F,40,5,C);
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
    .create_control_points(F,5,5,C);
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
    .create_control_points(F,15,5,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .print("soy res");
    .get_service("reserva").    

+assignint[source(A)]
  <-
    ?flag(F);
    .register_service("interno");
    .create_control_points(F,30,3,C);
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
  if(arecargar){
    -arecargar;
  }
  if(aporvida){
    -aporvida;
  }
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
    .wait(500);
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
  }
  .checkfov(Info);
  ?myinfo(Previnfo);
  .nth(0,Info,Counter);
  .nth(1,Info,Aliados);
  .length(Aliados, Numa);
  .nth(0,Previnfo,Prevcounter);
  .nth(1,Previnfo,Prevaliados);
  .length(Prevaliados, Prevnuma);
  
  if(not (Counter == Prevcounter) | not (Numa == Prevnuma)) {
    -myinfo(_);
    +myinfo(Info);
    
    // uno para uno
    if(Counter == 1) {
        ?health(MyHealth);
        if(Health >= MyHealth) {
            +ayudita;
        }
    } //varios enemigos
    if(not(Counter == 1)) {
        if (Counter <= Numa) {
            +ayudita;
        } 
        if (Counter > Numa & not votacion) {
            +votacion;
            +initvoto;
            +posmalo(Position);
            .print("esto tiene que saberlo el moha");
            .get_service("jefe");
    }
    }
    //Si tiene aliados
    if(not(Numa == 0)) {
        if(ayudita) { 
            .send(Aliados,tell,refuerzo(Position));
            -ayudita;
        } else {
            .send(Aliados,tell,fuerafov);
        }  
    }///si no tiene aliados
    if(ayudita){
        -ayudita;
    }
  }
  .shoot(3,Position).


 //////////////////////// VOTO SOCIAL 
//Dependiendo de quien llama la votacion si es el ataque enemigo o no, se asigna una puntuacion diferente
+jefe(F):votacion & initvoto
  <-
  .print("Se pelea en las urnas");
  if(interno(I)){
    .send(F,tell,votando(1));
  }
  if(reserva(R)){
    .send(F,tell,votando(2));
  }
  if(externo(E)){
    .send(F,tell,votando(0));
  }
  .wait(20);
  ?posmalo(P);
  -initvoto;
  .send(F,tell,objectivo(P));
  -jefe(F).


+objectivo(Pos)[source(A)]
  <-
  +posmalo(Pos);
  -objectivo(_).

+votando(Tipo)[source(A)]: not votacion
  <-
  //el jefe apunta que ya esta votando para no repetir votacion
    +votacion;
    .get_backups;
    -+votos([]);
    .wait(3000);
    .print("repartiendo votos");
    ?myBackups(B);
    .send(B,tell,votarEnemies(Tipo));
    -myBackups(B);
    -votando(_);    //basura
    !!resolvervotos.

+votarEnemies(Tipo)[source(A)]: not jefe(F)
  <-
    -+votacion;
    //.get_service("jefe");
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
    //?jefe(W);
    .print("mi voto es mi voz");
    -votarEnemies(_);
    .send(A,tell,voto(Res)).

+voto(Res)[source(A)]
  <-
    ?votos(V);
    .concat(V,Res,Ve);
    .print("voto recibido");
    -voto(_);
    -+votos(Ve).

+!resolvervotos
  <-
  .get_backups;
  .wait(2000);
  .print("recontando");
  ?votos(V);
  .print(V);
  .resolvervotos(V,Res);
  ?posmalo(P);
  ?myBackups(B);
  if(Res == 1){
    .print("atacar en ",P);
    .send(B,tell,ataqui(P))
  }else{
    .send(B,achieve,endVoto);
  }
  -posmalo(_);
  .print("Decidido");
  .wait(1000);
  -+votos([]);
  -votacion.

+ataqui(P)[source(A)]
  <-
    .goto(P);
    -+enemies([]);
    .wait(7000);
    -votacion;
    -ataqui(_).


+!endVoto[source(A)]
  <-
    -+enemies([]);
    .wait(1000);
    -votacion.


//////////////////////////
// HAY QUE ARREGLAR ESTE CONTRACT NET QUE DA ERROR
// CREO QUE ES PORQUE MATAN AL SOLDADO MIENTRAS MANDA EL MENSAJE
+health(H): threshold_health(W) & H<W & not pedirvida
    <-
        +pedirvida;
        .get_medics.


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
    +alataque.

+healIn(Pos)[source(A)]
    <-
    +acurar;
    .goto(Pos).

+rechargein(F)[source(A)]
  <-
    .print("recharge in ",F).

+ammo(A):threshold_ammo(X) & X>A & rechargein(P) & not arecargar
  <-
  +arecargar;
  .goto(P).

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type == 1001 & not aporvida
  <-
    +aporvida;
    .goto(Position).

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): arecargar & Type == 1002
  <-
    .goto(Position).

+ir_a(Pos)[source(A)]
    <-
    .goto(Pos).