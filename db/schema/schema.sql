--
-- PostgreSQL database dump
--

\restrict x7B7GgucG9XrBchQVIh9KeChcUQCdSY1GlnmlsUED1tayWLvWW23nKcHg1Ei6L0

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-21 13:55:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 16768)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    id_address uuid NOT NULL,
    street_number integer NOT NULL,
    street_number_norm character varying(255) NOT NULL,
    street_name character varying(255) NOT NULL,
    street_name_norm character varying(255) NOT NULL,
    id_postal_code uuid NOT NULL,
    id_neighborhood uuid NOT NULL
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16825)
-- Name: admin_subdivisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_subdivisions (
    id_area uuid NOT NULL,
    id_country uuid NOT NULL,
    iso_code character varying(10) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.admin_subdivisions OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16461)
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id uuid NOT NULL,
    patients_id uuid,
    medico_id uuid,
    fecha_hora timestamp with time zone,
    motivo character varying(500),
    status character varying(50),
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    created_by uuid
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16448)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid NOT NULL,
    actor_id uuid,
    action character varying(100),
    resource_type character varying(100),
    resource_id character varying(255),
    "timestamp" timestamp with time zone,
    ip inet,
    result character varying(100),
    extra jsonb,
    integrity_hash character varying(255),
    previous_hash character varying(255)
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16815)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id_city uuid NOT NULL,
    id_area uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16902)
-- Name: clinical_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clinical_codes (
    id uuid NOT NULL,
    code character varying(100) NOT NULL,
    system character varying(100) NOT NULL,
    display character varying(255) NOT NULL
);


ALTER TABLE public.clinical_codes OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16913)
-- Name: clinical_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clinical_histories (
    id uuid NOT NULL,
    patient_id uuid NOT NULL,
    status character varying(50) NOT NULL,
    opened_at timestamp with time zone NOT NULL,
    closed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.clinical_histories OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16494)
-- Name: consultations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consultations (
    id uuid NOT NULL,
    patient_id uuid,
    author_id uuid,
    motivo character varying(500),
    diagnostico character varying(1000),
    indicaciones character varying(2000),
    prescripciones_json jsonb,
    signed boolean,
    signature_hash character varying(255),
    created_at timestamp with time zone,
    signed_at timestamp with time zone,
    created_by uuid
);


ALTER TABLE public.consultations OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16788)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id_country uuid NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16691)
-- Name: dispensations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dispensations (
    id uuid NOT NULL,
    prescription_id uuid,
    pharmacist_id uuid,
    branch_id uuid,
    "timestamp" timestamp with time zone,
    status character varying(50),
    created_by uuid
);


ALTER TABLE public.dispensations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16646)
-- Name: drug_interactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drug_interactions (
    a_med_id uuid,
    b_med_id uuid,
    severity character varying(50) NOT NULL,
    mechanism character varying(500),
    action character varying(500)
);


ALTER TABLE public.drug_interactions OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16952)
-- Name: family_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.family_history (
    id uuid NOT NULL,
    clinical_history_id uuid NOT NULL,
    relationship_type character varying(50) NOT NULL,
    condition_code_id uuid,
    note character varying(2000),
    verification_status character varying(50) NOT NULL,
    relative_age_of_consent integer,
    relative_is_deceased boolean,
    recorded_at timestamp with time zone NOT NULL,
    recorded_by uuid,
    updated_at timestamp with time zone,
    updated_by uuid
);


ALTER TABLE public.family_history OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16635)
-- Name: meds_dictionary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meds_dictionary (
    id uuid NOT NULL,
    code character varying(100) NOT NULL,
    system character varying(100) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.meds_dictionary OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16662)
-- Name: meds_synonyms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meds_synonyms (
    synonym character varying(255) NOT NULL,
    med_id uuid
);


ALTER TABLE public.meds_synonyms OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16882)
-- Name: neighborhoods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.neighborhoods (
    id_neighborhood uuid NOT NULL,
    id_city uuid NOT NULL,
    name character varying(255)
);


ALTER TABLE public.neighborhoods OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16409)
-- Name: patient_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_alerts (
    id uuid NOT NULL,
    alert_type character varying(100),
    severity character varying(50),
    score numeric,
    source character varying(255),
    payload jsonb,
    created_at timestamp with time zone,
    created_by uuid,
    patient_id uuid
);


