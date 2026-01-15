# Hanzo Gateway - Development Commands

.PHONY: dev start build test health clean deploy up help

# Development server with auto-reload
dev:
	cd gateway && npm run dev

# Production server  
start:
	cd gateway && npm start

# Build Docker image
build:
	docker build -t hanzo-gateway ./gateway

# Test the API
test: health
	@echo "Testing gateway endpoints..."
	@curl -s http://localhost:3001/health | jq .

# Health check
health:
	@echo "Health check..."
	@curl -s http://localhost:3001/health | jq .

# Clean up
clean:
	@echo "Stopping any running servers..."
	@pkill -f "node server.js" || true

# Deploy to DigitalOcean App Platform
deploy:
	@echo "Deploying Gateway to DigitalOcean App Platform..."
	@echo "Make sure to set DIGITALOCEAN_ACCESS_TOKEN in GitHub secrets"
	@git add gateway/ && git commit -m "Deploy gateway" && git push

# Quick start for development
up: clean
	@echo "Starting gateway server..."
	@cd gateway && node server.js &
	@sleep 2
	@make health

# Show usage
help:
	@echo "Hanzo Gateway - Available commands:"
	@echo ""
	@echo "Development:"
	@echo "  make dev      - Start development server with auto-reload"
	@echo "  make start    - Start production server"
	@echo "  make up       - Quick start with health check"
	@echo "  make test     - Run API tests"
	@echo "  make health   - Health check"
	@echo ""
	@echo "Deployment:"
	@echo "  make build    - Build Docker image"
	@echo "  make deploy   - Deploy to DigitalOcean App Platform"
	@echo "  make clean    - Stop running servers"
	@echo ""
	@echo "After deployment, configure these domains in Cloudflare:"
	@echo "  gateway.hanzo.ai -> [DigitalOcean App URL]"
