import json
from pygomas.bdifieldop import BDIFieldOp

class AssFieldop(BDIFieldOp):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".asignaroles",(list, list, tuple, list))
        def _asignaroles(listagentes, listpos, F):
            #sort by de m�s cercano a la F a m�s lejano 
            print(listagentes)
            distance = []
            for pos in listpos:
                distance.append(abs(F[0] - pos[0]) + abs(F[2] - pos[2]))
            print(zip(distance,listagentes))
            print(sorted(zip(distance,listagentes)))
            result = []
            for x in sorted(zip(distance,listagentes)):
                result.append(x[1])
            return result


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