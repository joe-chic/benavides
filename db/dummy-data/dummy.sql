-- ============================================================================
-- Farmacias Benavides - Dummy Data
-- ============================================================================
-- This file contains realistic dummy data for testing and development
-- All data is fictional but designed to be realistic for a Mexican pharmacy chain
-- ============================================================================

-- Disable foreign key checks temporarily for data insertion
SET session_replication_role = 'replica';

-- ============================================================================
-- COUNTRIES
-- ============================================================================
INSERT INTO public.countries (id_country, iso_code, name) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'MX', 'México');

-- ============================================================================
-- ADMIN SUBDIVISIONS (Estados)
-- ============================================================================
INSERT INTO public.admin_subdivisions (id_area, id_country, iso_code, name) VALUES
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 'NL', 'Nuevo León'),
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'DF', 'Ciudad de México'),
('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440001', 'JA', 'Jalisco'),
('550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440001', 'YU', 'Yucatán'),
('550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440001', 'QR', 'Quintana Roo');

-- ============================================================================
-- CITIES
-- ============================================================================
INSERT INTO public.cities (id_city, id_area, name) VALUES
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440010', 'Monterrey'),
('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440010', 'San Pedro Garza García'),
('550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440011', 'Ciudad de México'),
('550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440011', 'Benito Juárez'),
('550e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440012', 'Guadalajara'),
('550e8400-e29b-41d4-a716-446655440025', '550e8400-e29b-41d4-a716-446655440013', 'Mérida'),
('550e8400-e29b-41d4-a716-446655440026', '550e8400-e29b-41d4-a716-446655440014', 'Cancún');

-- ============================================================================
-- NEIGHBORHOODS
-- ============================================================================
INSERT INTO public.neighborhoods (id_neighborhood, id_city, name) VALUES
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440020', 'Centro'),
('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440020', 'San Jerónimo'),
('550e8400-e29b-41d4-a716-446655440032', '550e8400-e29b-41d4-a716-446655440020', 'Valle Oriente'),
('550e8400-e29b-41d4-a716-446655440033', '550e8400-e29b-41d4-a716-446655440021', 'Centro'),
('550e8400-e29b-41d4-a716-446655440034', '550e8400-e29b-41d4-a716-446655440022', 'Roma Norte'),
('550e8400-e29b-41d4-a716-446655440035', '550e8400-e29b-41d4-a716-446655440022', 'Condesa'),
('550e8400-e29b-41d4-a716-446655440036', '550e8400-e29b-41d4-a716-446655440024', 'Centro Histórico'),
('550e8400-e29b-41d4-a716-446655440037', '550e8400-e29b-41d4-a716-446655440025', 'Centro'),
('550e8400-e29b-41d4-a716-446655440038', '550e8400-e29b-41d4-a716-446655440026', 'Zona Hotelera');

-- ============================================================================
-- POSTAL CODES
-- ============================================================================
INSERT INTO public.postal_codes (id_postal_codes, id_country, code) VALUES
('550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440001', '64000'),
('550e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440001', '64010'),
('550e8400-e29b-41d4-a716-446655440042', '550e8400-e29b-41d4-a716-446655440001', '66220'),
('550e8400-e29b-41d4-a716-446655440043', '550e8400-e29b-41d4-a716-446655440001', '06700'),
('550e8400-e29b-41d4-a716-446655440044', '550e8400-e29b-41d4-a716-446655440001', '44100'),
('550e8400-e29b-41d4-a716-446655440045', '550e8400-e29b-41d4-a716-446655440001', '97000'),
('550e8400-e29b-41d4-a716-446655440046', '550e8400-e29b-41d4-a716-446655440001', '77500');

-- ============================================================================
-- ADDRESSES
-- ============================================================================
INSERT INTO public.addresses (id_address, street_number, street_number_norm, street_name, street_name_norm, id_postal_code, id_neighborhood) VALUES
('550e8400-e29b-41d4-a716-446655440050', 123, '123', 'Avenida Constitución', 'AVENIDA CONSTITUCION', '550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440030'),
('550e8400-e29b-41d4-a716-446655440051', 456, '456', 'Calle Morelos', 'CALLE MORELOS', '550e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440031'),
('550e8400-e29b-41d4-a716-446655440052', 789, '789', 'Boulevard Díaz Ordaz', 'BOULEVARD DIAZ ORDAZ', '550e8400-e29b-41d4-a716-446655440042', '550e8400-e29b-41d4-a716-446655440032'),
('550e8400-e29b-41d4-a716-446655440053', 321, '321', 'Avenida Revolución', 'AVENIDA REVOLUCION', '550e8400-e29b-41d4-a716-446655440043', '550e8400-e29b-41d4-a716-446655440034'),
('550e8400-e29b-41d4-a716-446655440054', 654, '654', 'Calle Insurgentes', 'CALLE INSURGENTES', '550e8400-e29b-41d4-a716-446655440044', '550e8400-e29b-41d4-a716-446655440036'),
('550e8400-e29b-41d4-a716-446655440055', 987, '987', 'Avenida Paseo de Montejo', 'AVENIDA PASEO DE MONTEJO', '550e8400-e29b-41d4-a716-446655440045', '550e8400-e29b-41d4-a716-446655440037'),
('550e8400-e29b-41d4-a716-446655440056', 147, '147', 'Boulevard Kukulcán', 'BOULEVARD KUKULCAN', '550e8400-e29b-41d4-a716-446655440046', '550e8400-e29b-41d4-a716-446655440038');

