turkey_spawner:
  type: world
  debug: false
  events:
    on delta time minutely every:5:
      - if <server.list_online_players.size> > 1:
        - define spawn_locations <server.flag[thanksgiving.turkey_spawn_location]>
        - define unused_spawn_locations <server.flag[thanksgiving.turkey_spawn_location].exclude[<server.flag[thanksgiving.spawned_turkeys]>]>
        - if !<[unused_spawn_locations].is_empty>:
          - define location <[unused_spawn_locations].random>
          - spawn thanksgiving_turkey_armor_stand <[location].center.with_yaw[<util.random.int[0].to[360]>]>
          - flag server thanksgiving.spawned_turkeys:->:<[location]>
      - if !<server.flag[thanksgiving.spawned_turkeys].is_empty>:
        - foreach <server.flag[thanksgiving.spawned_turkeys]> as:spawned_location:
          - playsound sound:ENTITY_CHICKEN_AMBIENT pitch:1.5 volume:10 <[spawned_location]>
          - wait <util.random.int[10].to[20]>t

thanksgiving_turkey_armor_stand:
  type: entity
  entity_type: armor_stand
  debug: false
  mechanisms:
    equipment: air|air|air|thanksgiving_turkey_token
    visible: false
    gravity: true
    is_small: true

turkey_retrieval_event:
  type: world
  debug: false
  events:
    on player right clicks thanksgiving_turkey_armor_stand:
      - determine passively cancelled
      - give thanksgiving_turkey_token
      - flag server thanksgiving.spawned_turkeys:<-:<context.entity.location.block>
      - remove <context.entity>
      - playsound sound:ENTITY_CHICKEN_HURT <player.location> pitch:1.5
