package jonathan.humphreys.benavidesapp.data.repository

import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.RefreshTokenRequest
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import retrofit2.Response

object AuthRepository {
    suspend fun <T> authenticatedRequest(
        prefs: SharedPreferencesHelper,
        apiCall: suspend (String) -> Response<T>
    ): Response<T>? {
        var accessToken = prefs.getAccessToken() ?: return null
        var response = try {
            apiCall("Bearer $accessToken")
        } catch (e: Exception) {
            throw e
        }

        if (response.code() != 401) {
            return response
        }

        val refreshToken = prefs.getRefreshToken() ?: return response
        val refreshResponse = try {
            RetrofitClient.authApiService.refreshToken(RefreshTokenRequest(refreshToken))
        } catch (e: Exception) {
            null
        }

        if (refreshResponse?.isSuccessful == true && refreshResponse.body() != null) {
            val tokens = refreshResponse.body()!!
            prefs.saveTokens(tokens.accessToken, tokens.refreshToken)
            accessToken = tokens.accessToken
            response = apiCall("Bearer $accessToken")
        } else {
            prefs.clearTokens()
        }

        return response
    }
}


