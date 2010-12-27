all: sr_method make_namelist select_core make-batch make_grouplist init_grouplist convert_grouplist_sr

sr_method: sr_method.c
	gcc -lm -O6 -o sr_method sr_method.c

make_namelist: make_namelist.c
	gcc -lm -O6 -o make_namelist make_namelist.c

select_core: select_core.c
	gcc -lm -O6 -o select_core select_core.c

make-batch: make-batch.c
	gcc -lm -O6 -o make-batch make-batch.c

make_grouplist: make_grouplist.c
	gcc -lm -O6 -o make_grouplist make_grouplist.c

init_grouplist: init_grouplist.c
	gcc -lm -O6 -o init_grouplist init_grouplist.c

convert_grouplist_sr: convert_grouplist_sr.c
	gcc -lm -O6 -o convert_grouplist_sr convert_grouplist_sr.c


clean:
	@rm -rf *.exe *.o *~
