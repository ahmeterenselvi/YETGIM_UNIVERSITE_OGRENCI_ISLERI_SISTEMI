-- Tablolar
CREATE TABLE faculties (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    faculty_id INTEGER NOT NULL REFERENCES faculties(id) ON DELETE CASCADE,
    name TEXT NOT NULL
);

CREATE TABLE instructors (
    id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    enrollment_year INTEGER NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
    instructor_id INTEGER REFERENCES instructors(id) ON DELETE SET NULL,
    code TEXT NOT NULL,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL DEFAULT 3,
    capacity INTEGER NOT NULL DEFAULT 30
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester TEXT NOT NULL,
    enrolled_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    UNIQUE(student_id, course_id, semester)
);

CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    numeric_grade NUMERIC(5,2) CHECK (numeric_grade >= 0 AND numeric_grade <= 100),
    letter_grade TEXT,
    grade_points NUMERIC(4,2)
);

-- Örnek veriler
INSERT INTO faculties (name) VALUES
('Mühendislik'),
('Fen-Edebiyat'),
('İktisadi ve İdari Bilimler')
ON CONFLICT DO NOTHING;

INSERT INTO departments (faculty_id, name) VALUES
((SELECT id FROM faculties WHERE name='Mühendislik'), 'Bilgisayar Mühendisliği'),
((SELECT id FROM faculties WHERE name='Mühendislik'), 'Elektrik-Elektronik Müh.'),
((SELECT id FROM faculties WHERE name='Fen-Edebiyat'), 'Matematik'),
((SELECT id FROM faculties WHERE name='İktisadi ve İdari Bilimler'), 'İşletme')
ON CONFLICT DO NOTHING;

INSERT INTO instructors (department_id, first_name, last_name) VALUES
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), 'Mehmet', 'Yılmaz'),
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), 'Ayşe', 'Demir'),
((SELECT id FROM departments WHERE name='Matematik'), 'Ali', 'Kara')
ON CONFLICT DO NOTHING;

INSERT INTO students (department_id, first_name, last_name, enrollment_year) VALUES
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), 'Ahmet', 'Kaya', 2021),
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), 'Zeynep', 'Öztürk', 2022),
((SELECT id FROM departments WHERE name='Elektrik-Elektronik Müh.'), 'Murat', 'Aydın', 2020),
((SELECT id FROM departments WHERE name='Matematik'), 'Selin', 'Güneş', 2021),
((SELECT id FROM departments WHERE name='İşletme'), 'Emre', 'Koç', 2023),
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), 'Bora', 'Çelik', 2021)
ON CONFLICT DO NOTHING;

INSERT INTO courses (department_id, instructor_id, code, title, credits, capacity) VALUES
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), (SELECT id FROM instructors WHERE first_name='Mehmet'), 'CS101', 'Programlamaya Giriş', 4, 40),
((SELECT id FROM departments WHERE name='Bilgisayar Mühendisliği'), (SELECT id FROM instructors WHERE first_name='Ayşe'), 'CS201', 'Veritabanı Sistemleri', 3, 35),
((SELECT id FROM departments WHERE name='Matematik'), (SELECT id FROM instructors WHERE first_name='Ali'), 'MATH101', 'Analiz I', 4, 50),
((SELECT id FROM departments WHERE name='İşletme'), NULL, 'BUS101', 'İşletme Yönetimine Giriş', 3, 60)
ON CONFLICT DO NOTHING;

INSERT INTO enrollments (student_id, course_id, semester) VALUES
((SELECT id FROM students WHERE first_name='Ahmet'), (SELECT id FROM courses WHERE code='CS101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Ahmet'), (SELECT id FROM courses WHERE code='CS201'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Zeynep'), (SELECT id FROM courses WHERE code='CS101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Bora'), (SELECT id FROM courses WHERE code='CS101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Murat'), (SELECT id FROM courses WHERE code='MATH101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Selin'), (SELECT id FROM courses WHERE code='MATH101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Emre'), (SELECT id FROM courses WHERE code='BUS101'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Zeynep'), (SELECT id FROM courses WHERE code='CS201'), '2024-2025-2'),
((SELECT id FROM students WHERE first_name='Ahmet'), (SELECT id FROM courses WHERE code='MATH101'), '2024-2025-2')
ON CONFLICT DO NOTHING;

