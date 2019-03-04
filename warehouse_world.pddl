(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
    (:action robotMove
        ;Moves the robot between locations. Requires two locations and the robot.
        :parameters (?l1 - location ?l2 - location ?r - robot)
        :precondition (and (at ?r ?l1) (free ?r) (connected ?l1 ?l2) (no-robot ?l2))
        :effect (and (no-robot ?l1) (at ?r ?l2) (not (at ?r ?l1)))
    )

    (:action robotMoveWithPallette
        ;Move the robot and a palette between locations. Requires two locations, the robot and a pallet.
        :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
        :precondition (and (at ?r ?l1) (at ?p ?l1) (connected ?l1 ?l2) (no-robot ?l2) (no-pallette ?l2))
        :effect (and (no-robot ?l1) (no-pallette ?l1) (at ?r ?l2) (at ?p ?l2) (not (at ?r ?l1)) (not (at ?p ?l1)))
    )

    (:action moveItemFromPalletteToShipment
        ;Move items from a palette to a shipment. Requires a location , a shipment, a saleitem, a palette, and an order.
        :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (ships ?s ?o) (orders ?o ?si) (packing-location ?l) (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si))
        :effect (and (includes ?s ?si) (not (contains ?p ?si)))
    )
   
    (:action completeShipment
        ;Completes the shipment process. Requires a shipment, an order, and a location.
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (ships ?s ?o) (started ?s) (not (complete ?s)) (packing-at ?s ?l))
        :effect (and (complete ?s) (available ?l))
    )

)