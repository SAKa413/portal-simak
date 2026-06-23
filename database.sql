CREATE DATABASE IF NOT EXISTS esaka_db;
USE esaka_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    nama VARCHAR(100) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    kelas VARCHAR(20),
    no_wa VARCHAR(20),
    bio TEXT,
    alamat TEXT,
    foto_url LONGTEXT
);

INSERT INTO users (id, username, password, role, nama, unit, kelas, no_wa, bio, alamat, foto_url) VALUES
(1, 'admin', '123', 'Admin', 'Administrator SAKa', 'Semua', '-', '628123', '', '', ''),
(2, 'manajer', '123', 'Manajer', 'Ibu Fatimah', 'SD', '-', '62811', '', '', ''),
(3, 'fasil', '123', 'Fasilitator', 'Pak Budiman', 'SD', '1 A', '62899', '', '', ''),
(4, 'fasilstimulus', '123', 'Fasilitator', 'Ibu Diana', 'Stimulus', 'MANDIRI 1', '62877', '', '', '');

CREATE TABLE IF NOT EXISTS absen_pegawai (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    nama VARCHAR(100),
    role VARCHAR(50),
    tanggal DATE,
    waktu TIME,
    lat VARCHAR(50),
    lng VARCHAR(50),
    distance VARCHAR(50),
    foto LONGTEXT
);

CREATE TABLE IF NOT EXISTS action_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(20),
    target VARCHAR(100),
    action VARCHAR(255),
    detail_action TEXT,
    budget BIGINT,
    unit VARCHAR(50),
    status_pelaksanaan VARCHAR(50) DEFAULT 'Belum',
    aktual_dana BIGINT DEFAULT 0
);

INSERT INTO action_plans (id, tahun_ajaran, target, action, detail_action, budget, unit, status_pelaksanaan, aktual_dana) VALUES
(1, '2025/2026', 'Kemandirian', 'Outing Class', 'Peternakan', 5000000, 'SD', 'Belum', 0);

CREATE TABLE IF NOT EXISTS semester_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(20),
    bulan VARCHAR(20),
    pekan VARCHAR(5),
    tema VARCHAR(100),
    religion VARCHAR(100),
    indonesian VARCHAR(100),
    math VARCHAR(100),
    science VARCHAR(100),
    social VARCHAR(100),
    english VARCHAR(100),
    art VARCHAR(100),
    ict VARCHAR(100),
    scouting VARCHAR(100),
    gardening VARCHAR(100),
    event VARCHAR(255),
    kelas VARCHAR(50),
    unit VARCHAR(50),
    status VARCHAR(50),
    created_by VARCHAR(100)
);

INSERT INTO semester_plans (id, tahun_ajaran, bulan, pekan, tema, religion, indonesian, math, science, social, english, art, ict, scouting, gardening, event, kelas, unit, status, created_by) VALUES
(1, '2025/2026', 'Juli', '1', 'Tema 1', 'Kisah Nabi', 'Kosa Kata Baru', '1-10', 'Daun', 'Keluargaku', 'Greeting', 'Mewarnai', 'PC', 'Siaga', 'Cabai', 'Awal Sekolah', '1 A', 'SD', 'Pending', 'Pak Budiman');

CREATE TABLE IF NOT EXISTS event_classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(20),
    bulan VARCHAR(20),
    pekan VARCHAR(5),
    tanggal_event DATE,
    event_name VARCHAR(100),
    keterangan TEXT,
    kelas VARCHAR(50),
    unit VARCHAR(50),
    status VARCHAR(50),
    created_by VARCHAR(100)
);

INSERT INTO event_classes (id, tahun_ajaran, bulan, pekan, tanggal_event, event_name, keterangan, kelas, unit, status, created_by) VALUES
(1, '2025/2026', 'Juli', '1', '2026-07-06', 'Awal Masuk Sekolah', 'Penyambutan siswa', '1 A', 'SD', 'Approved', 'Pak Budiman');

CREATE TABLE IF NOT EXISTS weekly_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(20),
    bulan VARCHAR(20),
    pekan VARCHAR(5),
    subject VARCHAR(100),
    kd_capaian TEXT,
    indikator TEXT,
    tujuan TEXT,
    waktu_jam VARCHAR(50),
    kegiatan VARCHAR(255),
    materi VARCHAR(255),
    media VARCHAR(255),
    metode VARCHAR(100),
    sumber VARCHAR(100),
    profil_pancasila VARCHAR(100),
    penilaian VARCHAR(100),
    kelas VARCHAR(50),
    unit VARCHAR(50),
    status VARCHAR(50),
    created_by VARCHAR(100),
    siswa_nama VARCHAR(100)
);

INSERT INTO weekly_plans (id, tahun_ajaran, bulan, pekan, subject, kd_capaian, indikator, tujuan, waktu_jam, kegiatan, materi, media, metode, sumber, profil_pancasila, penilaian, kelas, unit, status, created_by) VALUES
(1, '2025/2026', 'Juli', '1', 'Math', 'Berhitung', 'Menghitung 1-10', 'Logika', '08:00 - 09:30', 'Batu', 'Objek', 'Kerikil', 'Eksplorasi', 'Buku', 'Mandiri', 'Observasi', '1 A', 'SD', 'Pending', 'Pak Budiman');

CREATE TABLE IF NOT EXISTS weekly_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(20),
    bulan VARCHAR(20),
    pekan VARCHAR(5),
    kelas VARCHAR(50),
    unit VARCHAR(50),
    siswa_nama VARCHAR(100),
    rutinitas TEXT,
    laporan TEXT,
    status VARCHAR(50),
    created_by VARCHAR(100)
);

INSERT INTO weekly_reports (id, tahun_ajaran, bulan, pekan, kelas, unit, siswa_nama, rutinitas, laporan, status, created_by) VALUES
(1, '2025/2026', 'Juli', '1', 'MANDIRI 1', 'Stimulus', 'Bimo', '[{"kegiatan":"Datang tepat waktu","sen":"✓","sel":"✓","rab":"✓","kam":"✓","jum":"✓"}]', 'Bimo mulai bisa fokus.', 'Pending', 'Ibu Diana');

CREATE TABLE IF NOT EXISTS siswa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100),
    kelas VARCHAR(50),
    unit VARCHAR(50),
    no_wa VARCHAR(20)
);

INSERT INTO siswa (id, nama, kelas, unit, no_wa) VALUES
(1, 'Ananda Putra', '1 A', 'SD', '628122'),
(2, 'Bunga Lestari', '1 A', 'SD', '628133'),
(3, 'Bimo', 'MANDIRI 1', 'Stimulus', '628111'),
(4, 'Fathian', 'MANDIRI 1', 'Stimulus', '628555'),
(5, 'Cakra', 'MANDIRI 1', 'Stimulus', '628129'),
(6, 'Revan', 'MANDIRI 1', 'Stimulus', '628777');

CREATE TABLE IF NOT EXISTS absensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    siswa_id INT,
    tanggal DATE,
    status VARCHAR(20),
    keterangan VARCHAR(255),
    unit VARCHAR(50),
    kelas VARCHAR(50)
);

INSERT INTO absensi (id, siswa_id, tanggal, status, keterangan, unit, kelas) VALUES
(1, 1, '2026-06-10', 'Hadir', 'Tepat waktu', 'SD', '1 A');
