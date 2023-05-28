import json
from pygomas.bdisoldier import BDISoldier

class AssSoldier(BDISoldier):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".selectbest",(list,tuple))
        def _selectbest(listpos, mypos):
            if len(listpos) == 0:
                return -1
            bestpos = listpos[0]
            index = 0
            for i, pos in enumerate(listpos):
                if((abs(mypos[0] - pos[0]) + abs(mypos[2] - pos[2])) < (abs(mypos[0] - bestpos[0]) + abs(mypos[2] - bestpos[2]))):
                    bestpos = pos
                    index = i
            return index 

        