INSERT INTO grades (enrollment_id, numeric_grade) VALUES
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Ahmet' AND e.course_id=(SELECT id FROM courses WHERE code='CS101') LIMIT 1), 85.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Ahmet' AND e.course_id=(SELECT id FROM courses WHERE code='CS201') LIMIT 1), 78.5),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Zeynep' AND e.course_id=(SELECT id FROM courses WHERE code='CS101') LIMIT 1), 92.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Bora' AND e.course_id=(SELECT id FROM courses WHERE code='CS101') LIMIT 1), 60.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Murat' AND e.course_id=(SELECT id FROM courses WHERE code='MATH101') LIMIT 1), 88.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Selin' AND e.course_id=(SELECT id FROM courses WHERE code='MATH101') LIMIT 1), 95.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Emre' AND e.course_id=(SELECT id FROM courses WHERE code='BUS101') LIMIT 1), 55.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Zeynep' AND e.course_id=(SELECT id FROM courses WHERE code='CS201') LIMIT 1), 81.0),
((SELECT e.id FROM enrollments e JOIN students s ON e.student_id=s.id WHERE s.first_name='Ahmet' AND e.course_id=(SELECT id FROM courses WHERE code='MATH101') LIMIT 1), 72.0)
ON CONFLICT DO NOTHING;

-- ============================================
-- Fonksiyonlar
-- ============================================

-- Notu harf ve puana çevir
CREATE OR REPLACE FUNCTION _numeric_to_letter_and_points(n NUMERIC)
RETURNS TABLE(letter TEXT, points NUMERIC) AS $$
BEGIN
    IF n IS NULL THEN
        letter := NULL; points := NULL; RETURN NEXT;
    ELSIF n >= 90 THEN letter := 'AA'; points := 4.0; RETURN NEXT;
    ELSIF n >= 85 THEN letter := 'BA'; points := 3.5; RETURN NEXT;
    ELSIF n >= 80 THEN letter := 'BB'; points := 3.0; RETURN NEXT;
    ELSIF n >= 75 THEN letter := 'CB'; points := 2.5; RETURN NEXT;
    ELSIF n >= 70 THEN letter := 'CC'; points := 2.0; RETURN NEXT;
    ELSIF n >= 60 THEN letter := 'DC'; points := 1.5; RETURN NEXT;
    ELSIF n >= 50 THEN letter := 'DD'; points := 1.0; RETURN NEXT;
    ELSE letter := 'FF'; points := 0.0; RETURN NEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Genel GPA hesaplama
CREATE OR REPLACE FUNCTION calculate_gpa(p_student_id INTEGER)
RETURNS NUMERIC(4,2) AS $$
DECLARE
    gpa NUMERIC(6,4);
BEGIN
    SELECT
        CASE WHEN SUM(c.credits) = 0 THEN NULL
             ELSE ROUND(SUM(g.grade_points * c.credits) / SUM(c.credits)::NUMERIC, 2)
        END
    INTO gpa
    FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.id
    JOIN courses c ON e.course_id = c.id
    WHERE e.student_id = p_student_id
      AND g.grade_points IS NOT NULL;

    RETURN gpa;
END;
$$ LANGUAGE plpgsql;

-- Ders doluluk oranı
CREATE OR REPLACE FUNCTION course_capacity_check(p_course_id INTEGER)
RETURNS NUMERIC(5,2) AS $$
DECLARE
    cap INTEGER;
    enrolled_count INTEGER;
    percent NUMERIC(5,2);
BEGIN
    SELECT capacity INTO cap FROM courses WHERE id = p_course_id;
    IF cap IS NULL THEN
        RAISE EXCEPTION 'Course % not found', p_course_id;
    END IF;
    SELECT COUNT(*) INTO enrolled_count FROM enrollments WHERE course_id = p_course_id;
    percent := ROUND((enrolled_count::NUMERIC / cap::NUMERIC) * 100, 2);
    RETURN percent;
END;
$$ LANGUAGE plpgsql;

-- Akademik durum
CREATE OR REPLACE FUNCTION student_academic_status(p_gpa NUMERIC)
RETURNS TEXT AS $$
BEGIN
    IF p_gpa IS NULL THEN
        RETURN 'No GPA';
    ELSIF p_gpa >= 3.50 THEN
        RETURN 'Takdir';
    ELSIF p_gpa >= 3.00 THEN
        RETURN 'Teşekkür';
    ELSIF p_gpa >= 2.00 THEN
        RETURN 'Normal';
    ELSE
        RETURN 'Şartlı';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Triggerlar
-- ============================================

-- Ders kaydı öncesi kontenjan kontrol
CREATE OR REPLACE FUNCTION trg_check_capacity()
RETURNS TRIGGER AS $$
DECLARE
    cap INTEGER;
    enrolled_cnt INTEGER;
BEGIN
    SELECT capacity INTO cap FROM courses WHERE id = NEW.course_id FOR UPDATE;
    SELECT COUNT(*) INTO enrolled_cnt FROM enrollments WHERE course_id = NEW.course_id AND semester = NEW.semester;

    IF enrolled_cnt >= cap THEN
        RAISE EXCEPTION 'Course % is full for semester % (capacity %)', NEW.course_id, NEW.semester, cap;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enroll_capacity