ALTER TABLE public.patient_alerts OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17049)
-- Name: patient_allergies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_allergies (
    id uuid NOT NULL,
    clinical_history_id uuid,
    substance_code_id uuid,
    reaction character varying(500),
    severity character varying(50),
    criticality character varying(50),
    status character varying(50),
    first_onset date,
    last_occurrence date,
    note character varying(2000),
    recorded_at timestamp with time zone NOT NULL,
    recorded_by uuid,
    updated_at timestamp with time zone,
    updated_by uuid
);


ALTER TABLE public.patient_allergies OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17078)
-- Name: patient_conditions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_conditions (
    id uuid NOT NULL,
    clinical_history_id uuid,
    code_id uuid,
    onset_date date,
    abatement_date date,
    verification_status character varying(50) NOT NULL,
    note character varying(2000),
    recorded_at timestamp with time zone NOT NULL,
    recorded_by uuid,
    updated_at timestamp with time zone,
    updated_by uuid
);


ALTER TABLE public.patient_conditions OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16714)
-- Name: patient_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_contacts (
    id uuid NOT NULL,
    patient_id uuid,
    type character varying(50),
    name_enc bytea,
    phone_enc bytea,
    created_at timestamp with time zone
);


ALTER TABLE public.patient_contacts OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16984)
-- Name: patient_medications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_medications (
    id uuid NOT NULL,
    clinical_history_id uuid NOT NULL,
    medication_code_id uuid,
    dose character varying(100),
    route character varying(100),
    frequency character varying(100),
    start_date date,
    end_date date,
    medication_status character varying(50) NOT NULL,
    prescriber_id uuid,
    source character varying(255),
    note character varying(2000),
    recorded_at timestamp with time zone NOT NULL,
    recorded_by uuid,
    updated_at timestamp with time zone,
    updated_by uuid
);


ALTER TABLE public.patient_medications OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16746)
-- Name: patient_pii; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_pii (
    patient_id uuid NOT NULL,
    first_name_enc bytea,
    first_surname_enc bytea,
    second_surname_enc bytea,
    curp_enc bytea,
    address_id uuid,
    phone_enc bytea,
    email_enc bytea,
    contact_emergency_name_enc bytea,
    contact_emergency_phone_enc bytea,
    kms_key_id character varying(255),
    created_at timestamp with time zone
);


ALTER TABLE public.patient_pii OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17020)
-- Name: patient_procedures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_procedures (
    id uuid NOT NULL,
    clinical_history_id uuid,
    procedure_code_id uuid,
    performed_on date,
    facility character varying(255),
    note character varying(2000),
    recorded_at timestamp with time zone NOT NULL,
    recorded_by uuid,
    updated_at timestamp with time zone,
    updated_by uuid
);


ALTER TABLE public.patient_procedures OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16422)
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    id uuid NOT NULL,
    curp_hash character varying(255) NOT NULL,
    date_of_birth date,
    gender character varying(20),
    created_at timestamp with time zone,
    updated_by uuid,
    created_by uuid
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16560)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000)
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16800)
-- Name: postal_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.postal_codes (
    id_postal_codes uuid NOT NULL,
    id_country uuid NOT NULL,
    code character varying(20) NOT NULL
);


ALTER TABLE public.postal_codes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16608)
-- Name: prescription_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prescription_items (
    id uuid NOT NULL,
    prescription_id uuid,
    medication_name character varying(255),
    dose character varying(100),
    form character varying(100),
    frequency character varying(100),
    duration character varying(100),
    observations character varying(2000)
);


ALTER TABLE public.prescription_items OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16582)
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prescriptions (
    id uuid NOT NULL,
    prescription_code character varying(100) NOT NULL,
    patient_id uuid,
    consultation_id uuid,
    prescription_json jsonb,
    prescription_pdf_ref character varying(500),
    signed_by uuid,
    signed_at timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.prescriptions OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16571)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16529)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16621)
-- Name: rx_item_drug_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rx_item_drug_map (
    prescription_item_id uuid NOT NULL,
    med_id uuid,
    matched_synonym character varying(255),
    matched_at timestamp with time zone NOT NULL
);


ALTER TABLE public.rx_item_drug_map OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16727)
-- Name: studies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studies (
    patient_id uuid NOT NULL,
    id uuid NOT NULL,
    file_ref character varying(500),
    file_type character varying(100),
    checksum character varying(255),
    metadata jsonb,
    uploaded_by uuid,
    uploaded_at timestamp with time zone
);


