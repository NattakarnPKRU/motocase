# MOTOCASE

เกมเปิดกล่องสะสมรถมอเตอร์ไซค์ สร้างด้วย Flutter และรองรับการเล่นผ่านเว็บ

## ทดสอบบนเครื่อง

```bash
flutter run -d chrome
```

## เผยแพร่บน Netlify

โปรเจกต์ตั้งค่า `netlify.toml` สำหรับ build และ deploy เว็บอัตโนมัติ:

1. เข้าสู่ระบบ [Netlify](https://app.netlify.com/) แล้วเลือก **Add new site > Import an existing project**
2. เชื่อมต่อ GitHub และเลือก repository ของเกม
3. เลือก branch `main` แล้วกด **Deploy site** โดยใช้การตั้งค่าจาก `netlify.toml`
4. เมื่อ deploy สำเร็จ Netlify จะแสดงลิงก์เว็บไซต์สำหรับแชร์ให้ผู้อื่น

Netlify จะ build และ deploy ใหม่อัตโนมัติเมื่อ push การเปลี่ยนแปลงเข้า branch `main` โดย build เว็บไว้ที่ `build/web` และใช้ base path ที่ root ของโดเมน Netlify

## Build เว็บด้วยตัวเอง

```bash
flutter build web --release
```

นำไฟล์ใน `build/web` ไปเผยแพร่บน static web host ได้ โดยตั้ง base href ให้ตรงกับ path ที่ใช้โฮสต์หากไม่ได้ใช้ root ของโดเมน
