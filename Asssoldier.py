import json
from pygomas.bdisoldier import BDISoldier

class AssSoldier(BDISoldier):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".selectbest",(tuple,tuple,))
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

        @actions.add(".checkfov",(tuple))
        def _checkfov(agent, term, intention):
            list = agent.fov_objects 
            aliados = []
            counter = 0
            for x in list:
                if(type(agent) == type(x)): #comprobar que se trate de un agente 
                    if(x.team == 100): #comprobar equipo para diferenciar entre aliado/enemigo
                        counter +=1  #si enemigo 
                    elif(x.team == 200):
                        aliados.append[x] #si aliado
            return tuple((counter, tuple(aliados)))
        
        @actions.add_function(".enemyseen",(tuple,int,))
        def _enemyseen(seen, enemyid):
            if enemyid in seen:
                return 0
            else:
                return 1
            
        @actions.add_function(".votar",(int,tuple,int,))
        def _votar(tipo,enemigos,propio):
            counter = len(enemigos)
            counter += tipo - propio      #penalizar opinion de votacion si el agente es de menor rango
            if(counter < 0):
                return 0
            else:
                return counter
            
        @actions.add_function(".resolvervotos",(tuple,))
        def _resolvervotos(votos):
            counter = 0
            for v in votos:
                counter += v
            if counter > 4:
                return 1
            else:
                return 0
