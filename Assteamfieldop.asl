//TEAM_AXIS

+flag (F): team(200) 
  <-
  .create_control_points(F,5,2,C);
  +control_points(C);
  .length(C,L);
  +bids([]);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  +rechargein(F);
  +check;
  .get_backups.

+flag_taken: team(200)
  <-
  .enemybase(Pos);
  .goto(Pos).

+!reloading
  <-
    .reload;
    .wait(1000);
    !reloading.

+myBackups(B):check
  <-
  +bids([]);
  +backups([]);
  .send(B,tell,informaposicion);
  .wait(20);
  ?flag(F);
  .send(B,tell,rechargein(F));
  .wait(3000);
  ?bids(Bids);
  ?backups(NewB);
  .asignaroles(Bids, F, Index);
  .nth(0,Index,Index0);
  .nth(Index0,NewB,Jefe);
  .send(Jefe,tell,assignjefe);
  .wait(25);
  .nth(1,Index,Index1);
  .nth(Index1,NewB,Res1);
  .send(Res1,tell,assignres);
  .wait(25);
  .nth(2,Index,Index2);
  .nth(Index2,NewB,Res2);
  .send(Res2,tell,assignres);
  .wait(25);
  .nth(3,Index,Index3);
  .nth(Index3,NewB,Int1);
  .send(Int1,tell,assignint);
  .wait(25);
  .nth(4,Index,Index4);
  .nth(Index4,NewB,Int2);
  .send(Int2,tell,assignint);
  .wait(25);
  .nth(5,Index,Index5);
  .nth(Index5,NewB,Ext1);
  .send(Ext1,tell,assignext);
  .wait(25);
  .nth(6,Index,Index6);
  .nth(Index6,NewB,Ext2);
  .send(Ext2,tell,assignext);
  .print("roles asignados").

+backbid(Pos)[source(A)]
    <-
    ?bids(B);
    ?backups(Bu);
    .concat(B,[Pos],B1);
    .concat(Bu,[A],Bu1);
    -+bids(B1);
    -+backups(Bu1);
    -backbid(Pos).

+target_reached(T): patrolling & team(200) 
  <-
  if(not reloader){
    +reloader;
    !reloading;
  }
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



+heading(H): exploring
  <-
  .reload;
  .wait(1000);
  .turn(0.375).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .shoot(3,Position).
