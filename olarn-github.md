โอเค นี่คือ **สรุปทั้งหมดเกี่ยวกับ “การสอบ INT142 Software Development Tools” แบบครบ + เอาไปอ่านสอบได้เลย**

---

# 🎯 ภาพรวมการสอบ

* การสอบมี **2 ส่วน**

  * 🧠 ทฤษฎี (Theory)
  * 💻 ปฏิบัติ (Practical)

* น้ำหนักคะแนน
  👉 **Exam = 65% ของเกรด (Choices + Practical)** 

---

# 🧠 ส่วนที่ 1 : ทฤษฎี (Theory)

เน้น **ความเข้าใจ concept + ความหมาย + เปรียบเทียบ + workflow**

## 1️⃣ Version Control Systems (VCS)

ต้องรู้

* Version control คืออะไร
  → ระบบบันทึกการเปลี่ยนแปลงไฟล์ย้อนหลังได้
* ใช้เพื่อ

  * collaboration
  * tracking changes
  * restore version
* เหมาะกับ text file

## 2️⃣ Git คืออะไร

* distributed version control system
* track changes ของไฟล์
* ใช้ manage source code

## 3️⃣ Git vs GitHub

* Git = tool จัดการ version
* GitHub = platform เก็บ repo และ collaborate

---

## 4️⃣ Git Structure (สำคัญมาก)

ต้องเข้าใจ flow นี้

Working Directory → Staging Area → Local Repo → Remote Repo

คำสั่งที่เกี่ยว

* git add
* git commit
* git push
* git pull

---

## 5️⃣ Git Workflow / Collaboration

ต้องเข้าใจ

### Feature branch workflow

* ทำงานใน branch ไม่ใช่ main
* merge หลัง test

### GitHub workflow

1 create branch
2 commit change
3 pull request
4 merge

---

## 6️⃣ Branch + HEAD + Index

ต้องรู้

* branch = pointer ไป commit
* HEAD = commit ปัจจุบัน
* index = staging area

---

## 7️⃣ Merge vs Rebase ⭐ ออกบ่อย

| Merge               | Rebase          |
| ------------------- | --------------- |
| ไม่ rewrite history | rewrite history |
| create merge commit | history linear  |
| default pull        | cleaner history |

---

## 8️⃣ Undo Changes ⭐⭐⭐ สำคัญมาก

ต้องแยกให้ได้

### git restore

* เอาไฟล์กลับจาก index / commit
* ไม่เปลี่ยน history

### git reset

* ย้อน commit
* เปลี่ยน history

### git revert

* สร้าง commit ใหม่เพื่อยกเลิก commit เดิม
* history ไม่เปลี่ยน (safe)

### git checkout (commit)

* detached HEAD

---

## 9️⃣ Conflict และการแก้

ต้องรู้

* conflict เกิดเมื่อ merge/pull แล้วแก้ไฟล์เดียวกัน
* conflict markers

  * <<<<<<<
  * =======
  * > > > > > > >
* วิธีแก้

  * เลือก change
  * edit file
  * git add
  * commit

---

## 🔟 IDE

IDE คือ software สำหรับพัฒนาโปรแกรม มี

* editor
* debugger
* compiler
* version control
* GUI tools

ข้อดี

* productivity สูง
* config น้อย

---

# 💻 ส่วนที่ 2 : ปฏิบัติ (Practical)

ต้องทำจริงในเครื่อง

## 1️⃣ Git Basic

* clone
* init
* add
* commit
* push
* pull
* fetch

---

## 2️⃣ Branch Management

* create branch
* switch branch
* merge branch

---

## 3️⃣ Undo Commands

ต้องใช้ได้จริง

* restore file
* reset commit
* revert commit

---

## 4️⃣ Conflict Resolution ⭐ ออกแน่

* pull แล้ว conflict
* edit file
* add
* commit

---

## 5️⃣ Git Workflow จริง

อาจให้ทำขั้นตอนเช่น

* create branch
* edit file
* commit
* merge

---

## 6️⃣ IDE usage

เช่น

* run code
* debug
* terminal
* version control panel

---

# ⭐⭐⭐ สิ่งที่ “ออกสอบแน่นอน”

จาก pattern วิชา

🔥 Git workflow
🔥 merge vs rebase
🔥 revert vs reset vs restore
🔥 conflict resolution
🔥 branch + HEAD
🔥 practical Git commands

---

# 🧩 ทักษะที่ต้องมี

✔ เข้าใจ concept
✔ อ่าน Git history ได้
✔ ใช้ command line ได้
✔ แก้ conflict ได้
✔ ทำ workflow ได้

---

# 📌 Checklist ก่อนสอบ

ถ้ายังทำไม่ได้ = ยังไม่พร้อม

□ clone repo
□ commit push pull
□ create branch
□ merge branch
□ resolve conflict
□ revert commit
□ reset commit
□ restore file
□ อธิบาย merge vs rebase
□ อธิบาย Git workflow

---

# 🧠 สรุปสั้นสุด (เอาไปท่อง)

สอบมี 2 ส่วน
👉 theory = concept Git + workflow
👉 practical = ใช้ Git จริง

ต้องรู้
Git structure
branch
merge / rebase
undo commands
conflict resolution

---

ถ้าต้องการ
✅ แนวข้อสอบจริง
✅ ตัวอย่างข้อสอบ
✅ cheat sheet ก่อนสอบ
✅ lab ที่น่าจะออก

บอกได้เลย เดี๋ยวจัดให้ 🔥