ALTER TABLE public.studies OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16517)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    role_id uuid NOT NULL,
    user_id uuid NOT NULL,
    assigned_at timestamp with time zone,
    assigned_by uuid
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16390)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255),
    email character varying(255) NOT NULL,
    mfa_enabled boolean,
    display_name character varying(255),
    created_at timestamp with time zone,
    created_by uuid
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5304 (class 0 OID 16768)
-- Dependencies: 239
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (id_address, street_number, street_number_norm, street_name, street_name_norm, id_postal_code, id_neighborhood) FROM stdin;
\.


--
-- TOC entry 5308 (class 0 OID 16825)
-- Dependencies: 243
-- Data for Name: admin_subdivisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_subdivisions (id_area, id_country, iso_code, name) FROM stdin;
\.


--
-- TOC entry 5288 (class 0 OID 16461)
-- Dependencies: 223
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, patients_id, medico_id, fecha_hora, motivo, status, created_at, updated_at, created_by) FROM stdin;
\.


--
-- TOC entry 5287 (class 0 OID 16448)
-- Dependencies: 222
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, actor_id, action, resource_type, resource_id, "timestamp", ip, result, extra, integrity_hash, previous_hash) FROM stdin;
\.


--
-- TOC entry 5307 (class 0 OID 16815)
-- Dependencies: 242
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id_city, id_area, name) FROM stdin;
\.


--
-- TOC entry 5310 (class 0 OID 16902)
-- Dependencies: 245
-- Data for Name: clinical_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clinical_codes (id, code, system, display) FROM stdin;
\.


--
-- TOC entry 5311 (class 0 OID 16913)
-- Dependencies: 246
-- Data for Name: clinical_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clinical_histories (id, patient_id, status, opened_at, closed_at, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5289 (class 0 OID 16494)
-- Dependencies: 224
-- Data for Name: consultations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consultations (id, patient_id, author_id, motivo, diagnostico, indicaciones, prescripciones_json, signed, signature_hash, created_at, signed_at, created_by) FROM stdin;
\.


--
-- TOC entry 5305 (class 0 OID 16788)
-- Dependencies: 240
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id_country, iso_code, name) FROM stdin;
\.


--
-- TOC entry 5300 (class 0 OID 16691)
-- Dependencies: 235
-- Data for Name: dispensations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dispensations (id, prescription_id, pharmacist_id, branch_id, "timestamp", status, created_by) FROM stdin;
\.


--
-- TOC entry 5298 (class 0 OID 16646)
-- Dependencies: 233
-- Data for Name: drug_interactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drug_interactions (a_med_id, b_med_id, severity, mechanism, action) FROM stdin;
\.


