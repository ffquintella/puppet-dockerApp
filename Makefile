.PHONY: build validate test clean deploy help

FORGE_CONFIG := .forge_config

# Default target
help:
	@echo "Available targets:"
	@echo "  make build    - Build the module package"
	@echo "  make validate - Run PDK validation"
	@echo "  make test     - Run PDK unit tests"
	@echo "  make clean    - Remove built packages"
	@echo "  make deploy   - Build and deploy to Puppet Forge"
	@echo "  make help     - Show this help message"

# Run PDK validation
validate:
	pdk validate

# Run PDK unit tests
test:
	pdk test unit

# Build the module package
build: validate
	pdk build --force

# Clean built packages
clean:
	rm -rf pkg/

# Deploy to Puppet Forge
deploy: build
	@SAVED_USER=""; \
	if [ -f "$(FORGE_CONFIG)" ]; then \
		SAVED_USER=$$(cat $(FORGE_CONFIG)); \
	fi; \
	if [ -z "$(FORGE_API_KEY)" ]; then \
		if [ -n "$$SAVED_USER" ]; then \
			read -p "Enter Puppet Forge username [$$SAVED_USER]: " FORGE_USER; \
			if [ -z "$$FORGE_USER" ]; then \
				FORGE_USER="$$SAVED_USER"; \
			fi; \
		else \
			read -p "Enter Puppet Forge username: " FORGE_USER; \
		fi; \
		echo "$$FORGE_USER" > $(FORGE_CONFIG); \
		read -sp "Enter Puppet Forge API key: " FORGE_API_KEY; \
		echo ""; \
		PKG_FILE=$$(ls -t pkg/*.tar.gz | head -1); \
		echo "Uploading $$PKG_FILE to Puppet Forge..."; \
		curl --http1.1 -X POST \
			-H "Authorization: Bearer $$FORGE_API_KEY" \
			-F "file=@$$PKG_FILE" \
			https://forgeapi.puppet.com/v3/releases; \
	else \
		PKG_FILE=$$(ls -t pkg/*.tar.gz | head -1); \
		echo "Uploading $$PKG_FILE to Puppet Forge..."; \
		curl --http1.1 -X POST \
			-H "Authorization: Bearer $(FORGE_API_KEY)" \
			-F "file=@$$PKG_FILE" \
			https://forgeapi.puppet.com/v3/releases; \
	fi
	@echo ""
	@echo "Deploy complete!"
