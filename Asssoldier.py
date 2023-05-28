import json
from pygomas.bdisoldier import BDISoldier

class AssSoldier(BDISoldier):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".selectbest",(tuple,list))
        def _selectbest(mypos, listpos):
            if len(listpos) == 0:
                return -1
            bestpos = listpos[0]
            index = 0
            for i, pos in enumerate(listpos):
                if((abs(mypos[0] - pos[0]) + abs(mypos[2] - pos[2])) < (abs(mypos[0] - bestpos[0]) + abs(mypos[2] - bestpos[2]))):
                    bestpos = pos
                    index = i
            return index 

        @actions.add(".checkfov",0)
        def _checkfov(agent, term, intention):
            list = agent.fov_objects #comprobar si solo devuelve objetos o todo lo que este en el fov
            #si devuelve todo, se puede comprobar n�mero de enemigos o si hay un aliado en el fov 
            #sino, tocara hacerlo con el asl 
            #a partir de este m�todo, decidir que hace el soldado:
                # 1. si hay aliados y enemigos, informar aliados de situaci�n (salir del fov! retirarse o atacar)
                # 2. si solo hay enemigos, depende del n�mero decide atacar en solitario, informar a su otro compa�ero, o contactar con el jefe para m�s refuerzos 

