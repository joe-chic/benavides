package jonathan.humphreys.benavidesapp.util

import android.content.Context
import android.content.SharedPreferences

class SharedPreferencesHelper(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    
    companion object {
        private const val PREFS_NAME = "BenavidesPrefs"
        private const val KEY_ACCESS_TOKEN = "access_token"
        private const val KEY_REFRESH_TOKEN = "refresh_token"
        private const val KEY_USER_ID = "user_id"
        private const val KEY_USERNAME = "username"
    }
    
    fun saveTokens(accessToken: String, refreshToken: String) {
        prefs.edit().apply {
            putString(KEY_ACCESS_TOKEN, accessToken)
            putString(KEY_REFRESH_TOKEN, refreshToken)
            apply()
        }
    }
    
    fun getAccessToken(): String? = prefs.getString(KEY_ACCESS_TOKEN, null)
    fun getRefreshToken(): String? = prefs.getString(KEY_REFRESH_TOKEN, null)
    
    fun saveUserInfo(userId: String, username: String) {
        prefs.edit().apply {
            putString(KEY_USER_ID, userId)
            putString(KEY_USERNAME, username)
            apply()
        }
    }
    
    fun clearAll() {
        prefs.edit().clear().apply()
    }
    
    fun isLoggedIn(): Boolean = getAccessToken() != null
    
    fun clearTokens() {
        prefs.edit().remove(KEY_ACCESS_TOKEN).remove(KEY_REFRESH_TOKEN).apply()
    }
    
    fun clearUserInfo() {
        prefs.edit().remove(KEY_USER_ID).remove(KEY_USERNAME).apply()
    }
    
    fun getUserId(): String? = prefs.getString(KEY_USER_ID, null)
    
    fun getUserRoles(): List<String> {
        val rolesString = prefs.getString("user_roles", null)
        return rolesString?.split(",") ?: emptyList()
    }
    
    fun saveUserRoles(roles: List<String>) {
        prefs.edit().putString("user_roles", roles.joinToString(",")).apply()
    }
}

