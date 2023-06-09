import json
from pygomas.bdimedic import BDIMedic

class AssMedic(BDIMedic):
    def add_custom_actions(self,actions):
        super().add_custom_actions(actions)

        @actions.add_function(".ptomedio",(tuple,tuple,))
        def _ptomedio(pos1,pos2):
            return tuple([int((pos1[0]+pos2[0])/2), 0, int((pos1[2]+pos2[2])/2)])

        @actions.add_function(".enemybase",())
        def _enemybase():
            x = int((self.map.allied_base.get_init_x() + self.map.allied_base.get_end_x()) / 2)
            z = int((self.map.allied_base.get_init_z() + self.map.allied_base.get_end_z()) / 2)
            return tuple([x, 0, z])

        @actions.add_function(".canWalk",(tuple, ))
        def _canWalk(x):
            if self.map.can_walk(x[0],x[2]):
                return x
            i = 1
            while(True):
                if self.map.can_walk(x[0] + i,x[2]):
                    aux = (x[0] + i, 0, x[2])
                    return aux
                if self.map.can_walk(x[0] - i,x[2]):
                    aux = (x[0] - i, 0, x[2])
                    return aux
                if self.map.can_walk(x[0],x[2] + i):
                    aux = (x[0], 0, x[2] + i)
                    return aux
                if self.map.can_walk(x[0],x[2] - i):
                    aux = (x[0], 0, x[2] - i)
                    return aux
                i += 1
    
                

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


pygomas manager -j managerass@gtirouter.dsic.upv.es -m map_01 -sj serviceass@gtirouter.dsic.upv.es -np 20
pygomas  run -g pygomas.json



"""