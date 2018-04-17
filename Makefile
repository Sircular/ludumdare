SOURCES     = src/* lib/ assets/ LICENSE
BUILD_DIR   = build
OUTPUT_FILE = build.love

$(OUTPUT_FILE): $(SOURCES)
	mkdir -p $(BUILD_DIR)
	rm -rf $(BUILD_DIR)/*
	cp -R $(SOURCES) $(BUILD_DIR)/
	cd $(BUILD_DIR) && zip -9 -R $(OUTPUT_FILE) * 
	mv $(BUILD_DIR)/$(OUTPUT_FILE) .

run: $(OUTPUT_FILE)
	love $(OUTPUT_FILE)
