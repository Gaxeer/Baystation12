/obj/item/reagent_containers/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = "x=16;y=9"
	matter = list(MATERIAL_PLASTIC = 280)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = "10;20;30;60;120;150;180"
	volume = 180
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = FALSE

/obj/item/reagent_containers/bucket/wood
	name = "bucket"
	desc = "It's a wooden bucket. How rustic."
	icon_state = "wbucket"
	item_state = "wbucket"
	matter = list(MATERIAL_WOOD = 280)
	volume = 200

/obj/item/reagent_containers/bucket/attackby(var/obj/D, mob/user as mob)
	if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/reagent_containers/bucket/attack_self(mob/user)
	..()
	if(is_open_container())
		to_chat(user, "<span class = 'notice'>You put the lid on \the [src].</span>")
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(user, "<span class = 'notice'>You take the lid off \the [src].</span>")
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/reagent_containers/bucket/on_update_icon()
	overlays.Cut()
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid
		return

	if(reagents.total_volume && round((reagents.total_volume / volume) * 100) > 80)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "bucket")
		filling.color = reagents.get_color()
		overlays += filling
