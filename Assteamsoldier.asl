//TEAM_AXIS
threshold_health(30).
threshold_ammo(20).
myinfo(0).

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
    .create_control_points(F,50,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
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
    .create_control_points(F,10,3,C);
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
    .create_control_points(F,25,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .print("soy int").

+target_reached(T): patrolling 
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).



+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): jefe(J)
  <-
  if(not todosaqui){
    +todosaqui;
    .get_backups;
    .print("obamna");
    .wait(200);
    ?myBackups(B);
    .send(B,tell,refuerzo(Position));
    -myBackups(B);
    -discardasalto;
    .wait(2000);
    -todosaqui;
  }
  .shoot(3,Position).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
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
    } else {
        if ((counter - 1) <= numa) {
            +ayudita
        } else {
            // mucha ayudita
        }
    }
    // informar aliados
    if(numa != 0) {
        if(ayudita) {
            .send(aliados,tell,refuerzo(Position));
            -ayudita
        } else {
            //.send(aliados,tell,fuera del fov)
        }
    }
  }
  .shoot(3,Position).

  
//////////////////////////

+health(H): threshold_health(W) & H<W & not pedirvida
    <-
        +pedirvida;
        .get_medics.

+myMedics(M):pedirvida
    <-
        .print("AYUDA ME ESTAN MATANDO");
        ?position(P);
        +mbids([]);
        +mehdics([]);
        .send(M,tell,pedirvida(P));
        .wait(500);
        !!elegirmedic;
        -myMedics(_).

+mybidm(Pos)[source(A)]: pedirvida
    <-
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