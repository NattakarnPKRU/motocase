# MOTOCASE

เกมเปิดกล่องสะสมรถมอเตอร์ไซค์ สร้างด้วย Flutter และรองรับการเล่นผ่านเว็บ

## ทดสอบบนเครื่อง

```bash
flutter run -d chrome
```

## เผยแพร่บน GitHub Pages

โปรเจกต์มี GitHub Actions workflow สำหรับ build และ deploy เว็บอัตโนมัติ:

1. สร้าง GitHub repository แล้ว push โปรเจกต์นี้ขึ้น branch `main`
2. ใน repository ไปที่ **Settings > Pages** แล้วเลือก **GitHub Actions** เป็น Build and deployment source
3. push หรือ merge การเปลี่ยนแปลงเข้า `main` เพื่อเริ่ม deploy
4. รอ workflow **Deploy to GitHub Pages** สำเร็จ จากนั้นเปิดลิงก์ที่แสดงใน **Settings > Pages**

workflow จะกำหนด base path ตามชื่อ repository ให้โดยอัตโนมัติ รองรับทั้ง repository site (`username.github.io`) และ project site (`username.github.io/repository/`)

## Build เว็บด้วยตัวเอง

```bash
flutter build web --release --base-href "/ชื่อ-repository/"
```

นำไฟล์ใน `build/web` ไปเผยแพร่บน static web host ได้ โดยเปลี่ยน base href ให้ตรงกับ path ที่ใช้โฮสต์
