
# == Directories
SRC_DIR   := src
BUILD_DIR := build
TEST_DIR  := tests
ISA_DIR   := $(TEST_DIR)/isa
UNITS_DIR := $(TEST_DIR)/units
# ==

# == Files
UNIT_SRC   := $(shell find $(UNITS_DIR) -type f -name '*.cpp')
UNIT_TESTS := $(patsubst $(UNITS_DIR)/%.cpp, $(BUILD_DIR)/V%, $(UNIT_SRC))
ISA_SRC    := $(shell find $(ISA_DIR) -type f -name '*.S')
ISA_TESTS  := $(patsubst $(ISA_DIR)/%.S, $(ISA_DIR)/build/%.bin, $(ISA_SRC))
# ==

# == Runing goals
RUNTESTS  := $(addprefix RUNTEST.,$(UNIT_TESTS) $(ISA_TESTS))
# ==

# == Verilator config
VERILATOR := verilator
VERIFLAGS := $(addprefix -I,$(shell find $(SRC_DIR) -type d)) -Wall -Mdir $(BUILD_DIR)
# ==

.SILENT:
.SECONDARY:
.SECONDEXPANSION:
.PHONY: test build-tests RUNTEST.$(BIN)/%

test: $(RUNTESTS)

$(BUILD_DIR)/V%: $(SRC_DIR)/units/%.v $(UNITS_DIR)/%.cpp | $$(dir $$@)
	@echo Building $@
	$(VERILATOR) $(VERIFLAGS) --cc --exe --build $^

%/:
	mkdir -p $@

$(ITEST)/build/%.bin: $(ITEST)/build/%.bin
	$(MAKE) -C tests/isa

RUNTEST.$(BUILD_DIR)/%: $(BUILD_DIR)/%
	@echo "Running test $(notdir $<)"
	$<

