import json
from pygomas.bdifieldop import BDIFieldOp

class AssFieldop(BDIFieldOp):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)
        #comment
        @actions.add_function(".asignaroles",(tuple, tuple,))
        def _asignaroles(listpos, F):
            #sort by de m�s cercano a la F a m�s lejano 

            distance = []
            for pos in listpos:
                distance.append(abs(F[0] - pos[0]) + abs(F[2] - pos[2]))
            indexed = [(i,j) for (j,i) in enumerate(distance)]
            result = [x for _,x in sorted(indexed)]
            return tuple(result)

        @actions.add_function(".enemybase",())
        def _enemybase():
            x = int((self.map.allied_base.get_init_x() + self.map.allied_base.get_end_x()) / 2)
            z = int((self.map.allied_base.get_init_z() + self.map.allied_base.get_end_z()) / 2)
            return tuple([x, 0, z])