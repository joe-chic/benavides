package jonathan.humphreys.benavidesapp.data.model

import com.google.gson.annotations.SerializedName

data class PersonalInfoResponse(
    @SerializedName("patient_id")
    val patientId: String,
    @SerializedName("first_name")
    val firstName: String?,
    @SerializedName("first_surname")
    val firstSurname: String?,
    @SerializedName("second_surname")
    val secondSurname: String?,
    @SerializedName("full_name")
    val fullName: String?,
    val email: String?,
    val phone: String?,
    @SerializedName("date_of_birth")
    val dateOfBirth: String?,
    val gender: String?,
    @SerializedName("address_line")
    val addressLine: String?,
    val city: String?,
    val state: String?,
    @SerializedName("postal_code")
    val postalCode: String?,
    val country: String?
)

data class ClinicalHistoryResponse(
    @SerializedName("clinical_history")
    val clinicalHistory: ClinicalHistoryMetadata,
    val allergies: List<AllergyEntry>,
    val conditions: List<ConditionEntry>,
    val procedures: List<ProcedureEntry>,
    @SerializedName("family_history")
    val familyHistory: List<FamilyHistoryEntry>
)

data class ClinicalHistoryMetadata(
    val id: String,
    val status: String?,
    @SerializedName("opened_at")
    val openedAt: String?,
    @SerializedName("closed_at")
    val closedAt: String?
)

data class ConditionEntry(
    val id: String,
    @SerializedName("code_id")
    val codeId: String?,
    @SerializedName("code_display")
    val codeDisplay: String?,
    @SerializedName("onset_date")
    val onsetDate: String?,
    @SerializedName("verification_status")
    val verificationStatus: String?,
    @SerializedName("recorded_at")
    val recordedAt: String?
)

data class AllergyEntry(
    val id: String,
    @SerializedName("substance_code_id")
    val substanceCodeId: String?,
    @SerializedName("substance_display")
    val substanceDisplay: String?,
    val reaction: String?,
    val severity: String?,
    val status: String?,
    @SerializedName("recorded_at")
    val recordedAt: String?
)

data class ProcedureEntry(
    val id: String,
    @SerializedName("procedure_code_id")
    val procedureCodeId: String?,
    @SerializedName("procedure_display")
    val procedureDisplay: String?,
    @SerializedName("performed_on")
    val performedOn: String?,
    val facility: String?,
    val note: String?,
    @SerializedName("recorded_at")
    val recordedAt: String?
)

data class FamilyHistoryEntry(
    val id: String,
    @SerializedName("relationship_type")
    val relationshipType: String?,
    @SerializedName("condition_code_id")
    val conditionCodeId: String?,
    @SerializedName("condition_display")
    val conditionDisplay: String?,
    val note: String?,
    @SerializedName("verification_status")
    val verificationStatus: String?,
    @SerializedName("relative_age_of_consent")
    val relativeAgeOfConsent: Int?,
    @SerializedName("relative_is_deceased")
    val relativeIsDeceased: Boolean?,
    @SerializedName("recorded_at")
    val recordedAt: String?
)