BEFORE INSERT ON enrollments
FOR EACH ROW EXECUTE FUNCTION trg_check_capacity();

-- Not girildiğinde harf notu hesapla
CREATE OR REPLACE FUNCTION trg_compute_letter_grade()
RETURNS TRIGGER AS $$
DECLARE
    l TEXT;
    p NUMERIC;
BEGIN
    IF NEW.numeric_grade IS NULL THEN
        NEW.letter_grade := NULL;
        NEW.grade_points := NULL;
        RETURN NEW;
    END IF;

    SELECT letter, points INTO l, p FROM _numeric_to_letter_and_points(NEW.numeric_grade);
    NEW.letter_grade := l;
    NEW.grade_points := p;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_grade_insert
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW EXECUTE FUNCTION trg_compute_letter_grade();

-- Öğrenci silindiğinde ilgili kayıtlar
CREATE OR REPLACE FUNCTION trg_cleanup_student()
RETURNS TRIGGER AS $$
BEGIN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_student_delete
AFTER DELETE ON students
FOR EACH ROW EXECUTE FUNCTION trg_cleanup_student();

-- ============================================
-- Stored Procedureler
-- ============================================

-- Ders kaydı (kontenjan kontrolü ile)
CREATE OR REPLACE PROCEDURE sp_enroll_course(p_student_id INT, p_course_id INT, p_semester TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM course_capacity_check(p_course_id);
    INSERT INTO enrollments (student_id, course_id, semester)
    VALUES (p_student_id, p_course_id, p_semester);
END;
$$;

-- Dönem GPA hesaplama
CREATE OR REPLACE PROCEDURE sp_calculate_semester_gpa(p_student_id INT, p_semester TEXT, OUT semester_gpa NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT
        CASE WHEN SUM(c.credits) = 0 THEN NULL
             ELSE ROUND(SUM(g.grade_points * c.credits) / SUM(c.credits)::NUMERIC, 2)
        END
    INTO semester_gpa
    FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.id
    JOIN courses c ON e.course_id = c.id
    WHERE e.student_id = p_student_id
      AND e.semester = p_semester
      AND g.grade_points IS NOT NULL;
END;
$$;

-- ============================================
-- Viewlar
-- ============================================

-- Bölümlere göre öğrenci sayıları ve ortalama GPA
CREATE OR REPLACE VIEW vw_department_student_stats AS
SELECT d.id AS department_id,
       d.name AS department_name,
       f.name AS faculty_name,
       COUNT(s.id) AS student_count,
       ROUND(AVG(cg.gpa)::NUMERIC,2) AS avg_gpa
FROM departments d
LEFT JOIN faculties f ON d.faculty_id = f.id
LEFT JOIN students s ON s.department_id = d.id
LEFT JOIN (
    SELECT st.id AS student_id, calculate_gpa(st.id) AS gpa
    FROM students st
) cg ON cg.student_id = s.id
GROUP BY d.id, d.name, f.name;

-- Öğretim görevlilerinin ders yükleri
CREATE OR REPLACE VIEW vw_instructor_load AS
SELECT i.id AS instructor_id,
       i.first_name || ' ' || i.last_name AS instructor_name,
       COUNT(c.id) AS course_count,
       COALESCE(SUM(c.credits),0) AS total_credits
FROM instructors i
LEFT JOIN courses c ON c.instructor_id = i.id
GROUP BY i.id, i.first_name, i.last_name;

-- ============================================
-- Test ve Örnek Sorgular (DO blokları ile CALL uyumlu)
-- ============================================

-- Sp enroll_course test
CREATE OR REPLACE PROCEDURE sp_enroll_course(p_student_id INT, p_course_id INT, p_semester TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM course_capacity_check(p_course_id);
    INSERT INTO enrollments (student_id, course_id, semester)
    VALUES (p_student_id, p_course_id, p_semester)
    ON CONFLICT (student_id, course_id, semester) DO NOTHING;
END;
$$;

-- Sp calculate_semester_gpa test
DO $$
DECLARE
    ahmet_id INT;
    gpa NUMERIC;
BEGIN
    SELECT id INTO ahmet_id FROM students WHERE first_name='Ahmet';
    CALL sp_calculate_semester_gpa(ahmet_id, '2024-2025-2', gpa);
    RAISE NOTICE 'Ahmet GPA: %', gpa;
END $$;

-- Fonksiyon testleri
SELECT calculate_gpa((SELECT id FROM students WHERE first_name='Ahmet')) AS ahmet_gpa;
SELECT course_capacity_check((SELECT id FROM courses WHERE code='CS101')) AS cs101_occupancy_pct;
SELECT student_academic_status(calculate_gpa((SELECT id FROM students WHERE first_name='Ahmet'))) AS ahmet_status;

-- View testleri
SELECT * FROM vw_department_student_stats;
SELECT * FROM vw_instructor_load;