//TEAM_AXIS
threshold_health(100).
threshold_ammo(20).

+flag (F): team(200)
  <-
  +check;
  .wait(50);
  +mbids([]).


+informaposicion[source(A)]
    <-
    ?position(Pos);
    .send(A,tell,mybid(Pos));
    -informaposicion.

+mybid(Pos)[source(A)]
    <-
    ?mbids(B);
    .concat(B,[Pos],B1);
    -+mbids(B1);
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
    .create_control_points(F,10,3,C);
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



+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).

//////////////////////////

+health(H): threshold_health(W) & H<W & not pedirvida
    <-
        .print("mimemamemomimu");
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

+healIn(Pos)[source(A)]
    <-
    +acurar;
    .goto(Pos).