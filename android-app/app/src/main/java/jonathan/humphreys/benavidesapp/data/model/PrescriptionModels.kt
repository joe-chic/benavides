package jonathan.humphreys.benavidesapp.data.model

import com.google.gson.annotations.SerializedName

data class Prescription(
    val id: String,
    @SerializedName("prescription_code")
    val prescriptionCode: String,
    @SerializedName("patient_id")
    val patientId: String,
    @SerializedName("consultation_id")
    val consultationId: String?,
    @SerializedName("signed_by")
    val signedBy: String?,
    @SerializedName("signed_at")
    val signedAt: String?,
    @SerializedName("created_at")
    val createdAt: String?,
    @SerializedName("medic_name")
    val medicName: String?,
    @SerializedName("item_count")
    val itemCount: Int?,
    val status: String?,
    @SerializedName("expiration_date")
    val expirationDate: String?,
    val items: List<PrescriptionItem>? = null
)

data class PrescriptionItem(
    val id: String,
    @SerializedName("medication_name")
    val medicationName: String,
    val dose: String?,
    val form: String?,
    val frequency: String?,
    val duration: String?,
    val observations: String?
)

