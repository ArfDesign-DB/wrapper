VERILATOR ?= verilator
VERILATOR_FLAGS ?= --binary --timing -sv -Wno-fatal
TB_TOP ?= wrapper_smoke_tb
TB_SRC ?= tb/wrapper_smoke_tb.sv

.PHONY: check smoke clean

check:
	python3 scripts/check_repo.py

smoke:
	$(VERILATOR) $(VERILATOR_FLAGS) -f filelist.f $(TB_SRC) --top-module $(TB_TOP)
	./obj_dir/V$(TB_TOP)

clean:
	rm -rf obj_dir
