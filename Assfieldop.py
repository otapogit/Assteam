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


        #sorter que no se usa
            def sorter(tuplelist:list):
            listd = []
            result = []
            for tuple in tuplelist:
                listd.append(tuple[0])
            for i in range(0,len(listd)):
                for j in range(i,len(listd)):
                    if listd[j] < listd[i]:
                        aux = listd[i]
                        listd[i] = listd[j]
                        listd[j] = aux
            for element in listd:
                for i in range(0,listd):
                    tupla = tuplelist[i]
                    if tupla[0] == element:
                        result.append(tupla[1])
            return list(result)