FROM node:22-alpine AS builder

WORKDIR /app

# 의존성 파일 복사
COPY package.json package-lock.json ./

# 의존성 설치
RUN npm ci

# 소스 코드 복사
COPY . .

# 빌드
RUN npm run build

# 프로덕션 이미지
FROM node:22-alpine AS production

WORKDIR /app

# 프로덕션 의존성만 설치
COPY package.json package-lock.json ./
RUN npm ci --only=production

# 빌드 결과물 복사
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
