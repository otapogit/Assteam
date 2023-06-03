import json
from pygomas.bdisoldier import BDISoldier

class AssSoldier(BDISoldier):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".selectbest",(tuple,tuple,int))
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

        @actions.add_function(".checkfov",(tuple))
        def _checkfov(agent, term, intention):
            list = self.fov_objects 
            aliados = []
            counter = 0
            for x in list:
                if(type(self) == type(x)): #comprobar que se trate de un agente 
                    if(x.team == 100): #comprobar equipo para diferenciar entre aliado/enemigo
                        counter++  #si enemigo 
                    elif(x.team == 200):
                        aliados.append[x] #si aliado
            return tuple((counter, tuple(sorted(aliados))))
            #el sorted en aliados puede dar problemas, probar !
                    
            #devuelve todo, se puede comprobar n�mero de enemigos o si hay un aliado en el fov 
            #a partir de este m�todo, decidir que hace el soldado:
                # 1. si hay aliados y enemigos, informar aliados de situaci�n (salir del fov! retirarse o atacar)
                # 2. si solo hay enemigos, depende del n�mero decide atacar en solitario, informar a su otro compa�ero, o contactar con el jefe para m�s refuerzos 