--
-- TOC entry 5312 (class 0 OID 16952)
-- Dependencies: 247
-- Data for Name: family_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.family_history (id, clinical_history_id, relationship_type, condition_code_id, note, verification_status, relative_age_of_consent, relative_is_deceased, recorded_at, recorded_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 5297 (class 0 OID 16635)
-- Dependencies: 232
-- Data for Name: meds_dictionary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meds_dictionary (id, code, system, name) FROM stdin;
\.


--
-- TOC entry 5299 (class 0 OID 16662)
-- Dependencies: 234
-- Data for Name: meds_synonyms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meds_synonyms (synonym, med_id) FROM stdin;
\.


--
-- TOC entry 5309 (class 0 OID 16882)
-- Dependencies: 244
-- Data for Name: neighborhoods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.neighborhoods (id_neighborhood, id_city, name) FROM stdin;
\.


--
-- TOC entry 5285 (class 0 OID 16409)
-- Dependencies: 220
-- Data for Name: patient_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_alerts (id, alert_type, severity, score, source, payload, created_at, created_by, patient_id) FROM stdin;
\.


--
-- TOC entry 5315 (class 0 OID 17049)
-- Dependencies: 250
-- Data for Name: patient_allergies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_allergies (id, clinical_history_id, substance_code_id, reaction, severity, criticality, status, first_onset, last_occurrence, note, recorded_at, recorded_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 5316 (class 0 OID 17078)
-- Dependencies: 251
-- Data for Name: patient_conditions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_conditions (id, clinical_history_id, code_id, onset_date, abatement_date, verification_status, note, recorded_at, recorded_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 5301 (class 0 OID 16714)
-- Dependencies: 236
-- Data for Name: patient_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_contacts (id, patient_id, type, name_enc, phone_enc, created_at) FROM stdin;
\.


--
-- TOC entry 5313 (class 0 OID 16984)
-- Dependencies: 248
-- Data for Name: patient_medications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_medications (id, clinical_history_id, medication_code_id, dose, route, frequency, start_date, end_date, medication_status, prescriber_id, source, note, recorded_at, recorded_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 5303 (class 0 OID 16746)
-- Dependencies: 238
-- Data for Name: patient_pii; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_pii (patient_id, first_name_enc, first_surname_enc, second_surname_enc, curp_enc, address_id, phone_enc, email_enc, contact_emergency_name_enc, contact_emergency_phone_enc, kms_key_id, created_at) FROM stdin;
\.


--
-- TOC entry 5314 (class 0 OID 17020)
-- Dependencies: 249
-- Data for Name: patient_procedures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_procedures (id, clinical_history_id, procedure_code_id, performed_on, facility, note, recorded_at, recorded_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 5286 (class 0 OID 16422)
-- Dependencies: 221
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (id, curp_hash, date_of_birth, gender, created_at, updated_by, created_by) FROM stdin;
\.


--
-- TOC entry 5292 (class 0 OID 16560)
-- Dependencies: 227
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description) FROM stdin;
\.


--
-- TOC entry 5306 (class 0 OID 16800)
-- Dependencies: 241
-- Data for Name: postal_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.postal_codes (id_postal_codes, id_country, code) FROM stdin;
\.


--
-- TOC entry 5295 (class 0 OID 16608)
-- Dependencies: 230
-- Data for Name: prescription_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prescription_items (id, prescription_id, medication_name, dose, form, frequency, duration, observations) FROM stdin;
\.


--
-- TOC entry 5294 (class 0 OID 16582)
-- Dependencies: 229
-- Data for Name: prescriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prescriptions (id, prescription_code, patient_id, consultation_id, prescription_json, prescription_pdf_ref, signed_by, signed_at, created_at) FROM stdin;
\.


--
-- TOC entry 5293 (class 0 OID 16571)
-- Dependencies: 228
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5291 (class 0 OID 16529)
-- Dependencies: 226
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description) FROM stdin;
\.


--
-- TOC entry 5296 (class 0 OID 16621)
-- Dependencies: 231
-- Data for Name: rx_item_drug_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rx_item_drug_map (prescription_item_id, med_id, matched_synonym, matched_at) FROM stdin;
\.


--
-- TOC entry 5302 (class 0 OID 16727)
-- Dependencies: 237
-- Data for Name: studies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studies (patient_id, id, file_ref, file_type, checksum, metadata, uploaded_by, uploaded_at) FROM stdin;
\.


--
-- TOC entry 5290 (class 0 OID 16517)
-- Dependencies: 225
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (role_id, user_id, assigned_at, assigned_by) FROM stdin;
\.


--
-- TOC entry 5284 (class 0 OID 16390)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password_hash, email, mfa_enabled, display_name, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 5038 (class 2606 OID 16781)
-- Name: addresses addresses_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pk PRIMARY KEY (id_address);


--
-- TOC entry 5040 (class 2606 OID 16870)
-- Name: addresses addresses_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_unique UNIQUE (street_number_norm, street_name_norm);


--
-- TOC entry 5042 (class 2606 OID 16874)
-- Name: addresses addresses_unique_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_unique_1 UNIQUE (id_neighborhood);




--
-- TOC entry 5054 (class 2606 OID 16835)
-- Name: admin_subdivisions admin_subdivisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_subdivisions
    ADD CONSTRAINT admin_subdivisions_pk PRIMARY KEY (id_area);


--
-- TOC entry 5056 (class 2606 OID 16837)
-- Name: admin_subdivisions admin_subdivisions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_subdivisions
    ADD CONSTRAINT admin_subdivisions_unique UNIQUE (iso_code);


--
-- TOC entry 5058 (class 2606 OID 16839)
-- Name: admin_subdivisions admin_subdivisions_unique_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_subdivisions
    ADD CONSTRAINT admin_subdivisions_unique_1 UNIQUE (name);


--
-- TOC entry 4998 (class 2606 OID 16466)
-- Name: appointments appointments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pk PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 16453)
-- Name: audit_logs audit_logs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pk PRIMARY KEY (id);


--
-- TOC entry 5052 (class 2606 OID 16824)
-- Name: cities cities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pk PRIMARY KEY (id_city);


--
-- TOC entry 5062 (class 2606 OID 16912)
-- Name: clinical_codes clinical_codes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinical_codes
    ADD CONSTRAINT clinical_codes_pk PRIMARY KEY (id);


--
-- TOC entry 5064 (class 2606 OID 16924)
-- Name: clinical_histories clinical_histories_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinical_histories
    ADD CONSTRAINT clinical_histories_pk PRIMARY KEY (id);


--
-- TOC entry 5000 (class 2606 OID 16501)
-- Name: consultations consultations_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_pk PRIMARY KEY (id);


--
-- TOC entry 5046 (class 2606 OID 16797)
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id_country);


--
-- TOC entry 5048 (class 2606 OID 16799)
-- Name: countries countries_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_unique UNIQUE (iso_code);


--
-- TOC entry 5030 (class 2606 OID 16696)
-- Name: dispensations dispensations_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispensations
    ADD CONSTRAINT dispensations_pk PRIMARY KEY (id);


--
-- TOC entry 5066 (class 2606 OID 16963)
-- Name: family_history family_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_pk PRIMARY KEY (id);


--
-- TOC entry 5026 (class 2606 OID 16640)
-- Name: meds_dictionary meds_dictionary_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meds_dictionary
    ADD CONSTRAINT meds_dictionary_pk PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 16669)
