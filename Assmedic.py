import json
from pygomas.bditroop import BDITroop

class AssMedic(BDITroop):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".ptomedio",([int],))
        def _ptomedio(listpos):
            if listpos.length % 2 = 0:
                return listpos[(listpos.length/2) - 1]
            else:
                return listpos[(listpos.length - 1)/2]

        
        @actions.add_function(".canWalk",(int,))
        def _canWalk(x):
            if map.can_walk(x[0],x[2]):
                return x
            i = 1
            while(True)
                if map.can_walk(x[0] + i,x[2]):
                    x[0] = x[0] + i
                    return x
                if map.can_walk(x[0] - i,x[2]):
                    x[0] = x[0] - i
                    return x
                if map.can_walk(x[0],x[2] + i):
                    x[2] = x[2] + i
                    return x
                if map.can_walk(x[0],x[2] - i):
                    x[2] = x[2] - i
                    return x
                i++
        
         @actions.add_function(".mascercano",(int,))
         def _mascercano(listpos, mypos):
            bestpos = listpos[0]
            index = 0
            del listpos[0]
            for i, pos in enummerate(listpos):
                if((abs(mypos[0] - pos[0]) + abs(mypos[2] - pos[2])) < (abs(mypos[0] - bestpos[0]) + abs(mypos[2] - bestpos[2]))):
                    bestpos = pos
                    index = i + 1
            return index 
         
         @actions.add_function(".asignaroles",(?,))
         def _asignaroles(listagentes, listpos, F):
            // sort by de más cercano a la F a más lejano 
            distance = []
            for pos in listpos:
                distance.append((abs(F[0] - pos[0]) + abs(F[2] - pos[2]))
            result = [x for _,x in sorted(zip(distance,listagentes))]
            return result

"""
Información disponible desde Python:
✤ Atributos de AbstractAgent:
✤ team : Número que identifica el equipo al que pertenece el agente
✤ services : Lista con los identificadores de servicio que ofrece el agente.
✤ Atributos de BDITroop:
✤ manager : jid del Agente Manager.
✤ service : jid del Agente de Servicios
✤ is_objective_carried : (true/false) indica si lleva la bandera o no
✤ fov_objects : lista de objetos actualmente en el campo de visión del agente
✤ aimed_agent : agente al que actualmente está apuntando (o None)
✤ health : salud actual del agente
✤ ammo : munición actual del agente
✤ is_fighting : indica si el agente está luchando en este momento (True/False)
✤ is_escaping : indica si el agente está escapando en este momento (True/False)

Información disponible desde Python:
✤ Atributos de BDITroop:
✤ Relativas al movimiento:
✤ map
✤ map.can_walk(X, Z) : indica si es pisable la posición (X, 0, Z) (True/False)
✤ map.allied_base.get_init_x() , map.allied_base.get_init_y() , map.allied_base.get_init_z()
✤ map.allied_base.get_end_x() , map.allied_base.get_end_y() , map.allied_base.get_end_z()
✤ map.axis_base.get_init_x() , map.axis_base.get_init_y() , map.axis_base.get_init_z()
✤ map.axis_base.get_end_x() , map.axis_base.get_end_y() , map.axis_base.get_end_z()
✤ velocity_value : velocidad actual del agente
✤ destinations : lista ordenada de los próximos destinos del agente.
✤ movement
✤ movement.velocity.x, movement.velocity.y, movement.velocity.z
✤ movement.heading.x, movement.heading.y, movement.heading.z
✤ movement.destination.x, movement.destination.y, movement.destination.z
✤ movement.position.x, movement.position.y, movement.position.z

Información disponible desde Python:
✤ Atributos de BDITroop:
✤ self.soldiers_count = 0
✤ self.medics_count = 0
✤ self.engineers_count = 0
✤ self.fieldops_count = 0
✤ self.team_count = 0
✤ threshold = Threshold() Limits of some variables (to trigger some events)
✤ threshold.health
✤ threshold.ammo
✤ threshold.aim
✤ threshold.shot
"""