-- ============================================================================
-- ROLES
-- ============================================================================
INSERT INTO public.roles (id, name, description) VALUES
('550e8400-e29b-41d4-a716-446655440060', 'administrator', 'Administrador del sistema con acceso completo'),
('550e8400-e29b-41d4-a716-446655440061', 'medic', 'Médico con capacidad de realizar consultas y prescripciones'),
('550e8400-e29b-41d4-a716-446655440062', 'patient', 'Paciente del sistema'),
('550e8400-e29b-41d4-a716-446655440063', 'recepcionist', 'Recepcionista con capacidad de agendar citas y registrar pacientes'),
('550e8400-e29b-41d4-a716-446655440064', 'pharmaceutic', 'Farmacéutico con capacidad de dispensar medicamentos');

-- ============================================================================
-- PERMISSIONS
-- ============================================================================
INSERT INTO public.permissions (id, name, description) VALUES
('550e8400-e29b-41d4-a716-446655440070', 'view_patients', 'Ver información de pacientes'),
('550e8400-e29b-41d4-a716-446655440071', 'create_patients', 'Crear nuevos pacientes'),
('550e8400-e29b-41d4-a716-446655440072', 'edit_patients', 'Editar información de pacientes'),
('550e8400-e29b-41d4-a716-446655440073', 'view_consultations', 'Ver consultas médicas'),
('550e8400-e29b-41d4-a716-446655440074', 'create_consultations', 'Crear consultas médicas'),
('550e8400-e29b-41d4-a716-446655440075', 'create_prescriptions', 'Crear prescripciones'),
('550e8400-e29b-41d4-a716-446655440076', 'dispense_medications', 'Dispensar medicamentos'),
('550e8400-e29b-41d4-a716-446655440077', 'schedule_appointments', 'Agendar citas'),
('550e8400-e29b-41d4-a716-446655440078', 'view_reports', 'Ver reportes del sistema'),
('550e8400-e29b-41d4-a716-446655440079', 'manage_users', 'Gestionar usuarios del sistema'),
('550e8400-e29b-41d4-a716-446655440080', 'manage_roles', 'Gestionar roles y permisos');

-- ============================================================================
-- ROLE PERMISSIONS
-- ============================================================================
-- Administrator: All permissions
INSERT INTO public.role_permissions (role_id, permission_id) VALUES
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440070'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440071'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440072'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440073'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440074'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440075'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440076'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440077'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440078'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440079'),
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440080')
ON CONFLICT DO NOTHING;

-- Medic: View patients, create consultations, create prescriptions
INSERT INTO public.role_permissions (role_id, permission_id) VALUES
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440070'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440073'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440074'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440075')
ON CONFLICT DO NOTHING;

-- Patient: View own consultations
INSERT INTO public.role_permissions (role_id, permission_id) VALUES
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440073')
ON CONFLICT DO NOTHING;

-- Recepcionist: View patients, create patients, schedule appointments
INSERT INTO public.role_permissions (role_id, permission_id) VALUES
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440070'),
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440071'),
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440077')
ON CONFLICT DO NOTHING;

