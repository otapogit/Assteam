import json
from pygomas.bdisoldier import BDISoldier

class AssSoldier(BDISoldier):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".nuevaFunction", (int,))
        def _nuevaFunction(x):
            return x * x

        @actions.add_function(".selectbest",(tuple,tuple))
        def _selectbest(mypos,mehdics):
            if len(mehdics) == 0:
                return -1
            if len(mehdics) == 1:
                return 0
            print(mehdics)
            counter = 0
            best = 0
            bestx = None
            bestz = None
            posx = mypos[0]
            posz = mypos[2]
            for mehdic in mehdics:
                
                newx = mehdic[0]
                newz = mehdic[2]
                if bestx is None:
                    bestx = newx
                    bestz = newz
                    best = counter
                elif abs(bestx-posx)+abs(bestz-posz) > abs(newx-posx)+abs(newz-posz):
                    bestx = newx
                    bestz = newz
                    best = counter
                counter += 1
            print(best)
            return best

