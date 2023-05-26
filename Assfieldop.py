import json
from pygomas.BDIfieldop import BDIFieldop

class AssFieldop(BDIFieldop):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".asignaroles",(list, list, tuple))
        def _asignaroles(listagentes, listpos, F):
            // sort by de más cercano a la F a más lejano 
            distance = []
            for pos in listpos:
                distance.append((abs(F[0] - pos[0]) + abs(F[2] - pos[2]))
            result = [x for _,x in sorted(zip(distance,listagentes))]
            return result
