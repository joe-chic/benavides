package jonathan.humphreys.benavidesapp.data.api

import jonathan.humphreys.benavidesapp.data.model.Appointment
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Query

interface AppointmentApiService {
    @GET("appointments/")
    suspend fun getAppointments(
        @Header("Authorization") token: String,
        @Query("patient_id") patientId: String? = null,
        @Query("search") search: String? = null,
        @Query("skip") skip: Int = 0,
        @Query("limit") limit: Int = 100
    ): Response<List<Appointment>>
}


