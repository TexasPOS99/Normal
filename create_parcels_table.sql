-- =============================================
-- สร้างตาราง parcels สำหรับเก็บเลขติดตามพัสดุ
-- รัน SQL นี้ใน Supabase SQL Editor
-- =============================================

CREATE TABLE IF NOT EXISTS parcels (
  id          BIGSERIAL PRIMARY KEY,
  email_id    BIGINT NOT NULL REFERENCES links(id) ON DELETE CASCADE,
  tracking_data TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Index เพื่อให้ query เร็วขึ้น
CREATE INDEX IF NOT EXISTS idx_parcels_email_id ON parcels(email_id);

-- เปิด Row Level Security (RLS) - ปรับตามความต้องการ
ALTER TABLE parcels ENABLE ROW LEVEL SECURITY;

-- Policy: อนุญาตให้ทุกคน (anon) อ่านและเขียนได้ (เหมือนกับตาราง links)
CREATE POLICY "Allow all for anon" ON parcels
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- เปิด Realtime สำหรับตาราง parcels
ALTER PUBLICATION supabase_realtime ADD TABLE parcels;
