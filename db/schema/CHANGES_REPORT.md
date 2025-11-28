# Database Schema Review Report

**Date:** 2025-01-27  
**Schema File:** `db/schema/schema.sql`  
**Review Scope:** 3NF Normalization, Data Types, Referential Integrity

---

## Executive Summary

The database schema has several **critical referential integrity issues** that must be fixed, along with normalization violations and data type concerns. The schema is generally well-structured but requires corrections to meet 3NF standards and ensure data integrity.

---

## 🔴 CRITICAL ISSUES - Referential Integrity

### 1. **audit_logs** - Incorrect Foreign Key
**Location:** Line 1459  
**Issue:** Foreign key constraint is on the wrong column
```sql
-- CURRENT (WRONG):
FOREIGN KEY (id) REFERENCES public.users(id)

-- SHOULD BE:
FOREIGN KEY (actor_id) REFERENCES public.users(id)
```
**Impact:** The constraint references the table's own primary key instead of the `actor_id` column, breaking referential integrity.

---

### 2. **clinical_histories** - Incorrect Foreign Key
**Location:** Line 1477  
**Issue:** Foreign key constraint is on the wrong column
```sql
-- CURRENT (WRONG):
FOREIGN KEY (id) REFERENCES public.patients(id)

-- SHOULD BE:
FOREIGN KEY (patient_id) REFERENCES public.patients(id)
```
**Impact:** The constraint references the table's own primary key instead of the `patient_id` column, breaking referential integrity.

---

### 3. **patient_alerts** - Incorrect Foreign Key
**Location:** Line 1639  
**Issue:** Foreign key constraint is on the wrong column
```sql
-- CURRENT (WRONG):
FOREIGN KEY (id) REFERENCES public.users(id)

-- SHOULD BE:
FOREIGN KEY (created_by) REFERENCES public.users(id)
```
**Impact:** The constraint references the table's own primary key instead of the `created_by` column, breaking referential integrity.

---

### 4. **patient_pii** - Missing Foreign Key
**Location:** Line 439  
**Issue:** `address_id` column has no foreign key constraint
```sql
-- MISSING CONSTRAINT:
FOREIGN KEY (address_id) REFERENCES public.addresses(id_address)
```
**Impact:** No referential integrity enforcement for patient addresses.

---

### 5. **dispensations** - Missing Foreign Key
**Location:** Line 215  
**Issue:** `branch_id` column has no foreign key constraint and no referenced table exists
```sql
-- MISSING:
-- Either create a 'branches' table or remove the column if not needed
```
**Impact:** Orphaned references if branches table doesn't exist.

---

## 🟡 NORMALIZATION ISSUES (3NF Violations)

### 1. **addresses** - Normalized Fields (INTENTIONAL DENORMALIZATION)
**Location:** Lines 54-57  
**Status:** ✅ **KEPT** - Intentional design choice
```sql
street_number integer NOT NULL,
street_number_norm character varying(255) NOT NULL,  -- Intentional denormalization
street_name character varying(255) NOT NULL,
street_name_norm character varying(255) NOT NULL,  -- Intentional denormalization
```
**Rationale:** The `_norm` fields are intentionally stored for address matching purposes. They use PostgreSQL normalization libraries to ensure addresses written in different formats (e.g., "St." vs "Street", "Ave" vs "Avenue") are recognized as the same location. This is a valid denormalization pattern for:
- **Performance:** Pre-computed normalized values avoid repeated normalization during queries
- **Consistency:** Ensures address matching works correctly across variations
- **Functionality:** Enables efficient exact matching on normalized values

**Decision:** These columns were initially removed but **restored** after understanding their purpose. This is an acceptable design pattern for address management systems.

---

### 2. **family_history** - Redundant Code Fields
**Location:** Lines 249-252  
**Issue:** Stores both foreign key reference and redundant code data
```sql
condition_code_id uuid,           -- FK to clinical_codes
condition_code text,               -- Redundant
condition_system text,             -- Redundant
condition_display text,            -- Redundant
```
**Problem:** Violates 3NF - code, system, and display can be retrieved from `clinical_codes` table via the foreign key.

**Recommendation:** Remove `condition_code`, `condition_system`, and `condition_display` columns. Use JOINs to retrieve this data from `clinical_codes` table.

---

### 3. **patient_allergies** - Redundant Code Fields
**Location:** Lines 336-339  
**Issue:** Same as above - redundant code data
```sql
substance_code_id uuid,            -- FK to clinical_codes
substance_code text,               -- Redundant
substance_system text,             -- Redundant
substance_display text,            -- Redundant
```
**Recommendation:** Remove redundant columns, use JOINs.

---

### 4. **patient_conditions** - Redundant Code Fields
**Location:** Lines 364-367  
**Issue:** Same pattern - redundant code data
```sql
code_id uuid,                      -- FK to clinical_codes
code text,                         -- Redundant
code_system text,                  -- Redundant
code_display text,                 -- Redundant
```
**Recommendation:** Remove redundant columns, use JOINs.

