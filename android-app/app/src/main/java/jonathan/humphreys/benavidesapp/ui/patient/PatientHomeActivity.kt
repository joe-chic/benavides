package jonathan.humphreys.benavidesapp.ui.patient

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.drawerlayout.widget.DrawerLayout
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.databinding.ActivityPatientHomeBinding
import jonathan.humphreys.benavidesapp.ui.login.LoginActivity
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper

class PatientHomeActivity : AppCompatActivity() {
    private lateinit var binding: ActivityPatientHomeBinding
    private lateinit var prefsHelper: SharedPreferencesHelper
    private var isSidebarOpen = false
    
    companion object {
        private const val TAG = "PatientHomeActivity"
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate: Starting PatientHomeActivity")
        binding = ActivityPatientHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        Log.d(TAG, "onCreate: View binding completed")
        
        prefsHelper = SharedPreferencesHelper(this)
        
        setupViews()
        
        // Initialize sidebar off-screen after layout is complete
        binding.sidebar.post {
            val sidebarWidthPx = 269f * resources.displayMetrics.density
            binding.sidebar.translationX = -sidebarWidthPx
            Log.d(TAG, "Sidebar initialized off-screen at translationX: -$sidebarWidthPx")
            Log.d(TAG, "Sidebar visibility: ${binding.sidebar.visibility}, width: ${binding.sidebar.width}")
        }
        
        // Close sidebar when overlay is clicked
        binding.sidebarOverlay.setOnClickListener {
            Log.d(TAG, "Sidebar overlay clicked")
            closeSidebar()
        }
        
        Log.d(TAG, "onCreate: Setup complete")
    }
    
    private fun setupViews() {
        Log.d(TAG, "setupViews: Setting up views")
        
        // Set up click listener on the container (which has the full 56dp touch area)
        binding.hamburgerIconContainer.setOnClickListener {
            Log.d(TAG, "Hamburger icon container clicked!")
            toggleSidebar()
        }
        
        Log.d(TAG, "Hamburger icon container setup - clickable: ${binding.hamburgerIconContainer.isClickable}, enabled: ${binding.hamburgerIconContainer.isEnabled}")
        
        // Sidebar menu items
        binding.sidebarEstudiosResultados.setOnClickListener {
            updateTitleFromSidebar("Estudios y resultados")
            // TODO: Navigate to studies and results
            closeSidebar()
        }
        
        binding.sidebarSignosVitales.setOnClickListener {
            updateTitleFromSidebar("Signos vitales")
            // TODO: Navigate to vital signs
            closeSidebar()
        }
        
        binding.sidebarConfiguracion.setOnClickListener {
            updateTitleFromSidebar("Configuración")
            // TODO: Navigate to settings
            closeSidebar()
        }
        
        binding.sidebarCerrarSesion.setOnClickListener {
            logout()
        }
        
        // Bottom navigation
        binding.bottomNavHome.setOnClickListener {
            navigateToView("home")
        }
        
        binding.bottomNavPrescriptions.setOnClickListener {
            navigateToView("prescriptions")
        }
        
        binding.bottomNavAppointments.setOnClickListener {
            navigateToView("appointments")
        }
        
        binding.bottomNavMedicalHistory.setOnClickListener {
            navigateToView("medical_history")
        }
        
        // Set home as active initially
        navigateToView("home")
    }
    
    private fun toggleSidebar() {
        Log.d(TAG, "toggleSidebar: isSidebarOpen=$isSidebarOpen")
        if (isSidebarOpen) {
            closeSidebar()
        } else {
            openSidebar()
        }
    }
    
