# VCS flags
VCS_FLAGS = -sverilog -full64 +v2k -timescale=1ns/1ns

# Source files
SRC_FILES = ../../ahb_defines.v \
            ../../ahb_arbiter3.v \
					 	../../ahb_decoder.v \
						../../ahb_mux_m2s.v \
						../../ahb_mux_s2m.v \
						../../ahb_bus_matrix.v \
						../../ahb_default_slave.v \
						../../ahb_dummy_master.v \
						../../ahb_slave.v \
						ahb_top_tb.sv	
                        
# Source directories
INCDIR = +incdir+../..


all:
	vcs $(VCS_FLAGS) $(INCDIR) $(SRC_FILES)


