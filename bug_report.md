# Bug Report - Full Code Review

## BUG #1: editBoardContainer ไม่มีอยู่จริงใน HTML
- บรรทัด 1137: `document.getElementById('editBoardContainer').classList.add('hidden');`
- ไม่มี element `id="editBoardContainer"` ใน HTML เลย
- ผลกระทบ: เมื่อกดแก้ไขที่อยู่ จะเกิด JS error `Cannot read properties of null`
- แก้ไข: ลบบรรทัดนี้ออก หรือเพิ่ม null check

## BUG #2: openEditModal ไม่ซ่อน editAddressContainer
- บรรทัด 1717-1737: openEditModal สำหรับ email/message ไม่ได้ซ่อน editAddressContainer
- ผลกระทบ: ถ้าเปิด edit ที่อยู่ก่อน แล้วปิด แล้วเปิด edit email/message ต่อ จะเห็น editAddressContainer ค้างอยู่
- แก้ไข: เพิ่ม `document.getElementById('editAddressContainer').classList.add('hidden');` ใน openEditModal

## BUG #3: Matrix Background setInterval ไม่มี cleanup
- บรรทัด 846: `setInterval(draw, 35);` ≈ 28.5 FPS ตลอดเวลา
- ผลกระทบ: กิน CPU/battery ตลอดเวลาแม้ไม่ได้ใช้งาน โดยเฉพาะบนมือถือ
- แก้ไข: ใช้ requestAnimationFrame + Page Visibility API หยุดเมื่อไม่ได้ดูหน้า

## BUG #4: confBtn onclick สร้าง url ไม่ตรงกับ buildEmailUrl
- บรรทัด 1546: confBtn สร้าง url ด้วยตัวเอง ไม่ได้ใช้ buildEmailUrl()
- ผลกระทบ: ถ้ามีการเปลี่ยน format ในอนาคต จะต้องแก้ 2 ที่ เสี่ยงไม่ sync กัน
- แก้ไข: ใช้ buildEmailUrl() แทน

## BUG #5: clearFilterBtn เรียก loadData() ไม่จำเป็น
- บรรทัด 1694: clearFilterBtn เรียก loadData() ทั้งที่แค่ล้าง filter
- ผลกระทบ: network request ที่ไม่จำเป็น
- แก้ไข: ใช้ renderEmails(currentEmailsList) + renderMessages(allMessagesList) แทน

## BUG #6: updateLoadMoreButtons ใช้ currentEmailsList.length แทน filtered.length
- บรรทัด 1701: เช็ค `currentEmailsList.length > emailDisplayCount`
- ผลกระทบ: ปุ่ม Load More อาจแสดงทั้งที่ filtered results น้อยกว่า displayCount
- แก้ไข: ส่ง filtered count เข้า updateLoadMoreButtons

## BUG #7: "คัดลอก + ส่งไปบอร์ด" ต่อท้ายข้อความเดิมในช่อง boardMessageInput
- บรรทัด 1264-1266: ถ้ามีข้อความเดิมในช่อง จะต่อท้าย
- ผลกระทบ: อาจสับสน ควรถามหรือแทนที่
- แก้ไข: แทนที่ข้อความเดิมแทนต่อท้าย (เพราะเป็นข้อความพรางใหม่)