    private fun openSidebar() {
        Log.d(TAG, "openSidebar: Starting to open sidebar")
        
        // Position sidebar off-screen first
        val sidebarWidthPx = 269f * resources.displayMetrics.density
        Log.d(TAG, "openSidebar: Sidebar width in px: $sidebarWidthPx")
        
        binding.sidebar.translationX = -sidebarWidthPx
        Log.d(TAG, "openSidebar: Sidebar positioned off-screen at translationX: -$sidebarWidthPx")
        
        // Show overlay first
        binding.sidebarOverlay.visibility = View.VISIBLE
        binding.sidebarOverlay.bringToFront()
        Log.d(TAG, "openSidebar: Overlay made visible and brought to front")
        
        // Make sidebar visible and bring to front
        binding.sidebar.visibility = View.VISIBLE
        binding.sidebar.bringToFront()
        Log.d(TAG, "openSidebar: Sidebar made visible and brought to front")
        Log.d(TAG, "openSidebar: Sidebar current visibility: ${binding.sidebar.visibility}, translationX: ${binding.sidebar.translationX}")
        
        // Animate sidebar sliding in from left
        binding.sidebar.post {
            Log.d(TAG, "openSidebar: Starting animation")
            binding.sidebar.animate()
                .translationX(0f)
                .setDuration(300)
                .withStartAction {
                    Log.d(TAG, "openSidebar: Animation started")
                }
                .withEndAction {
                    Log.d(TAG, "openSidebar: Animation ended, sidebar should be visible")
                }
                .start()
        }
        isSidebarOpen = true
        Log.d(TAG, "openSidebar: isSidebarOpen set to true")
    }
    
    private fun closeSidebar() {
        Log.d(TAG, "closeSidebar: Starting to close sidebar")
        // Animate sidebar sliding out to left
        val sidebarWidthPx = -269f * resources.displayMetrics.density
        binding.sidebar.animate()
            .translationX(sidebarWidthPx)
            .setDuration(300)
            .withStartAction {
                Log.d(TAG, "closeSidebar: Animation started")
            }
            .withEndAction {
                Log.d(TAG, "closeSidebar: Animation ended, hiding sidebar")
                binding.sidebar.visibility = View.INVISIBLE
                binding.sidebarOverlay.visibility = View.GONE
            }
            .start()
        isSidebarOpen = false
        Log.d(TAG, "closeSidebar: isSidebarOpen set to false")
    }
    
    private fun navigateToView(viewName: String) {
        Log.d(TAG, "navigateToView: $viewName")
        
        // Reset all icons to inactive state (gray/transparent)
        setIconColor(binding.bottomNavHome, false)
        setIconColor(binding.bottomNavPrescriptions, false)
        setIconColor(binding.bottomNavAppointments, false)
        setIconColor(binding.bottomNavMedicalHistory, false)
        
        // Update title based on view
        val titleText = when (viewName) {
            "home" -> getString(R.string.home)
            "prescriptions" -> getString(R.string.prescriptions)
            "appointments" -> getString(R.string.appointments)
            "medical_history" -> getString(R.string.medical_history)
            else -> getString(R.string.home)
        }
        binding.titleText.text = titleText
        
        // Set active icon color
        when (viewName) {
            "home" -> setIconColor(binding.bottomNavHome, true)
            "prescriptions" -> setIconColor(binding.bottomNavPrescriptions, true)
            "appointments" -> setIconColor(binding.bottomNavAppointments, true)
            "medical_history" -> setIconColor(binding.bottomNavMedicalHistory, true)
        }
        
        // TODO: Update main content area based on view
        // For now, just show placeholder
    }
    
    private fun setIconColor(imageView: ImageView, isActive: Boolean) {
        if (isActive) {
            // Active color: #3894FF
            imageView.setColorFilter(android.graphics.Color.parseColor("#3894FF"))
            imageView.alpha = 1.0f
        } else {
            // Inactive: remove color filter to show original, but with reduced opacity
            imageView.clearColorFilter()
            imageView.alpha = 0.5f
        }
    }
    
    private fun updateTitleFromSidebar(title: String) {
        Log.d(TAG, "updateTitleFromSidebar: $title")
        binding.titleText.text = title
    }
    
    private fun logout() {
        prefsHelper.clearTokens()
        prefsHelper.clearUserInfo()
        
        val intent = Intent(this, LoginActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        startActivity(intent)
        finish()
    }
    
    override fun onBackPressed() {
        if (isSidebarOpen) {
            closeSidebar()
        } else {
            super.onBackPressed()
        }
    }
}

