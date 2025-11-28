package jonathan.humphreys.benavidesapp.data.model

import com.google.gson.annotations.SerializedName

data class LoginRequest(
    val email: String,
    val password: String
)

data class TokenResponse(
    @SerializedName("access_token")
    val accessToken: String,
    @SerializedName("refresh_token")
    val refreshToken: String,
    @SerializedName("token_type")
    val tokenType: String = "bearer"
)

data class RefreshTokenRequest(
    @SerializedName("refresh_token")
    val refreshToken: String
)

data class CreateAccountRequest(
    val firstName: String,
    val lastName: String,
    val phone: String,
    val email: String,
    val password: String
)

data class ResetPasswordRequest(
    val email: String
)

data class UserResponse(
    val id: String,
    val username: String,
    val email: String,
    @SerializedName("display_name")
    val displayName: String?,
    @SerializedName("mfa_enabled")
    val mfaEnabled: Boolean,
    val roles: List<String> = emptyList()
)

