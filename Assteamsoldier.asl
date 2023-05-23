//TEAM_AXIS
threshold_health(40).
threshold_ammo(20).

+flag (F): team(200)
  <-
  //supuesto conseguir jefe
  .get_service("jefe");
  ?jefe(A);
  .length(A,L)
  if(L == 0){
    .register_service("jefe");
    +check;
    .wait(10);
    .get_backups;
  }else{
    +toassign;
  }
 
  .print("Got control points").

+myBackups(B):check
  <-
      //delete el jefe de la lista
      //sacar externos
      .send(D2,tell,assignext);
      //sacar interiores
      .send(D4,tell,assignint);
      //sacar salientes
      .send(S,tell,assignsal).

+assignext()[source(A)]
  <-
    if(toassign){
      .register_service("external");
    }
    .create_control_points(F,75,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    -toassign.

+assignint()[source(A)]
  <-
    if(toassign){
      .register_service("internal");
    }
    .create_control_points(F,40,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);
    -toassign.

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




+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).

  //////////////////////////
health(H):threshold_health(W) & H<W & not pedirvida
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
        ?mbids(B)
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