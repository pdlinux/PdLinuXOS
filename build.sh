#!/bin/bash
set -e

# رنگ‌ها
YELLOW='\e[1;33m'
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m'

# مقدار پیش‌فرض
# متغیرها
WORK_DIR="work"
OUT_DIR="out"
CONFIG_DIR="kde"
MKARCHISO=""

if [ -d "work" ] || [ -d "out" ]; then
  sudo rm -rf work/ out/
fi
# بررسی نصب بودن پکیج archiso
if pacman -Q archiso >/dev/null 2>&1; then
    echo -e "${GREEN}✅ پکیج 'archiso' نصب شده است.${NC}"
    MKARCHISO="mkarchiso"
elif [ -x "./mkarchiso" ]; then
    echo -e "${YELLOW}⚠️  پکیج 'archiso' نصب نیست، اما فایل محلی 'mkarchiso' یافت شد.${NC}"
    MKARCHISO="./mkarchiso"
else
    echo -e "${RED}❌ mkarchiso پیدا نشد: نه پکیج نصب است، نه فایل محلی وجود دارد.${NC}"
    exit 1
fi

# پاک‌سازی دایرکتوری work اگر وجود داشته باشه
if [ -d "$WORK_DIR" ]; then
    echo -e "${YELLOW}⚠️  Removing '$WORK_DIR/' directory...${NC}"
    sudo rm -rf "$WORK_DIR"
fi

# بررسی وجود configs
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW}❌ Config directory '$CONFIG_DIR' not found.${NC}"
    exit 1
fi

# اکنون MKARCHISO دارای مقدار صحیح است و می‌توان استفاده کرد
echo -e "${GREEN}🚀 استفاده از: $MKARCHISO${NC}"
# اجرای mkarchiso
sudo "$MKARCHISO" -v -w "$WORK_DIR" -o "$OUT_DIR" "$CONFIG_DIR"
