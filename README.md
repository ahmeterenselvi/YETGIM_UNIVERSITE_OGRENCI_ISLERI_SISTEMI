# YETGIM_UNIVERSITE_OGRENCI_ISLERI_SISTEMI

Bu proje PostgreSQL ile hazırlanmış basit bir üniversite öğrenci işleri veritabanı uygulamasıdır. Tablolar, fonksiyonlar, triggerlar, stored procedure’ler ve view’lar içerir. Ayrıca veritabanı yapısını görselleştirmek için DrawSQL diyagramı da eklenmiştir.

Dosya Yapısı
/project_root
   /sql
      isim_soyisim_proje.sql   → Tüm SQL scriptleri
   /diagrams
      university_db_diagram.drawsql  → Veritabanı diyagramı

İçerik
Tablolar

faculties: Fakülteler

departments: Bölümler

students: Öğrenciler

instructors: Öğretim görevlileri

courses: Dersler

enrollments: Ders kayıtları

grades: Notlar

Fonksiyonlar

calculate_gpa(student_id) → Öğrencinin genel not ortalamasını hesaplar

course_capacity_check(course_id) → Dersin doluluk oranını hesaplar

student_academic_status(gpa) → Akademik durumu belirler (Takdir/Teşekkür/Normal/Şartlı)

Triggerlar

Ders kaydı yapılırken kontenjan kontrolü

Not girildiğinde harf notunu otomatik hesaplama

Öğrenci silindiğinde ilgili kayıtları temizleme

Stored Procedure’ler

sp_enroll_course(student_id, course_id, semester) → Ders kaydı yapar (kontenjan kontrolü ile)

sp_calculate_semester_gpa(student_id, semester) → Dönem not ortalamasını hesaplar

View’lar

vw_department_student_stats → Bölümlere göre öğrenci sayıları ve ortalama GPA’lar

vw_instructor_load → Öğretim görevlilerinin ders yükleri

Kompleks Sorgular

Fakültelere göre en başarılı öğrenciler

En çok tercih edilen dersler

GPA ortalamasının üstünde olan öğrenciler

Kullanım

PostgreSQL’e bağlan ve isim_soyisim_proje.sql dosyasını çalıştır.

Fonksiyonları, trigger’ları ve stored procedure’leri test et:

-- Örnek GPA sorgusu
SELECT calculate_gpa((SELECT id FROM students WHERE first_name='Ahmet'));

-- Ders kaydı örneği
DO $$
DECLARE
    student_id INT;
    course_id INT;
BEGIN
    SELECT id INTO student_id FROM students WHERE first_name='Bora';
    SELECT id INTO course_id FROM courses WHERE code='CS101';
    CALL sp_enroll_course(student_id, course_id, '2024-2025-2');
END $$;


View ve sorguları kullanarak öğrenci ve ders analizleri yapabilirsin.
