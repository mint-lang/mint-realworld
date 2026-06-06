MAKEFLAGS += --no-print-directory

.PHONY: dev
dev:
	@$(MAKE) -j 2 backend frontend

.PHONY: backend
backend:
	@pocketbase serve --http 0.0.0.0:3001

.PHONY: frontend
frontend:
	@mint-dev start
