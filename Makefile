MAKEFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

run:
	processing-java --force --sketch=$(MAKEFILE_DIR)/ --output=$(MAKEFILE_DIR)/output --run
