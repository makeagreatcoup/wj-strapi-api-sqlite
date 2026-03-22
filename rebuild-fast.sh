#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}   Strapi 快速部署（仅代码）${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

echo -e "${YELLOW}⚡ 适用于：仅修改代码，未修改依赖${NC}"
echo -e "${YELLOW}⏱️  预计耗时：30秒 - 1分钟${NC}"
echo ""

echo -e "${YELLOW}📊 当前容器状态：${NC}"
docker-compose ps
echo ""

echo -e "${BLUE}🚀 开始快速部署...${NC}"
echo ""

# 1. 重启容器（不重建镜像）
echo -e "${YELLOW}[1/2] 重启容器...${NC}"
docker-compose restart
echo -e "${GREEN}✅ 容器已重启${NC}"
echo ""

# 2. 等待服务就绪
echo -e "${YELLOW}[2/2] 等待服务启动...${NC}"
sleep 5

# 显示状态
echo ""
echo -e "${GREEN}📊 容器状态：${NC}"
docker-compose ps
echo ""

echo -e "${GREEN}✅ 快速部署完成！${NC}"
echo ""
echo "提示：如果修改了 package.json，请使用 ./rebuild.sh"