-- Name: meds_synonyms meds_synonyms_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meds_synonyms
    ADD CONSTRAINT meds_synonyms_pk PRIMARY KEY (synonym);


--
-- TOC entry 5060 (class 2606 OID 16890)
-- Name: neighborhoods neighborhoods_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_pk PRIMARY KEY (id_neighborhood);


--
-- TOC entry 4984 (class 2606 OID 16399)
-- Name: users newtable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT newtable_pk PRIMARY KEY (id);


--
-- TOC entry 4986 (class 2606 OID 16401)
-- Name: users newtable_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT newtable_unique UNIQUE (username);


--
-- TOC entry 4988 (class 2606 OID 16403)
-- Name: users newtable_unique_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT newtable_unique_1 UNIQUE (email);


--
-- TOC entry 4990 (class 2606 OID 16414)
-- Name: patient_alerts patient_alerts_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_alerts
    ADD CONSTRAINT patient_alerts_pk PRIMARY KEY (id);


--
-- TOC entry 5072 (class 2606 OID 17057)
-- Name: patient_allergies patient_allergies_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_allergies
    ADD CONSTRAINT patient_allergies_pk PRIMARY KEY (id);


--
-- TOC entry 5074 (class 2606 OID 17087)
-- Name: patient_conditions patient_conditions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_conditions
    ADD CONSTRAINT patient_conditions_pk PRIMARY KEY (id);


--
-- TOC entry 5032 (class 2606 OID 16721)
-- Name: patient_contacts patient_contacts_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_contacts
    ADD CONSTRAINT patient_contacts_pk PRIMARY KEY (id);


--
-- TOC entry 5068 (class 2606 OID 16994)
-- Name: patient_medications patient_medications_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_pk PRIMARY KEY (id);


--
-- TOC entry 5036 (class 2606 OID 16755)
-- Name: patient_pii patient_pii_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_pii
    ADD CONSTRAINT patient_pii_pk PRIMARY KEY (patient_id);


--
-- TOC entry 5070 (class 2606 OID 17028)
-- Name: patient_procedures patient_procedures_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_procedures
    ADD CONSTRAINT patient_procedures_pk PRIMARY KEY (id);


--
-- TOC entry 4992 (class 2606 OID 16427)
-- Name: patients patients_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pk PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 16437)
-- Name: patients patients_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_unique UNIQUE (curp_hash);


--
-- TOC entry 5008 (class 2606 OID 16568)
-- Name: permissions permissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pk PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 16570)
-- Name: permissions permissions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_unique UNIQUE (name);


--
-- TOC entry 5050 (class 2606 OID 16809)
-- Name: postal_codes postal_codes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postal_codes
    ADD CONSTRAINT postal_codes_pk PRIMARY KEY (id_postal_codes);


--
-- TOC entry 5022 (class 2606 OID 16613)
-- Name: prescription_items prescription_items_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription_items
    ADD CONSTRAINT prescription_items_pk PRIMARY KEY (id);


--
-- TOC entry 5018 (class 2606 OID 16590)
-- Name: prescriptions prescriptions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_pk PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 16592)
-- Name: prescriptions prescriptions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_unique UNIQUE (prescription_code);


--
-- TOC entry 5012 (class 2606 OID 16581)
-- Name: role_permissions role_permissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pk PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5014 (class 2606 OID 16576)
-- Name: role_permissions role_permissions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_unique UNIQUE (role_id);