-- Pharmaceutic: View prescriptions, dispense medications
INSERT INTO public.role_permissions (role_id, permission_id) VALUES
('550e8400-e29b-41d4-a716-446655440064', '550e8400-e29b-41d4-a716-446655440073'),
('550e8400-e29b-41d4-a716-446655440064', '550e8400-e29b-41d4-a716-446655440076')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- USERS
-- ============================================================================
INSERT INTO public.users (id, username, password_hash, email, mfa_enabled, display_name, created_at, created_by) VALUES
-- Administrator
('550e8400-e29b-41d4-a716-446655440100', 'admin.benavides', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'admin@farmaciasbenavides.com.mx', true, 'Administrador Sistema', '2024-01-15 08:00:00-06', NULL),
-- Medics
('550e8400-e29b-41d4-a716-446655440101', 'dr.garcia', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'dr.garcia@farmaciasbenavides.com.mx', false, 'Dr. Carlos García López', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440102', 'dra.martinez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'dra.martinez@farmaciasbenavides.com.mx', false, 'Dra. Ana Martínez Rodríguez', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440103', 'dr.hernandez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'dr.hernandez@farmaciasbenavides.com.mx', false, 'Dr. Luis Hernández Pérez', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Recepcionists
('550e8400-e29b-41d4-a716-446655440104', 'recepcion.monterrey', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'recepcion.mty@farmaciasbenavides.com.mx', false, 'María González', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440105', 'recepcion.cdmx', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'recepcion.cdmx@farmaciasbenavides.com.mx', false, 'Patricia Ramírez', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Pharmaceutics
('550e8400-e29b-41d4-a716-446655440106', 'farm.jimenez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'farm.jimenez@farmaciasbenavides.com.mx', false, 'Farmacéutico Roberto Jiménez', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440107', 'farm.torres', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'farm.torres@farmaciasbenavides.com.mx', false, 'Farmacéutica Laura Torres', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Patients (user accounts for patients)
('550e8400-e29b-41d4-a716-446655440108', 'juan.perez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'juan.perez@email.com', false, 'Juan Pérez García', '2024-02-01 10:30:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440109', 'maria.rodriguez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'maria.rodriguez@email.com', false, 'María Rodríguez López', '2024-02-02 11:15:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440110', 'roberto.fernandez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'roberto.fernandez@email.com', false, 'Roberto Fernández Morales', '2024-02-03 09:45:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440111', 'ana.sanchez', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'ana.sanchez@email.com', false, 'Ana Sánchez González', '2024-02-04 14:20:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440112', 'carlos.moreno', '$2b$10$rK9X8Z5Y3mN2pQ7vT9wX0e', 'carlos.moreno@email.com', false, 'Carlos Moreno Díaz', '2024-02-05 16:00:00-06', '550e8400-e29b-41d4-a716-446655440105');

-- ============================================================================
-- USER ROLES
-- ============================================================================
INSERT INTO public.user_roles (role_id, user_id, assigned_at, assigned_by) VALUES
-- Administrator
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440100', '2024-01-15 08:00:00-06', NULL),
-- Medics
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440101', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440102', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440103', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Recepcionists
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440104', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440063', '550e8400-e29b-41d4-a716-446655440105', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Pharmaceutics
('550e8400-e29b-41d4-a716-446655440064', '550e8400-e29b-41d4-a716-446655440106', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
('550e8400-e29b-41d4-a716-446655440064', '550e8400-e29b-41d4-a716-446655440107', '2024-01-15 08:00:00-06', '550e8400-e29b-41d4-a716-446655440100'),
-- Patients
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440108', '2024-02-01 10:30:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440109', '2024-02-02 11:15:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440110', '2024-02-03 09:45:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440111', '2024-02-04 14:20:00-06', '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440062', '550e8400-e29b-41d4-a716-446655440112', '2024-02-05 16:00:00-06', '550e8400-e29b-41d4-a716-446655440105');

-- ============================================================================
-- PATIENTS
-- ============================================================================
INSERT INTO public.patients (id, curp_hash, date_of_birth, gender, created_at, updated_by, created_by) VALUES
('550e8400-e29b-41d4-a716-446655440200', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6', '1985-03-15', 'M', '2024-02-01 10:30:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440201', 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7', '1990-07-22', 'F', '2024-02-02 11:15:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440202', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8', '1978-11-08', 'M', '2024-02-03 09:45:00-06', NULL, '550e8400-e29b-41d4-a716-446655440105'),
('550e8400-e29b-41d4-a716-446655440203', 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9', '1995-01-30', 'F', '2024-02-04 14:20:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440204', 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', '1982-09-12', 'M', '2024-02-05 16:00:00-06', NULL, '550e8400-e29b-41d4-a716-446655440105'),
('550e8400-e29b-41d4-a716-446655440205', 'f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1', '1988-05-25', 'F', '2024-02-06 10:00:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104');

-- ============================================================================
-- PATIENT PII (Encrypted - using placeholder bytea)
-- ============================================================================
INSERT INTO public.patient_pii (patient_id, first_name_enc, first_surname_enc, second_surname_enc, curp_enc, address_id, phone_enc, email_enc, contact_emergency_name_enc, contact_emergency_phone_enc, kms_key_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440200', E'\\x4a75616e', E'\\x506572657a', E'\\x476172636961', E'\\x5045474a38353033313548444c52523030', '550e8400-e29b-41d4-a716-446655440050', E'\\x38313132333435363738', E'\\x6a75616e2e706572657a40656d61696c2e636f6d', E'\\x4d6172696120506572657a', E'\\x3831313938373635343332', 'kms-key-001', '2024-02-01 10:30:00-06'),
('550e8400-e29b-41d4-a716-446655440201', E'\\x4d61726961', E'\\x526f6472696775657a', E'\\x4c6f70657a', E'\\x524f4c4d3930303732324d444c52523030', '550e8400-e29b-41d4-a716-446655440051', E'\\x38313132333435363739', E'\\x6d617269612e726f6472696775657a40656d61696c2e636f6d', E'\\x4361726c6f7320526f6472696775657a', E'\\x3831313938373635343333', 'kms-key-001', '2024-02-02 11:15:00-06'),
('550e8400-e29b-41d4-a716-446655440202', E'\\x526f626572746f', E'\\x4665726e616e64657a', E'\\x4d6f72616c6573', E'\\x4645524d37383131303848444c52523030', '550e8400-e29b-41d4-a716-446655440052', E'\\x38313132333435363830', E'\\x726f626572746f2e6665726e616e64657a40656d61696c2e636f6d', E'\\x416e61204665726e616e64657a', E'\\x3831313938373635343334', 'kms-key-001', '2024-02-03 09:45:00-06'),
('550e8400-e29b-41d4-a716-446655440203', E'\\x416e61204c61757261', E'\\x53616e6368657a', E'\\x476f6e7a616c657a', E'\\x5341474c3935303133304d444c52523030', '550e8400-e29b-41d4-a716-446655440053', E'\\x38313132333435363831', E'\\x616e612e73616e6368657a40656d61696c2e636f6d', E'\\x506564726f2053616e6368657a', E'\\x3831313938373635343335', 'kms-key-001', '2024-02-04 14:20:00-06'),
('550e8400-e29b-41d4-a716-446655440204', E'\\x4361726c6f73', E'\\x4d6f72656e6f', E'\\x4469617a', E'\\x4d4f444338323039313248444c52523030', '550e8400-e29b-41d4-a716-446655440054', E'\\x38313132333435363832', E'\\x6361726c6f732e6d6f72656e6f40656d61696c2e636f6d', E'\\x4c75697361204d6f72656e6f', E'\\x3831313938373635343336', 'kms-key-001', '2024-02-05 16:00:00-06'),
('550e8400-e29b-41d4-a716-446655440205', E'\\x5061747269636961', E'\\x566172676173', E'\\x4d617274696e657a', E'\\x56414d50383830353235354d444c52523030', '550e8400-e29b-41d4-a716-446655440055', E'\\x38313132333435363833', E'\\x70617472696369612e76617267617340656d61696c2e636f6d', E'\\x4a6f72676520566172676173', E'\\x3831313938373635343337', 'kms-key-001', '2024-02-06 10:00:00-06');

-- ============================================================================
-- CLINICAL CODES (ICD-10, SNOMED, etc.)
-- ============================================================================
INSERT INTO public.clinical_codes (id, code, system, display) VALUES
-- Conditions
('550e8400-e29b-41d4-a716-446655440300', 'E11.9', 'ICD-10', 'Diabetes mellitus tipo 2 sin complicaciones'),
('550e8400-e29b-41d4-a716-446655440301', 'I10', 'ICD-10', 'Hipertensión esencial'),
('550e8400-e29b-41d4-a716-446655440302', 'J06.9', 'ICD-10', 'Infección aguda de las vías respiratorias superiores'),
('550e8400-e29b-41d4-a716-446655440303', 'K21.9', 'ICD-10', 'Enfermedad por reflujo gastroesofágico'),
('550e8400-e29b-41d4-a716-446655440304', 'M79.3', 'ICD-10', 'Paniculitis'),
-- Allergies
('550e8400-e29b-41d4-a716-446655440305', '293586005', 'SNOMED-CT', 'Alergia a penicilina'),
('550e8400-e29b-41d4-a716-446655440306', '293589003', 'SNOMED-CT', 'Alergia a sulfonamidas'),
('550e8400-e29b-41d4-a716-446655440307', '762952008', 'SNOMED-CT', 'Alergia a polen'),
('550e8400-e29b-41d4-a716-446655440308', '762953003', 'SNOMED-CT', 'Alergia a ácaros del polvo'),
-- Medications
('550e8400-e29b-41d4-a716-446655440309', '6809', 'NOM-177-SSA1-2013', 'Metformina 500mg'),
('550e8400-e29b-41d4-a716-446655440310', '6810', 'NOM-177-SSA1-2013', 'Losartán 50mg'),
('550e8400-e29b-41d4-a716-446655440311', '6811', 'NOM-177-SSA1-2013', 'Amoxicilina 500mg'),
('550e8400-e29b-41d4-a716-446655440312', '6812', 'NOM-177-SSA1-2013', 'Omeprazol 20mg'),
('550e8400-e29b-41d4-a716-446655440313', '6813', 'NOM-177-SSA1-2013', 'Ibuprofeno 400mg'),
('550e8400-e29b-41d4-a716-446655440314', '6814', 'NOM-177-SSA1-2013', 'Paracetamol 500mg'),
-- Procedures
('550e8400-e29b-41d4-a716-446655440315', '2335F', 'CPT', 'Hemoglobina glicosilada'),
('550e8400-e29b-41d4-a716-446655440316', '80053', 'CPT', 'Panel metabólico completo'),
('550e8400-e29b-41d4-a716-446655440317', '85025', 'CPT', 'Hemograma completo');

-- ============================================================================
-- MEDS DICTIONARY
-- ============================================================================
INSERT INTO public.meds_dictionary (id, code, system, name) VALUES
('550e8400-e29b-41d4-a716-446655440400', '6809', 'NOM-177-SSA1-2013', 'Metformina'),
('550e8400-e29b-41d4-a716-446655440401', '6810', 'NOM-177-SSA1-2013', 'Losartán'),
('550e8400-e29b-41d4-a716-446655440402', '6811', 'NOM-177-SSA1-2013', 'Amoxicilina'),
('550e8400-e29b-41d4-a716-446655440403', '6812', 'NOM-177-SSA1-2013', 'Omeprazol'),
('550e8400-e29b-41d4-a716-446655440404', '6813', 'NOM-177-SSA1-2013', 'Ibuprofeno'),
('550e8400-e29b-41d4-a716-446655440405', '6814', 'NOM-177-SSA1-2013', 'Paracetamol'),
('550e8400-e29b-41d4-a716-446655440406', '6815', 'NOM-177-SSA1-2013', 'Atorvastatina'),
('550e8400-e29b-41d4-a716-446655440407', '6816', 'NOM-177-SSA1-2013', 'Amlodipino'),
('550e8400-e29b-41d4-a716-446655440408', '6817', 'NOM-177-SSA1-2013', 'Loratadina');

-- ============================================================================
-- MEDS SYNONYMS
-- ============================================================================
INSERT INTO public.meds_synonyms (synonym, med_id) VALUES
('Metformina', '550e8400-e29b-41d4-a716-446655440400'),
('Glucophage', '550e8400-e29b-41d4-a716-446655440400'),
('Losartán', '550e8400-e29b-41d4-a716-446655440401'),
('Cozaar', '550e8400-e29b-41d4-a716-446655440401'),
('Amoxicilina', '550e8400-e29b-41d4-a716-446655440402'),
('Omeprazol', '550e8400-e29b-41d4-a716-446655440403'),
('Losec', '550e8400-e29b-41d4-a716-446655440403'),
('Ibuprofeno', '550e8400-e29b-41d4-a716-446655440404'),
('Advil', '550e8400-e29b-41d4-a716-446655440404'),
('Paracetamol', '550e8400-e29b-41d4-a716-446655440405'),
('Tylenol', '550e8400-e29b-41d4-a716-446655440405'),
('Acetaminofén', '550e8400-e29b-41d4-a716-446655440405')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- DRUG INTERACTIONS
-- ============================================================================
INSERT INTO public.drug_interactions (a_med_id, b_med_id, severity, mechanism, action) VALUES
('550e8400-e29b-41d4-a716-446655440400', '550e8400-e29b-41d4-a716-446655440401', 'moderate', 'Puede aumentar el riesgo de hipoglucemia', 'Monitorear niveles de glucosa'),
('550e8400-e29b-41d4-a716-446655440404', '550e8400-e29b-41d4-a716-446655440405', 'mild', 'Ambos son analgésicos, puede causar sobredosis', 'Evitar uso simultáneo'),
('550e8400-e29b-41d4-a716-446655440401', '550e8400-e29b-41d4-a716-446655440407', 'moderate', 'Ambos son antihipertensivos, puede causar hipotensión', 'Ajustar dosis');

-- ============================================================================
-- CLINICAL HISTORIES
-- ============================================================================
INSERT INTO public.clinical_histories (id, patient_id, status, opened_at, closed_at, created_by, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440500', '550e8400-e29b-41d4-a716-446655440200', 'active', '2024-02-01 10:30:00-06', NULL, '550e8400-e29b-41d4-a716-446655440101', '2024-02-01 10:30:00-06'),
('550e8400-e29b-41d4-a716-446655440501', '550e8400-e29b-41d4-a716-446655440201', 'active', '2024-02-02 11:15:00-06', NULL, '550e8400-e29b-41d4-a716-446655440102', '2024-02-02 11:15:00-06'),
('550e8400-e29b-41d4-a716-446655440502', '550e8400-e29b-41d4-a716-446655440202', 'active', '2024-02-03 09:45:00-06', NULL, '550e8400-e29b-41d4-a716-446655440101', '2024-02-03 09:45:00-06'),
('550e8400-e29b-41d4-a716-446655440503', '550e8400-e29b-41d4-a716-446655440203', 'active', '2024-02-04 14:20:00-06', NULL, '550e8400-e29b-41d4-a716-446655440102', '2024-02-04 14:20:00-06'),
('550e8400-e29b-41d4-a716-446655440504', '550e8400-e29b-41d4-a716-446655440204', 'active', '2024-02-05 16:00:00-06', NULL, '550e8400-e29b-41d4-a716-446655440103', '2024-02-05 16:00:00-06'),
('550e8400-e29b-41d4-a716-446655440505', '550e8400-e29b-41d4-a716-446655440205', 'active', '2024-02-06 10:00:00-06', NULL, '550e8400-e29b-41d4-a716-446655440101', '2024-02-06 10:00:00-06');

-- ============================================================================
-- PATIENT ALLERGIES
-- ============================================================================
INSERT INTO public.patient_allergies (id, clinical_history_id, substance_code_id, reaction, severity, criticality, status, first_onset, last_occurrence, note, recorded_at, recorded_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440600', '550e8400-e29b-41d4-a716-446655440500', '550e8400-e29b-41d4-a716-446655440305', 'Urticaria y dificultad respiratoria', 'severe', 'high', 'active', '2010-05-15', '2020-03-10', 'Reacción alérgica severa a penicilina', '2024-02-01 10:35:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440601', '550e8400-e29b-41d4-a716-446655440501', '550e8400-e29b-41d4-a716-446655440307', 'Rinitis y conjuntivitis', 'moderate', 'medium', 'active', '2015-08-20', '2024-02-01', 'Alergia estacional al polen', '2024-02-02 11:20:00-06', '550e8400-e29b-41d4-a716-446655440102', NULL, NULL);

-- ============================================================================
-- PATIENT CONDITIONS
-- ============================================================================
INSERT INTO public.patient_conditions (id, clinical_history_id, code_id, onset_date, abatement_date, verification_status, note, recorded_at, recorded_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440700', '550e8400-e29b-41d4-a716-446655440500', '550e8400-e29b-41d4-a716-446655440300', '2020-01-15', NULL, 'confirmed', 'Diabetes tipo 2 diagnosticada, controlada con metformina', '2024-02-01 10:40:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440701', '550e8400-e29b-41d4-a716-446655440501', '550e8400-e29b-41d4-a716-446655440301', '2018-06-10', NULL, 'confirmed', 'Hipertensión controlada con losartán', '2024-02-02 11:25:00-06', '550e8400-e29b-41d4-a716-446655440102', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440702', '550e8400-e29b-41d4-a716-446655440502', '550e8400-e29b-41d4-a716-446655440303', '2023-11-05', NULL, 'confirmed', 'Reflujo gastroesofágico tratado con omeprazol', '2024-02-03 09:50:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL);

-- ============================================================================
-- PATIENT MEDICATIONS
-- ============================================================================
INSERT INTO public.patient_medications (id, clinical_history_id, medication_code_id, dose, route, frequency, start_date, end_date, medication_status, prescriber_id, source, note, recorded_at, recorded_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440800', '550e8400-e29b-41d4-a716-446655440500', '550e8400-e29b-41d4-a716-446655440309', '500mg', 'oral', 'Cada 12 horas con alimentos', '2024-01-15', NULL, 'active', '550e8400-e29b-41d4-a716-446655440101', 'prescription', 'Metformina para control de diabetes', '2024-02-01 10:45:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440801', '550e8400-e29b-41d4-a716-446655440501', '550e8400-e29b-41d4-a716-446655440310', '50mg', 'oral', 'Una vez al día en la mañana', '2024-01-20', NULL, 'active', '550e8400-e29b-41d4-a716-446655440102', 'prescription', 'Losartán para hipertensión', '2024-02-02 11:30:00-06', '550e8400-e29b-41d4-a716-446655440102', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440802', '550e8400-e29b-41d4-a716-446655440502', '550e8400-e29b-41d4-a716-446655440312', '20mg', 'oral', 'Una vez al día antes del desayuno', '2023-11-10', NULL, 'active', '550e8400-e29b-41d4-a716-446655440101', 'prescription', 'Omeprazol para reflujo', '2024-02-03 09:55:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL);

-- ============================================================================
-- FAMILY HISTORY
-- ============================================================================
INSERT INTO public.family_history (id, clinical_history_id, relationship_type, condition_code_id, note, verification_status, relative_age_of_consent, relative_is_deceased, recorded_at, recorded_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440900', '550e8400-e29b-41d4-a716-446655440500', 'mother', '550e8400-e29b-41d4-a716-446655440300', 'Madre con diabetes tipo 2', 'confirmed', 65, false, '2024-02-01 10:50:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL),
('550e8400-e29b-41d4-a716-446655440901', '550e8400-e29b-41d4-a716-446655440501', 'father', '550e8400-e29b-41d4-a716-446655440301', 'Padre con hipertensión', 'confirmed', 70, false, '2024-02-02 11:35:00-06', '550e8400-e29b-41d4-a716-446655440102', NULL, NULL);

-- ============================================================================
-- APPOINTMENTS
-- ============================================================================
INSERT INTO public.appointments (id, patients_id, medico_id, fecha_hora, motivo, status, created_at, updated_at, created_by) VALUES
('550e8400-e29b-41d4-a716-446655441000', '550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655440101', '2024-02-10 09:00:00-06', 'Control de diabetes', 'scheduled', '2024-02-01 10:30:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655441001', '550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440102', '2024-02-11 10:30:00-06', 'Control de hipertensión', 'scheduled', '2024-02-02 11:15:00-06', NULL, '550e8400-e29b-41d4-a716-446655440104'),
('550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440101', '2024-02-12 11:00:00-06', 'Consulta general', 'scheduled', '2024-02-03 09:45:00-06', NULL, '550e8400-e29b-41d4-a716-446655440105'),
('550e8400-e29b-41d4-a716-446655441003', '550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440102', '2024-02-08 14:00:00-06', 'Resfriado', 'completed', '2024-02-04 14:20:00-06', '2024-02-08 14:30:00-06', '550e8400-e29b-41d4-a716-446655440105'),
('550e8400-e29b-41d4-a716-446655441004', '550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655440103', '2024-02-09 15:30:00-06', 'Dolor de cabeza', 'completed', '2024-02-05 16:00:00-06', '2024-02-09 15:45:00-06', '550e8400-e29b-41d4-a716-446655440104');

-- ============================================================================
-- CONSULTATIONS
-- ============================================================================
INSERT INTO public.consultations (id, patient_id, author_id, motivo, diagnostico, indicaciones, prescripciones_json, signed, signature_hash, created_at, signed_at, created_by) VALUES
('550e8400-e29b-41d4-a716-446655441100', '550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440102', 'Resfriado con fiebre y tos', 'Infección aguda de las vías respiratorias superiores', 'Reposo, hidratación adecuada, tomar medicamento según prescripción', '{"medications": [{"name": "Paracetamol", "dose": "500mg", "frequency": "Cada 8 horas"}]}', true, 'hash_signature_001', '2024-02-08 14:00:00-06', '2024-02-08 14:25:00-06', '550e8400-e29b-41d4-a716-446655440102'),
('550e8400-e29b-41d4-a716-446655441101', '550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655440103', 'Dolor de cabeza intenso', 'Cefalea tensional', 'Evitar estrés, aplicar compresas frías, tomar medicamento según prescripción', '{"medications": [{"name": "Ibuprofeno", "dose": "400mg", "frequency": "Cada 8 horas por 3 días"}]}', true, 'hash_signature_002', '2024-02-09 15:30:00-06', '2024-02-09 15:40:00-06', '550e8400-e29b-41d4-a716-446655440103');

-- ============================================================================
-- PRESCRIPTIONS
-- ============================================================================
INSERT INTO public.prescriptions (id, prescription_code, patient_id, consultation_id, prescription_json, prescription_pdf_ref, signed_by, signed_at, created_at) VALUES
('550e8400-e29b-41d4-a716-446655441200', 'RX-2024-001', '550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655441100', '{"items": [{"medication": "Paracetamol 500mg", "quantity": 20, "instructions": "Tomar cada 8 horas"}]}', '/prescriptions/RX-2024-001.pdf', '550e8400-e29b-41d4-a716-446655440102', '2024-02-08 14:25:00-06', '2024-02-08 14:25:00-06'),
('550e8400-e29b-41d4-a716-446655441201', 'RX-2024-002', '550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655441101', '{"items": [{"medication": "Ibuprofeno 400mg", "quantity": 9, "instructions": "Tomar cada 8 horas por 3 días"}]}', '/prescriptions/RX-2024-002.pdf', '550e8400-e29b-41d4-a716-446655440103', '2024-02-09 15:40:00-06', '2024-02-09 15:40:00-06');

-- ============================================================================
-- PRESCRIPTION ITEMS
-- ============================================================================
INSERT INTO public.prescription_items (id, prescription_id, medication_name, dose, form, frequency, duration, observations) VALUES
('550e8400-e29b-41d4-a716-446655441300', '550e8400-e29b-41d4-a716-446655441200', 'Paracetamol', '500mg', 'Tableta', 'Cada 8 horas', '5 días', 'Tomar con alimentos si causa molestias estomacales'),
('550e8400-e29b-41d4-a716-446655441301', '550e8400-e29b-41d4-a716-446655441201', 'Ibuprofeno', '400mg', 'Tableta', 'Cada 8 horas', '3 días', 'No exceder la dosis recomendada');

-- ============================================================================
-- RX ITEM DRUG MAP
-- ============================================================================
INSERT INTO public.rx_item_drug_map (prescription_item_id, med_id, matched_synonym, matched_at) VALUES
('550e8400-e29b-41d4-a716-446655441300', '550e8400-e29b-41d4-a716-446655440405', 'Paracetamol', '2024-02-08 14:26:00-06'),
('550e8400-e29b-41d4-a716-446655441301', '550e8400-e29b-41d4-a716-446655440404', 'Ibuprofeno', '2024-02-09 15:41:00-06');

-- ============================================================================
-- DISPENSATIONS
-- ============================================================================
INSERT INTO public.dispensations (id, prescription_id, pharmacist_id, branch_id, "timestamp", status, created_by) VALUES
('550e8400-e29b-41d4-a716-446655441400', '550e8400-e29b-41d4-a716-446655441200', '550e8400-e29b-41d4-a716-446655440106', NULL, '2024-02-08 16:00:00-06', 'dispensed', '550e8400-e29b-41d4-a716-446655440106'),
('550e8400-e29b-41d4-a716-446655441401', '550e8400-e29b-41d4-a716-446655441201', '550e8400-e29b-41d4-a716-446655440107', NULL, '2024-02-09 17:00:00-06', 'dispensed', '550e8400-e29b-41d4-a716-446655440107');

-- ============================================================================
-- PATIENT CONTACTS
-- ============================================================================
INSERT INTO public.patient_contacts (id, patient_id, type, name_enc, phone_enc, created_at) VALUES
('550e8400-e29b-41d4-a716-446655441500', '550e8400-e29b-41d4-a716-446655440200', 'emergency', E'\\x4d6172696120506572657a', E'\\x3831313938373635343332', '2024-02-01 10:30:00-06'),
('550e8400-e29b-41d4-a716-446655441501', '550e8400-e29b-41d4-a716-446655440201', 'emergency', E'\\x4361726c6f7320526f6472696775657a', E'\\x3831313938373635343333', '2024-02-02 11:15:00-06');

-- ============================================================================
-- PATIENT PROCEDURES
-- ============================================================================
INSERT INTO public.patient_procedures (id, clinical_history_id, procedure_code_id, performed_on, facility, note, recorded_at, recorded_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655441600', '550e8400-e29b-41d4-a716-446655440500', '550e8400-e29b-41d4-a716-446655440315', '2024-01-20', 'Laboratorio Clínico Monterrey', 'HbA1c: 7.2%', '2024-02-01 10:55:00-06', '550e8400-e29b-41d4-a716-446655440101', NULL, NULL),
('550e8400-e29b-41d4-a716-446655441601', '550e8400-e29b-41d4-a716-446655440501', '550e8400-e29b-41d4-a716-446655440316', '2024-01-25', 'Laboratorio Clínico Guadalajara', 'Panel metabólico dentro de parámetros normales', '2024-02-02 11:40:00-06', '550e8400-e29b-41d4-a716-446655440102', NULL, NULL);

-- ============================================================================
-- STUDIES
-- ============================================================================
INSERT INTO public.studies (patient_id, id, file_ref, file_type, checksum, metadata, uploaded_by, uploaded_at) VALUES
('550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655441700', '/studies/patient_200/lab_20240120.pdf', 'application/pdf', 'sha256:abc123def456', '{"type": "laboratory", "date": "2024-01-20"}', '550e8400-e29b-41d4-a716-446655440101', '2024-02-01 11:00:00-06'),
('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655441701', '/studies/patient_201/xray_20240125.jpg', 'image/jpeg', 'sha256:def456ghi789', '{"type": "radiology", "date": "2024-01-25"}', '550e8400-e29b-41d4-a716-446655440102', '2024-02-02 11:45:00-06');

-- ============================================================================
-- PATIENT ALERTS
-- ============================================================================
INSERT INTO public.patient_alerts (id, alert_type, severity, score, source, payload, created_at, created_by, patient_id) VALUES
('550e8400-e29b-41d4-a716-446655441800', 'drug_interaction', 'moderate', 0.65, 'system', '{"medication1": "Metformina", "medication2": "Losartán", "interaction": "Puede aumentar riesgo de hipoglucemia"}', '2024-02-01 10:50:00-06', '550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440200'),
('550e8400-e29b-41d4-a716-446655441801', 'allergy_warning', 'high', 0.90, 'system', '{"allergen": "Penicilina", "prescription": "RX-2024-001"}', '2024-02-08 14:20:00-06', '550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440203');

-- ============================================================================
-- AUDIT LOGS
-- ============================================================================
INSERT INTO public.audit_logs (id, actor_id, action, resource_type, resource_id, "timestamp", ip, result, extra, integrity_hash, previous_hash) VALUES
('550e8400-e29b-41d4-a716-446655441900', '550e8400-e29b-41d4-a716-446655440101', 'create', 'consultation', '550e8400-e29b-41d4-a716-446655441100', '2024-02-08 14:00:00-06', '192.168.1.100', 'success', '{"patient_id": "550e8400-e29b-41d4-a716-446655440203"}', 'hash_001', NULL),
('550e8400-e29b-41d4-a716-446655441901', '550e8400-e29b-41d4-a716-446655440106', 'dispense', 'prescription', '550e8400-e29b-41d4-a716-446655441200', '2024-02-08 16:00:00-06', '192.168.1.101', 'success', '{"prescription_id": "550e8400-e29b-41d4-a716-446655441200"}', 'hash_002', 'hash_001');

-- Re-enable foreign key checks
SET session_replication_role = 'origin';

-- ============================================================================
-- END OF DUMMY DATA
-- ============================================================================

