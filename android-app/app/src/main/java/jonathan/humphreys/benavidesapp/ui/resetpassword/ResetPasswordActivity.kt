package jonathan.humphreys.benavidesapp.ui.resetpassword

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.databinding.ActivityResetPasswordBinding
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.ResetPasswordRequest
import jonathan.humphreys.benavidesapp.ui.login.LoginActivity
import kotlinx.coroutines.launch

class ResetPasswordActivity : AppCompatActivity() {
    private lateinit var binding: ActivityResetPasswordBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityResetPasswordBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupViews()
    }
    
    private fun setupViews() {
        // Send link button click
        binding.sendLinkButton.setOnClickListener {
            performResetPassword()
        }
        
        // Back to login click
        binding.backToLoginText.setOnClickListener {
            finish()
        }
        
        // Add underline to text programmatically
        binding.backToLoginText.paintFlags = binding.backToLoginText.paintFlags or android.graphics.Paint.UNDERLINE_TEXT_FLAG
    }
    
    private fun performResetPassword() {
        val email = binding.emailEditText.text.toString().trim()
        
        if (!validateInput(email)) {
            return
        }
        
        binding.progressBar.visibility = View.VISIBLE
        binding.sendLinkButton.isEnabled = false
        
        lifecycleScope.launch {
            try {
                // Note: Reset password endpoint needs to be implemented in the API
                // For now, this is a placeholder that shows the structure
                val request = ResetPasswordRequest(email = email)
                
                // TODO: Implement reset password API call when endpoint is available
                // val response = RetrofitClient.authApiService.resetPassword(request)
                
                // For now, show success message and navigate to login
                Toast.makeText(
                    this@ResetPasswordActivity,
                    getString(R.string.success_reset_link_sent),
                    Toast.LENGTH_SHORT
                ).show()
                
                // Navigate to login
                startActivity(android.content.Intent(this@ResetPasswordActivity, LoginActivity::class.java))
                finish()
                
            } catch (e: Exception) {
                Toast.makeText(
                    this@ResetPasswordActivity,
                    getString(R.string.error_network),
                    Toast.LENGTH_SHORT
                ).show()
            } finally {
                binding.progressBar.visibility = View.GONE
                binding.sendLinkButton.isEnabled = true
            }
        }
    }
    
    private fun validateInput(email: String): Boolean {
        if (email.isEmpty()) {
            binding.emailEditText.error = getString(R.string.error_empty_field)
            return false
        }
        
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            binding.emailEditText.error = getString(R.string.error_invalid_email)
            return false
        }
        
        return true
    }
}

