//TEAM_AXIS

+flag (F): team(200) 
  <-
  .create_control_points(F,10,3,C);
  +control_points(C);
  .length(C,L);
  +bids([]);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  +check;
  .get_backups;
  .print("Got control points").

+myBackups(B):check
  <-
  .send(B,tell,informaposicion);
  .wait(2000);
  ?bids(Bids);
  .asignaroles(B, Bids, F, NewB);
  .nth(0,NewB,Jefe);
  .send(Jefe,tell,assignjefe);
  .wait(25);
  .nth(1,NewB,Res1);
  .send(Res1,tell,assignres);
  .wait(25);
  .nth(2,NewB,Res2);
  .send(Res2,tell,assignres);
  .wait(25);
  .nth(3,NewB,Int1);
  .send(Int1,tell,assignint);
  .wait(25);
  .nth(4,NewB,Int2);
  .send(Int2,tell,assignint);
  .wait(25);
  .nth(5,NewB,Ext1);
  .send(Ext1,tell,assignext);
  .wait(25);
  .nth(6,NewB,Ext2);
  .send(Ext2,tell,assignext);
  .print("mi rol asignado").

+backbid(Pos)[source(A)]
    <-
    ?bids(B);
    .concat(B,[Pos],B1);
    -+mbids(B1);
    -backbid(Pos).

+target_reached(T): patrolling & team(200) 
  <-
  .print("AMMOPACK!");
  .reload;
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
  .reload;
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