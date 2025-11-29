package jonathan.humphreys.benavidesapp.data.api

import jonathan.humphreys.benavidesapp.data.model.Prescription
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Query

interface PrescriptionApiService {
    @GET("prescriptions/")
    suspend fun getPrescriptions(
        @Header("Authorization") token: String,
        @Query("patient_id") patientId: String? = null,
        @Query("skip") skip: Int = 0,
        @Query("limit") limit: Int = 100
    ): Response<List<Prescription>>
    
    @GET("prescriptions/{prescription_id}")
    suspend fun getPrescription(
        @Header("Authorization") token: String,
        @retrofit2.http.Path("prescription_id") prescriptionId: String
    ): Response<Prescription>
}