--
-- TOC entry 5016 (class 2606 OID 16579)
-- Name: role_permissions role_permissions_unique_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_unique_1 UNIQUE (permission_id);


--
-- TOC entry 5004 (class 2606 OID 16537)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);


--
-- TOC entry 5006 (class 2606 OID 16539)
-- Name: roles roles_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_unique UNIQUE (name);


--
-- TOC entry 5024 (class 2606 OID 16626)
-- Name: rx_item_drug_map rx_item_drug_map_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rx_item_drug_map
    ADD CONSTRAINT rx_item_drug_map_pk PRIMARY KEY (prescription_item_id);


--
-- TOC entry 5034 (class 2606 OID 16735)
-- Name: studies studies_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT studies_pk PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 16523)
-- Name: user_roles user_roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pk PRIMARY KEY (role_id, user_id);


--
-- TOC entry 5108 (class 2606 OID 16896)
-- Name: addresses addresses_neighborhoods_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_neighborhoods_fk FOREIGN KEY (id_neighborhood) REFERENCES public.neighborhoods(id_neighborhood);


--
-- TOC entry 5109 (class 2606 OID 16877)
-- Name: addresses addresses_postal_codes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_postal_codes_fk FOREIGN KEY (id_postal_code) REFERENCES public.postal_codes(id_postal_codes);


--
-- TOC entry 5112 (class 2606 OID 16840)
-- Name: admin_subdivisions admin_subdivisions_countries_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_subdivisions
    ADD CONSTRAINT admin_subdivisions_countries_fk FOREIGN KEY (id_country) REFERENCES public.countries(id_country);


--
-- TOC entry 5081 (class 2606 OID 16479)
-- Name: appointments appointments_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patients_fk FOREIGN KEY (patients_id) REFERENCES public.patients(id);


--
-- TOC entry 5082 (class 2606 OID 16484)
-- Name: appointments appointments_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_users_fk FOREIGN KEY (medico_id) REFERENCES public.users(id);


--
-- TOC entry 5083 (class 2606 OID 16489)
-- Name: appointments appointments_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_users_fk_1 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5080 (class 2606 OID 16454)
-- Name: audit_logs audit_logs_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_users_fk FOREIGN KEY (actor_id) REFERENCES public.users(id);


--
-- TOC entry 5111 (class 2606 OID 16852)
-- Name: cities cities_admin_subdivisions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_admin_subdivisions_fk FOREIGN KEY (id_area) REFERENCES public.admin_subdivisions(id_area);


--
-- TOC entry 5114 (class 2606 OID 16925)
-- Name: clinical_histories clinical_histories_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinical_histories
    ADD CONSTRAINT clinical_histories_patients_fk FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5115 (class 2606 OID 16930)
-- Name: clinical_histories clinical_histories_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinical_histories
    ADD CONSTRAINT clinical_histories_users_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5084 (class 2606 OID 16502)
-- Name: consultations consultations_patients_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_patients_fk_1 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5085 (class 2606 OID 16507)
-- Name: consultations consultations_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_users_fk FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- TOC entry 5086 (class 2606 OID 16512)
-- Name: consultations consultations_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_users_fk_1 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5101 (class 2606 OID 16699)
-- Name: dispensations dispensations_prescriptions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispensations
    ADD CONSTRAINT dispensations_prescriptions_fk FOREIGN KEY (prescription_id) REFERENCES public.prescriptions(id);


--
-- TOC entry 5102 (class 2606 OID 16704)
-- Name: dispensations dispensations_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispensations
    ADD CONSTRAINT dispensations_users_fk FOREIGN KEY (pharmacist_id) REFERENCES public.users(id);


--
-- TOC entry 5103 (class 2606 OID 16709)
-- Name: dispensations dispensations_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispensations
    ADD CONSTRAINT dispensations_users_fk_1 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5098 (class 2606 OID 16652)
-- Name: drug_interactions drug_interactions_meds_dictionary_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_interactions
    ADD CONSTRAINT drug_interactions_meds_dictionary_fk FOREIGN KEY (a_med_id) REFERENCES public.meds_dictionary(id);


--
-- TOC entry 5099 (class 2606 OID 16657)
-- Name: drug_interactions drug_interactions_meds_dictionary_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_interactions
    ADD CONSTRAINT drug_interactions_meds_dictionary_fk_1 FOREIGN KEY (b_med_id) REFERENCES public.meds_dictionary(id);


--
-- TOC entry 5116 (class 2606 OID 16979)
-- Name: family_history family_history_clinical_codes_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_clinical_codes_fk_1 FOREIGN KEY (condition_code_id) REFERENCES public.clinical_codes(id);


