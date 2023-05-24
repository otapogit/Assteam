//TEAM_AXIS
threshold_health(40).
threshold_ammo(20).

+flag (F): team(200)
  <-

+myBackups(B):check
  <-
  //conseguir lista posiciones
  .asignaroles(B, bids?, F, newB)
  .nth(0,newB,jefe);
  .send(jefe,tell,assignjefe);
  .nth(1,newB,res1);
  .send(res1,tell,assignres);
  .nth(2,newB,res2);
  .send(res2,tell,assignres);
  .nth(3,newB,int1);
  .send(int1,tell,assignint);
  .nth(4,newB,int2);
  .send(int2,tell,assignint);
  .nth(5,newB,ext1);
  .send(ext1,tell,assignext);
  .nth(6,newB,ext2);
  .send(ext2,tell,assignext);
      

+assignext()[source(A)]
  <-
    .register_service("external");
    .create_control_points(F,75,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);

+assignint()[source(A)]
  <-
    .register_service("internal");
    .create_control_points(F,40,3,C);
    +control_points(C);
    .length(C,L);
    +total_control_points(L);
    +patrolling;
    +patroll_point(0);

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