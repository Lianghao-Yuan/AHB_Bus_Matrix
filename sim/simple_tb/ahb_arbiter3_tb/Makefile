# VCS flags
VCS_FLAGS = -sverilog -full64 +v2k -timescale=1ns/1ns

# Source files
SRC_FILES = ../../ahb_defines.v \
            ../../ahb_arbiter3.v \
            ahb_arbiter3_tb.sv 
                        
# Source directories
INCDIR = +incdir+../..


all:
	vcs $(VCS_FLAGS) $(INCDIR) $(SRC_FILES)


