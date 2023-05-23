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
  }

  .create_control_points(F,25,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control points").


+target_reached(T): patrolling & team(200)
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


//TEAM_ALLIED

+flag (F): team(100)
  <-
    
  .goto(F).

+flag_taken: team(100)
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.

+heading(H): exploring
  <-
  .wait(2000);
  .turn(0.375).

//+heading(H): returning
//  <-
//  .print("returning").

+target_reached(T): team(100)
  <-
  .print("target_reached");
  +exploring;
  .turn(0.375).

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
    .goto(Pos).