--
-- TOC entry 5117 (class 2606 OID 16964)
-- Name: family_history family_history_clinical_histories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_clinical_histories_fk FOREIGN KEY (clinical_history_id) REFERENCES public.clinical_histories(id);


--
-- TOC entry 5118 (class 2606 OID 16969)
-- Name: family_history family_history_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_users_fk FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5119 (class 2606 OID 16974)
-- Name: family_history family_history_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family_history
    ADD CONSTRAINT family_history_users_fk_1 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5100 (class 2606 OID 16670)
-- Name: meds_synonyms meds_synonyms_meds_dictionary_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meds_synonyms
    ADD CONSTRAINT meds_synonyms_meds_dictionary_fk FOREIGN KEY (med_id) REFERENCES public.meds_dictionary(id);


--
-- TOC entry 5113 (class 2606 OID 16891)
-- Name: neighborhoods neighborhoods_cities_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_cities_fk FOREIGN KEY (id_city) REFERENCES public.cities(id_city);


--
-- TOC entry 5075 (class 2606 OID 16404)
-- Name: users newtable_newtable_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT newtable_newtable_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5076 (class 2606 OID 16428)
-- Name: patient_alerts patient_alerts_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_alerts
    ADD CONSTRAINT patient_alerts_patients_fk FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5077 (class 2606 OID 16417)
-- Name: patient_alerts patient_alerts_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_alerts
    ADD CONSTRAINT patient_alerts_users_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5129 (class 2606 OID 17063)
-- Name: patient_allergies patient_allergies_clinical_codes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_allergies
    ADD CONSTRAINT patient_allergies_clinical_codes_fk FOREIGN KEY (substance_code_id) REFERENCES public.clinical_codes(id);


--
-- TOC entry 5130 (class 2606 OID 17058)
-- Name: patient_allergies patient_allergies_clinical_histories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_allergies
    ADD CONSTRAINT patient_allergies_clinical_histories_fk FOREIGN KEY (clinical_history_id) REFERENCES public.clinical_histories(id);


--
-- TOC entry 5131 (class 2606 OID 17068)
-- Name: patient_allergies patient_allergies_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_allergies
    ADD CONSTRAINT patient_allergies_users_fk FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5132 (class 2606 OID 17073)
-- Name: patient_allergies patient_allergies_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_allergies
    ADD CONSTRAINT patient_allergies_users_fk_1 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5133 (class 2606 OID 17093)
-- Name: patient_conditions patient_conditions_clinical_codes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_conditions
    ADD CONSTRAINT patient_conditions_clinical_codes_fk FOREIGN KEY (code_id) REFERENCES public.clinical_codes(id);


--
-- TOC entry 5134 (class 2606 OID 17088)
-- Name: patient_conditions patient_conditions_clinical_histories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_conditions
    ADD CONSTRAINT patient_conditions_clinical_histories_fk FOREIGN KEY (clinical_history_id) REFERENCES public.clinical_histories(id);


--
-- TOC entry 5135 (class 2606 OID 17098)
-- Name: patient_conditions patient_conditions_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_conditions
    ADD CONSTRAINT patient_conditions_users_fk FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5136 (class 2606 OID 17103)
-- Name: patient_conditions patient_conditions_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_conditions
    ADD CONSTRAINT patient_conditions_users_fk_1 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5104 (class 2606 OID 16722)
-- Name: patient_contacts patient_contacts_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_contacts
    ADD CONSTRAINT patient_contacts_patients_fk FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5120 (class 2606 OID 17000)
-- Name: patient_medications patient_medications_clinical_codes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_clinical_codes_fk FOREIGN KEY (medication_code_id) REFERENCES public.clinical_codes(id);


--
-- TOC entry 5121 (class 2606 OID 16995)
-- Name: patient_medications patient_medications_clinical_histories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_clinical_histories_fk FOREIGN KEY (clinical_history_id) REFERENCES public.clinical_histories(id);


--
-- TOC entry 5122 (class 2606 OID 17005)
-- Name: patient_medications patient_medications_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_users_fk FOREIGN KEY (prescriber_id) REFERENCES public.users(id);


--
-- TOC entry 5123 (class 2606 OID 17010)
-- Name: patient_medications patient_medications_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_users_fk_1 FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5124 (class 2606 OID 17015)
-- Name: patient_medications patient_medications_users_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_medications
    ADD CONSTRAINT patient_medications_users_fk_2 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5107 (class 2606 OID 16763)
