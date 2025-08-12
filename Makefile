# Makefile - Foundry 部署脚本

# 加载 .env 文件中的环境变量
include .env
export

# 合约部署脚本路径
SCRIPT = script/Counter.s.sol
SOLIDITY_CONTRACT = Counter

# 默认 gas 价格（可选，根据网络调整）
GAS_PRICE_ANVIL = 1000000000
GAS_LIMIT = 5000000

# 检查必要环境变量是否设置
check-env-sepolia:
ifndef PRIVATE_KEY_SEPOLIA
	$(error PRIVATE_KEY_SEPOLIA is not set in .env)
endif
ifndef ETHERSCAN_API_KEY
	$(error ETHERSCAN_API_KEY is not set in .env)
endif

check-env-mainnet:
ifndef PRIVATE_KEY_MAINNET
	$(error PRIVATE_KEY_MAINNET is not set in .env)
endif
ifndef ETHERSCAN_API_KEY
	$(error ETHERSCAN_API_KEY is not set in .env)
endif

# 编译合约
compile:
	forge build

# 1. 部署到本地 Anvil 网络
deploy-anvil: compile
	@echo "🚀 Deploying to Anvil..."
	anvil & # 启动 anvil（建议提前手动启动）
	sleep 2
	forge script $(SCRIPT) \
		--rpc-url anvil \
		--private-key $(PRIVATE_KEY_ANVIL) \
		--broadcast \
		--gas-price $(GAS_PRICE_ANVIL) \
		--gas-limit $(GAS_LIMIT) \
		--slow
	@echo "✅ Deployment to Anvil completed."

# 2. 部署到 Sepolia 测试网
deploy-sepolia: compile check-env-sepolia
	@echo "🚀 Deploying to Sepolia..."
	forge script $(SCRIPT) \
		--rpc-url sepolia \
		--private-key $(PRIVATE_KEY_SEPOLIA) \
		--broadcast \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--verify \
		--gas-limit $(GAS_LIMIT) \
		--slow
	@echo "✅ Deployment to Sepolia completed."

# 3. 部署到 Ethereum 主网
deploy-mainnet: compile check-env-mainnet
	@echo "🔥 Deploying to Ethereum Mainnet... (Double check!)"
	@read -p "Are you sure you want to continue? (y/N): " confirm; \
	if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
		echo "❌ Deployment aborted."; \
		exit 1; \
	fi
	forge script $(SCRIPT) \
		--rpc-url mainnet \
		--private-key $(PRIVATE_KEY_MAINNET) \
		--broadcast \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--verify \
		--gas-limit $(GAS_LIMIT) \
		--slow
	@echo "✅ Deployment to Ethereum Mainnet completed."

# 清理编译产物
clean:
	forge clean

# 查看帮助
help:
	@echo "🎯 Foundry 部署 Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make compile           - 编译合约"
	@echo "  make deploy-anvil      - 部署到本地 Anvil"
	@echo "  make deploy-sepolia    - 部署到 Sepolia 测试网"
	@echo "  make deploy-mainnet    - 部署到 Ethereum 主网（带确认）"
	@echo "  make clean             - 清理编译文件"
	@echo "  make help              - 显示帮助"

.PHONY: compile deploy-anvil deploy-sepolia deploy-mainnet clean help check-env-sepolia check-env-mainnet