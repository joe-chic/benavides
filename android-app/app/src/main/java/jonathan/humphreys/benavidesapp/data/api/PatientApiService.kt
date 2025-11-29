package jonathan.humphreys.benavidesapp.data.api

import jonathan.humphreys.benavidesapp.data.model.ClinicalHistoryResponse
import jonathan.humphreys.benavidesapp.data.model.PersonalInfoResponse
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path

interface PatientApiService {

    @GET("patients/{patient_id}/personal-info")
    suspend fun getPersonalInfo(
        @Header("Authorization") token: String,
        @Path("patient_id") patientId: String
    ): Response<PersonalInfoResponse>

    @GET("patients/{patient_id}/clinical-history")
    suspend fun getClinicalHistory(
        @Header("Authorization") token: String,
        @Path("patient_id") patientId: String
    ): Response<ClinicalHistoryResponse>
}


