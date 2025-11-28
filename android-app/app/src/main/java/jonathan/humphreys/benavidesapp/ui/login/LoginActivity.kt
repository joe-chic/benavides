package jonathan.humphreys.benavidesapp.ui.login

import android.content.Intent
import android.os.Bundle
import android.text.method.PasswordTransformationMethod
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.databinding.ActivityLoginBinding
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.LoginRequest
import jonathan.humphreys.benavidesapp.ui.createaccount.CreateAccountActivity
import jonathan.humphreys.benavidesapp.ui.resetpassword.ResetPasswordActivity
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import kotlinx.coroutines.launch

class LoginActivity : AppCompatActivity() {
    private lateinit var binding: ActivityLoginBinding
    private lateinit var prefsHelper: SharedPreferencesHelper
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        prefsHelper = SharedPreferencesHelper(this)
        
        // Check if already logged in
        if (prefsHelper.isLoggedIn()) {
            // Navigate to main activity (to be implemented)
            // startActivity(Intent(this, MainActivity::class.java))
            // finish()
        }
        
        setupViews()
    }
    
    private fun setupViews() {
        // Password field transformation
        binding.passwordEditText.transformationMethod = PasswordTransformationMethod()
        
        // Login button click
        binding.loginButton.setOnClickListener {
            performLogin()
        }
        
        // Create account button click
        binding.createAccountButton.setOnClickListener {
            startActivity(Intent(this, CreateAccountActivity::class.java))
        }
        
        // Forgot password click
        binding.forgotPasswordText.setOnClickListener {
            startActivity(Intent(this, ResetPasswordActivity::class.java))
        }
        
        // Add underline to text programmatically
        binding.forgotPasswordText.paintFlags = binding.forgotPasswordText.paintFlags or android.graphics.Paint.UNDERLINE_TEXT_FLAG
    }
    
    private fun performLogin() {
        val email = binding.emailEditText.text.toString().trim()
        val password = binding.passwordEditText.text.toString()
        
        if (!validateInputs(email, password)) {
            return
        }
        
        binding.progressBar.visibility = View.VISIBLE
        binding.loginButton.isEnabled = false
        
        lifecycleScope.launch {
            try {
                val response = RetrofitClient.authApiService.login(
                    LoginRequest(email = email, password = password)
                )
                
                if (response.isSuccessful && response.body() != null) {
                    val tokenResponse = response.body()!!
                    prefsHelper.saveTokens(
                        tokenResponse.accessToken,
                        tokenResponse.refreshToken
                    )
                    
                    // Get user info and save
                    val userResponse = RetrofitClient.authApiService.getCurrentUser(
                        "Bearer ${tokenResponse.accessToken}"
                    )
                    
                    if (userResponse.isSuccessful && userResponse.body() != null) {
                        val user = userResponse.body()!!
                        prefsHelper.saveUserInfo(user.id, user.username)
                        
                        // Navigate based on user role
                        if (user.roles.contains("patient")) {
                            // Navigate to patient home
                            val intent = Intent(this@LoginActivity, jonathan.humphreys.benavidesapp.ui.patient.PatientHomeActivity::class.java)
                            startActivity(intent)
                            finish()
                        } else {
                            // Other roles - show placeholder message
                            Toast.makeText(
                                this@LoginActivity,
                                "Rol no implementado aún: ${user.roles.joinToString()}",
                                Toast.LENGTH_LONG
                            ).show()
                        }
                    } else {
                        Toast.makeText(this@LoginActivity, "Inicio de sesión exitoso", Toast.LENGTH_SHORT).show()
                    }
                } else {
                    Toast.makeText(
                        this@LoginActivity,
                        getString(R.string.error_login_failed),
                        Toast.LENGTH_SHORT
                    ).show()
                }
            } catch (e: Exception) {
                e.printStackTrace() // Log for debugging
                val errorMessage = when {
                    e.message?.contains("Unable to resolve host") == true -> 
                        "No se pudo conectar al servidor. Verifica que el backend esté corriendo."
                    e.message?.contains("timeout") == true -> 
                        "Tiempo de espera agotado. Verifica tu conexión."
                    else -> 
                        "${getString(R.string.error_network)}: ${e.message ?: "Error desconocido"}"
                }
                Toast.makeText(
                    this@LoginActivity,
                    errorMessage,
                    Toast.LENGTH_LONG
                ).show()
            } finally {
                binding.progressBar.visibility = View.GONE
                binding.loginButton.isEnabled = true
            }
        }
    }
    
    private fun validateInputs(email: String, password: String): Boolean {
        var isValid = true
        
        if (email.isEmpty()) {
            binding.emailEditText.error = getString(R.string.error_empty_field)
            isValid = false
        } else if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            binding.emailEditText.error = getString(R.string.error_invalid_email)
            isValid = false
        } else {
            binding.emailEditText.error = null
        }
        
        if (password.isEmpty()) {
            binding.passwordEditText.error = getString(R.string.error_empty_field)
            isValid = false
        } else {
            binding.passwordEditText.error = null
        }
        
        return isValid
    }
}