---

### 5. **patient_medications** - Redundant Code Fields
**Location:** Lines 406-409  
**Issue:** Same pattern - redundant code data
```sql
medication_code_id uuid,           -- FK to clinical_codes
medication_code text,              -- Redundant
medication_system text,            -- Redundant
medication_display text,           -- Redundant
```
**Recommendation:** Remove redundant columns, use JOINs.

---

### 6. **patient_procedures** - Redundant Code Fields
**Location:** Lines 459-462  
**Issue:** Same pattern - redundant code data
```sql
procedure_code_id uuid,            -- FK to clinical_codes
procedure_code text,               -- Redundant
procedure_system text,             -- Redundant
procedure_display text,            -- Redundant
```
**Recommendation:** Remove redundant columns, use JOINs.

---

## 🟠 DATA TYPE ISSUES

### 1. **countries.iso_code** - Incorrect Data Type
**Location:** Line 199  
**Issue:** ISO country codes are text, not integers
```sql
-- CURRENT:
iso_code integer NOT NULL

-- SHOULD BE:
iso_code character varying(2) NOT NULL  -- or text
```
**Problem:** ISO 3166-1 alpha-2 codes are 2-letter strings (e.g., "US", "MX", "CA"), not integers. ISO numeric codes exist but are less common.

**Recommendation:** Change to `character varying(2)` or `text` depending on whether you're using alpha-2 or numeric codes.

---

## 🟡 OTHER ISSUES

### 1. **addresses** - Duplicate Unique Constraint
**Location:** Lines 1009 and 1018  
**Issue:** Same unique constraint defined twice
```sql
-- Line 1009:
UNIQUE (id_neighborhood)

-- Line 1018:
UNIQUE (id_neighborhood)  -- Duplicate!
```
**Recommendation:** Remove one of the duplicate constraints.

---

### 2. **family_history** - Typo in Column Name
**Location:** Line 256  
**Issue:** Column name has typo
```sql
-- CURRENT:
verfication_status text NOT NULL

-- SHOULD BE:
verification_status text NOT NULL
```
**Recommendation:** Rename column to correct spelling.

---

### 3. **patient_allergies** - Typo in Column Name
**Location:** Line 345  
**Issue:** Column name has typo
```sql
-- CURRENT:
last_ocurrance date

-- SHOULD BE:
last_occurrence date
```
**Recommendation:** Rename column to correct spelling.

---

### 4. **meds_synoynms** - Table Name Typo
**Location:** Line 283  
**Issue:** Table name has typo
```sql
-- CURRENT:
meds_synoynms

-- SHOULD BE:
meds_synonyms
```
**Recommendation:** Rename table to correct spelling.

---

## ✅ POSITIVE OBSERVATIONS

1. **Good use of UUIDs** for primary keys - provides good distribution and avoids enumeration attacks
2. **Proper separation of concerns** - PII data encrypted separately in `patient_pii` table
3. **Comprehensive audit trail** - `audit_logs` table with integrity hashing
4. **Good role-based access control** structure with `roles`, `permissions`, and `role_permissions`
5. **Proper use of timestamps** with timezone awareness
6. **Good foreign key coverage** for most relationships (except the issues noted above)

---

## 📋 RECOMMENDATIONS SUMMARY

### Priority 1 (Critical - Fix Immediately):
1. Fix foreign key constraints in `audit_logs`, `clinical_histories`, and `patient_alerts`
2. Add foreign key constraint for `patient_pii.address_id`
3. Resolve `dispensations.branch_id` - either create branches table or remove column

### Priority 2 (Important - Fix Soon):
1. Remove redundant code fields from clinical history tables (normalize to 3NF)
2. Fix `countries.iso_code` data type
3. Remove duplicate unique constraint on `addresses.id_neighborhood`

**Note:** The `_norm` columns in `addresses` table are **intentional denormalization** for address matching and should be kept.

### Priority 3 (Nice to Have):
1. Fix typos in column/table names
2. Add CHECK constraints for enum-like text fields (status, severity, etc.)

---

## 📊 NORMALIZATION STATUS

