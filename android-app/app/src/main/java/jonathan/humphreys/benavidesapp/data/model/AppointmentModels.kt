package jonathan.humphreys.benavidesapp.data.model

import com.google.gson.annotations.SerializedName

data class Appointment(
    val id: String,
    @SerializedName("patient_id")
    val patientId: String?,
    @SerializedName("doctor_id")
    val doctorId: String?,
    @SerializedName("doctor_name")
    val doctorName: String?,
    @SerializedName("appointment_datetime")
    val appointmentDateTime: String?,
    val reason: String?,
    val status: String?,
    @SerializedName("created_at")
    val createdAt: String?,
    @SerializedName("updated_at")
    val updatedAt: String?,
    @SerializedName("created_by")
    val createdBy: String?
)


