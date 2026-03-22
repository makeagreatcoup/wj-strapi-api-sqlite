#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}   Strapi 重新部署脚本${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker 未运行，请先启动 Docker${NC}"
    exit 1
fi

# 显示当前容器状态
echo -e "${YELLOW}📊 当前容器状态：${NC}"
docker-compose ps
echo ""

echo -e "${YELLOW}⚠️  即将执行以下操作：${NC}"
echo "  1. 停止并删除旧容器"
echo "  2. 删除旧镜像"
echo "  3. 重新构建镜像"
echo "  4. 启动新容器"
echo ""

echo -e "${BLUE}🚀 开始重新部署...${NC}"
echo ""

# 1. 停止并删除容器
echo -e "${YELLOW}[1/4] 停止并删除旧容器...${NC}"
docker-compose down
echo -e "${GREEN}✅ 容器已删除${NC}"
echo ""

# 2. 删除旧镜像
echo -e "${YELLOW}[2/4] 删除旧镜像...${NC}"
docker-compose rm -f
docker rmi $(docker images | grep wj-strapi-api | awk '{print $3}') 2>/dev/null
echo -e "${GREEN}✅ 镜像已删除${NC}"
echo ""

# 3. 重新构建镜像
echo -e "${YELLOW}[3/4] 重新构建镜像（可能需要几分钟）...${NC}"
docker-compose build --no-cache
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 镜像构建失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 镜像构建成功${NC}"
echo ""

# 4. 启动新容器
echo -e "${YELLOW}[4/4] 启动新容器...${NC}"
docker-compose up -d
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 容器启动失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 容器启动成功${NC}"
echo ""

# 等待服务就绪
echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
sleep 5

# 显示新容器状态
echo ""
echo -e "${GREEN}📊 新容器状态：${NC}"
docker-compose ps
echo ""

# 显示日志（最近20行）
echo -e "${YELLOW}📋 最近日志：${NC}"
docker-compose logs --tail=20 strapi
echo ""

# 检查服务健康状态
echo -e "${YELLOW}🔍 检查服务健康状态...${NC}"
if curl -s http://localhost:1380/api > /dev/null; then
    echo -e "${GREEN}✅ API 服务正常运行${NC}"
else
    echo -e "${YELLOW}⚠️  API 可能还在启动中，请稍后访问${NC}"
fi

echo ""
echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}   ✅ 部署完成！${NC}"
echo -e "${GREEN}=================================${NC}"
echo ""
echo "访问地址："
echo "  API:     http://localhost:1380/api"
echo "  管理后台: http://localhost:1380/admin"
echo ""
echo "常用命令："
echo "  查看日志: docker-compose logs -f strapi"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart"
echo ""