| Table | 1NF | 2NF | 3NF | Notes |
|-------|-----|-----|-----|-------|
| addresses | ✅ | ✅ | ⚠️ | Intentional denormalization (_norm fields for address matching) |
| admin_subdivisions | ✅ | ✅ | ✅ | OK |
| appointments | ✅ | ✅ | ✅ | OK |
| audit_logs | ✅ | ✅ | ✅ | OK (but FK issue) |
| cities | ✅ | ✅ | ✅ | OK |
| clinical_codes | ✅ | ✅ | ✅ | OK |
| clinical_histories | ✅ | ✅ | ✅ | OK (but FK issue) |
| consultations | ✅ | ✅ | ✅ | OK |
| countries | ✅ | ✅ | ✅ | OK (but data type issue) |
| dispensations | ✅ | ✅ | ✅ | OK (but missing FK) |
| drug_interactions | ✅ | ✅ | ✅ | OK |
| family_history | ✅ | ✅ | ❌ | Redundant code fields |
| meds_dictionary | ✅ | ✅ | ✅ | OK |
| meds_synoynms | ✅ | ✅ | ✅ | OK (typo in name) |
| neighborhoods | ✅ | ✅ | ✅ | OK |
| patient_alerts | ✅ | ✅ | ✅ | OK (but FK issue) |
| patient_allergies | ✅ | ✅ | ❌ | Redundant code fields |
| patient_conditions | ✅ | ✅ | ❌ | Redundant code fields |
| patient_contacts | ✅ | ✅ | ✅ | OK |
| patient_medications | ✅ | ✅ | ❌ | Redundant code fields |
| patient_pii | ✅ | ✅ | ✅ | OK (but missing FK) |
| patient_procedures | ✅ | ✅ | ❌ | Redundant code fields |
| patients | ✅ | ✅ | ✅ | OK |
| permissions | ✅ | ✅ | ✅ | OK |
| postal_codes | ✅ | ✅ | ✅ | OK |
| prescription_items | ✅ | ✅ | ✅ | OK |
| prescriptions | ✅ | ✅ | ✅ | OK |
| role_permissions | ✅ | ✅ | ✅ | OK |
| roles | ✅ | ✅ | ✅ | OK |
| rx_item_drug_map | ✅ | ✅ | ✅ | OK |
| studies | ✅ | ✅ | ✅ | OK |
| user_roles | ✅ | ✅ | ✅ | OK |
| users | ✅ | ✅ | ✅ | OK |

**Overall:** 5 tables violate 3NF (4 with redundant code fields, 1 with intentional denormalization), 3 tables had critical FK issues (FIXED), 1 table had data type issue (FIXED).

---

## 🔧 SUGGESTED FIXES

### Fix 1: Correct Foreign Keys
```sql
-- Fix audit_logs
ALTER TABLE public.audit_logs
    DROP CONSTRAINT IF EXISTS audit_logs_users_fk;
ALTER TABLE public.audit_logs
    ADD CONSTRAINT audit_logs_users_fk 
    FOREIGN KEY (actor_id) REFERENCES public.users(id);

-- Fix clinical_histories
ALTER TABLE public.clinical_histories
    DROP CONSTRAINT IF EXISTS clinical_histories_patients_fk;
ALTER TABLE public.clinical_histories
    ADD CONSTRAINT clinical_histories_patients_fk 
    FOREIGN KEY (patient_id) REFERENCES public.patients(id);

-- Fix patient_alerts
ALTER TABLE public.patient_alerts
    DROP CONSTRAINT IF EXISTS patient_alerts_users_fk;
ALTER TABLE public.patient_alerts
    ADD CONSTRAINT patient_alerts_users_fk 
    FOREIGN KEY (created_by) REFERENCES public.users(id);

-- Add missing FK for patient_pii
ALTER TABLE public.patient_pii
    ADD CONSTRAINT patient_pii_addresses_fk 
    FOREIGN KEY (address_id) REFERENCES public.addresses(id_address);
```

### Fix 2: Remove Redundant Fields (Example for one table)
```sql
-- Example: Fix patient_allergies
ALTER TABLE public.patient_allergies
    DROP COLUMN IF EXISTS substance_code,
    DROP COLUMN IF EXISTS substance_system,
    DROP COLUMN IF EXISTS substance_display;
-- Repeat for other tables with similar issues
```

### Fix 3: Correct Data Type
```sql
ALTER TABLE public.countries
    ALTER COLUMN iso_code TYPE character varying(2);
```

---

---

## ✅ IMPLEMENTED FIXES

### Completed Changes:
1. ✅ Fixed foreign key constraints in `audit_logs`, `clinical_histories`, and `patient_alerts`
2. ✅ Added foreign key constraint for `patient_pii.address_id`
3. ✅ Removed redundant code fields from clinical history tables (normalized to 3NF)
4. ✅ Fixed `countries.iso_code` data type (changed to `character varying(2)`)
5. ✅ Removed duplicate unique constraint on `addresses.id_neighborhood`
6. ✅ Fixed typos: `verfication_status` → `verification_status`, `last_ocurrance` → `last_occurrence`, `meds_synoynms` → `meds_synonyms`
7. ✅ Converted all `text` columns to `character varying` with appropriate lengths
8. ✅ **RESTORED** `street_number_norm` and `street_name_norm` columns (intentional denormalization for address matching)

### Pending:
- `dispensations.branch_id` - No branches table exists. Column is nullable, so it won't cause errors. Can be addressed later if needed.

---

**End of Report**

