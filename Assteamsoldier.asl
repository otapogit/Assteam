//TEAM_AXIS
threshold_health(40).
threshold_ammo(20).

+flag (F): team(200)
  <-
  +check;
  .wait(50);
  +bids([]).

/*
+myBackups(B):check
  <-
  ?name(X);
  if(name == "JEFE"){
  +soyjefe;
  .print("soy jefe");
  .wait(50);
  .nth(0,B,Jefe);
  .send(Jefe,tell,assignjefe);
  .nth(1,B,Res1);
  .send(Res1,tell,assignres);
  .nth(2,B,Res2);
  .send(Res2,tell,assignres);
  .nth(3,B,Int1);
  .send(Int1,tell,assignint);
  .nth(4,B,Int2);
  .send(Int2,tell,assignint);
  .nth(5,B,Ext1);
  .send(Ext1,tell,assignext);
  .nth(6,B,Ext2);
  .send(Ext2,tell,assignext);
  }
  .print("mi rol asignado").
  //conseguir lista posiciones
  //.asignaroles(B, bids, F, newB);
*/

+informaposicion[source(A)]
    <-
    ?position(Pos);
    .send(A,tell,mybid(Pos));
    -informaposicion.

+mybid(Pos)[source(A)]
    <-
    ?bids(B);
    .concat(B,[Pos],B1);
    -+bids(B1);
    -mybid(Pos).

+assignext[source(A)]
  <-
  ?flag(F);
    .register_service("externo");
    .create_control_points(F,75,3,C);
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
    .create_control_points(F,75,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .print("soy jefe").    

+assignres[source(A)]
  <-
    ?flag(F);
    .register_service("reserva");
    .create_control_points(F,75,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    .print("soy res").    

+assignint[source(A)]
  <-
    ?flag(F);
    .register_service("interno");
    .create_control_points(F,40,3,C);
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

+asscheck[source(A)]
  <-
  if(not soyjefe){
  +asscheck;
  }
  .print("asscheck").


+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).

  //////////////////////////
+health(H): threshold_health(W) & H<W & not pedirvida
    <-
        +pedirvida;
        .get_medics.

+myMedics(M):pedirvida
    <-
        ?position(p);
        +mbids([]);
        +mehdics([]);
        .send(M,tell,pedirvida(pos));
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
        .nth(index,M,A);
        .delete(index,M,M1);
        .send(A,tell,acceptmedic);
        //borrar A de la lista
        .send(M1,tell,cancelmedic);
        -+mbids([]);
        -+mehdics([]).

+!elegirmedic: not(mbids(Bi))
    <-
        -pedirvida.

+healIn(Pos)[source(A)]
    <-
    +acurar;
    .goto(Pos).