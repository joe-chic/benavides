package jonathan.humphreys.benavidesapp.ui.createaccount

import android.os.Bundle
import android.text.method.PasswordTransformationMethod
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.databinding.ActivityCreateAccountBinding
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.CreateAccountRequest
import jonathan.humphreys.benavidesapp.ui.login.LoginActivity
import kotlinx.coroutines.launch

class CreateAccountActivity : AppCompatActivity() {
    private lateinit var binding: ActivityCreateAccountBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCreateAccountBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupViews()
    }
    
    private fun setupViews() {
        // Password field transformation
        binding.passwordEditText.transformationMethod = PasswordTransformationMethod()
        
        // Create account button click
        binding.createAccountButton.setOnClickListener {
            performCreateAccount()
        }
        
        // Back to login click
        binding.backToLoginText.setOnClickListener {
            finish()
        }
        
        // Add underline to text programmatically
        binding.backToLoginText.paintFlags = binding.backToLoginText.paintFlags or android.graphics.Paint.UNDERLINE_TEXT_FLAG
    }
    
    private fun performCreateAccount() {
        val firstName = binding.firstNameEditText.text.toString().trim()
        val lastName = binding.lastNameEditText.text.toString().trim()
        val phone = binding.phoneEditText.text.toString().trim()
        val email = binding.emailEditText.text.toString().trim()
        val password = binding.passwordEditText.text.toString()
        
        if (!validateInputs(firstName, lastName, phone, email, password)) {
            return
        }
        
        binding.progressBar.visibility = View.VISIBLE
        binding.createAccountButton.isEnabled = false
        
        lifecycleScope.launch {
            try {
                // Note: Create account endpoint needs to be implemented in the API
                // For now, this is a placeholder that shows the structure
                val request = CreateAccountRequest(
                    firstName = firstName,
                    lastName = lastName,
                    phone = phone,
                    email = email,
                    password = password
                )
                
                // TODO: Implement create account API call when endpoint is available
                // val response = RetrofitClient.authApiService.createAccount(request)
                
                // For now, show success message and navigate to login
                Toast.makeText(
                    this@CreateAccountActivity,
                    getString(R.string.success_account_created),
                    Toast.LENGTH_SHORT
                ).show()
                
                // Navigate to login
                startActivity(android.content.Intent(this@CreateAccountActivity, LoginActivity::class.java))
                finish()
                
            } catch (e: Exception) {
                Toast.makeText(
                    this@CreateAccountActivity,
                    getString(R.string.error_network),
                    Toast.LENGTH_SHORT
                ).show()
            } finally {
                binding.progressBar.visibility = View.GONE
                binding.createAccountButton.isEnabled = true
            }
        }
    }
    
    private fun validateInputs(
        firstName: String,
        lastName: String,
        phone: String,
        email: String,
        password: String
    ): Boolean {
        var isValid = true
        
        if (firstName.isEmpty()) {
            binding.firstNameEditText.error = getString(R.string.error_empty_field)
            isValid = false
        }
        
        if (lastName.isEmpty()) {
            binding.lastNameEditText.error = getString(R.string.error_empty_field)
            isValid = false
        }
        
        if (phone.isEmpty()) {
            binding.phoneEditText.error = getString(R.string.error_empty_field)
            isValid = false
        }
        
        if (email.isEmpty()) {
            binding.emailEditText.error = getString(R.string.error_empty_field)
            isValid = false
        } else if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            binding.emailEditText.error = getString(R.string.error_invalid_email)
            isValid = false
        }
        
        if (password.isEmpty()) {
            binding.passwordEditText.error = getString(R.string.error_empty_field)
            isValid = false
        } else if (password.length < 6) {
            binding.passwordEditText.error = "La contraseña debe tener al menos 6 caracteres"
            isValid = false
        }
        
        return isValid
    }
}

