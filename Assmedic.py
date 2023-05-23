import json
from pygomas.bditroop import BDITroop

class AssMedic(BDITroop):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".ptomedio",([int],))
        def _ptomedio(pos1,pos2):
            posx = pos1[0]/2+pos2[0]/2
            posz = pos1[2]/2+pos2[2]/2
            if map.can_walk(posx,posz):
                return [posx,0,posz]
            else:
                posx2 = posx
                posz2 = posz
                
                for acc in range (1,100):
                    posx2 = posx + acc
                    if map.can_walk(posx2, posz2):
                        break
                    posx2 = posx - acc
                    if map.can_walk(posx2, posz2):
                        break
                    posx2 = posx
                    posz2 = posz + acc
                    if map.can_walk(posx2, posz2):
                        break
                    posz2 = posz - acc
                    if map.can_walk(posx2, posz2):
                        break
                    posz2 = posz
                return [posx2,0,posz2]

        
        @actions.add_function(".canWalk",(int,))
        def _canWalk(x):
            if map.can_walk(x[0],x[2]):
                return 1
            else:
                return 0