-- Name: patient_pii patient_pii_patients_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_pii
    ADD CONSTRAINT patient_pii_patients_fk_1 FOREIGN KEY (patient_id) REFERENCES public.patients(id);

--
-- TOC entry 5137 (class 2606 OID 17108)
-- Name: patient_pii patient_pii_addresses_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_pii
    ADD CONSTRAINT patient_pii_addresses_fk FOREIGN KEY (address_id) REFERENCES public.addresses(id_address);


--
-- TOC entry 5125 (class 2606 OID 17034)
-- Name: patient_procedures patient_procedures_clinical_codes_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_procedures
    ADD CONSTRAINT patient_procedures_clinical_codes_fk FOREIGN KEY (procedure_code_id) REFERENCES public.clinical_codes(id);


--
-- TOC entry 5126 (class 2606 OID 17029)
-- Name: patient_procedures patient_procedures_clinical_histories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_procedures
    ADD CONSTRAINT patient_procedures_clinical_histories_fk FOREIGN KEY (clinical_history_id) REFERENCES public.clinical_histories(id);


--
-- TOC entry 5127 (class 2606 OID 17039)
-- Name: patient_procedures patient_procedures_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_procedures
    ADD CONSTRAINT patient_procedures_users_fk FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5128 (class 2606 OID 17044)
-- Name: patient_procedures patient_procedures_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_procedures
    ADD CONSTRAINT patient_procedures_users_fk_1 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5078 (class 2606 OID 16438)
-- Name: patients patients_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_users_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5079 (class 2606 OID 16443)
-- Name: patients patients_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_users_fk_1 FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 5110 (class 2606 OID 16810)
-- Name: postal_codes postal_codes_countries_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postal_codes
    ADD CONSTRAINT postal_codes_countries_fk FOREIGN KEY (id_country) REFERENCES public.countries(id_country);


--
-- TOC entry 5095 (class 2606 OID 16616)
-- Name: prescription_items prescription_items_prescriptions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription_items
    ADD CONSTRAINT prescription_items_prescriptions_fk FOREIGN KEY (prescription_id) REFERENCES public.prescriptions(id);


--
-- TOC entry 5092 (class 2606 OID 16598)
-- Name: prescriptions prescriptions_consultations_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_consultations_fk FOREIGN KEY (consultation_id) REFERENCES public.consultations(id);


--
-- TOC entry 5093 (class 2606 OID 16593)
-- Name: prescriptions prescriptions_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_patients_fk FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5094 (class 2606 OID 16603)
-- Name: prescriptions prescriptions_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_users_fk FOREIGN KEY (signed_by) REFERENCES public.users(id);


--
-- TOC entry 5090 (class 2606 OID 16686)
-- Name: role_permissions role_permissions_permissions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permissions_fk FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- TOC entry 5091 (class 2606 OID 16681)
-- Name: role_permissions role_permissions_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_roles_fk FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 5096 (class 2606 OID 16676)
-- Name: rx_item_drug_map rx_item_drug_map_meds_dictionary_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rx_item_drug_map
    ADD CONSTRAINT rx_item_drug_map_meds_dictionary_fk FOREIGN KEY (med_id) REFERENCES public.meds_dictionary(id);


--
-- TOC entry 5097 (class 2606 OID 16630)
-- Name: rx_item_drug_map rx_item_drug_map_prescription_items_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rx_item_drug_map
    ADD CONSTRAINT rx_item_drug_map_prescription_items_fk FOREIGN KEY (prescription_item_id) REFERENCES public.prescription_items(id);


--
-- TOC entry 5105 (class 2606 OID 16736)
-- Name: studies studies_patients_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT studies_patients_fk FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 5106 (class 2606 OID 16741)
-- Name: studies studies_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT studies_users_fk FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- TOC entry 5087 (class 2606 OID 16550)
-- Name: user_roles user_roles_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_roles_fk FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 5088 (class 2606 OID 16545)
-- Name: user_roles user_roles_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_users_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5089 (class 2606 OID 16555)
-- Name: user_roles user_roles_users_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_users_fk_1 FOREIGN KEY (assigned_by) REFERENCES public.users(id);


-- Completed on 2025-11-21 13:55:05

--
-- PostgreSQL database dump complete
--

\unrestrict x7B7GgucG9XrBchQVIh9KeChcUQCdSY1GlnmlsUED1tayWLvWW23nKcHg1Ei6L0

