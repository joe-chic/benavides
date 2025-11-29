package jonathan.humphreys.benavidesapp.ui.patient.fragments

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.button.MaterialButton
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.Appointment
import jonathan.humphreys.benavidesapp.databinding.FragmentAppointmentsBinding
import jonathan.humphreys.benavidesapp.ui.patient.adapters.AppointmentAdapter
import jonathan.humphreys.benavidesapp.ui.patient.decorations.VerticalSpacingItemDecoration
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AppointmentsFragment : Fragment() {
    private var _binding: FragmentAppointmentsBinding? = null
    private val binding get() = _binding!!

    private lateinit var prefsHelper: SharedPreferencesHelper
    private lateinit var appointmentAdapter: AppointmentAdapter

    private var allAppointments: List<Appointment> = emptyList()
    private var filteredAppointments: List<Appointment> = emptyList()
    private var currentPage = 1
    private var totalPages = 1
    private val pageSize = 5
    private val visibleButtons = 3

    companion object {
        private const val TAG = "AppointmentsFragment"
        private val INPUT_FORMATS = listOf(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ssXXX",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ssXXX",
            "yyyy-MM-dd HH:mm:ss"
        )
        private val GROUP_FORMAT = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentAppointmentsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prefsHelper = SharedPreferencesHelper(requireContext())
        setupRecyclerView()
        setupSearchBar()
        setupControls()
        loadAppointments()
    }

    private fun setupRecyclerView() {
        appointmentAdapter = AppointmentAdapter(emptyMap()) { appointment ->
            Toast.makeText(
                requireContext(),
                "Cita: ${appointment.reason ?: "sin motivo"}",
                Toast.LENGTH_SHORT
            ).show()
        }

        binding.appointmentsRecyclerView.apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = appointmentAdapter
            addItemDecoration(
                VerticalSpacingItemDecoration(
                    resources.getDimensionPixelSize(R.dimen.prescription_card_spacing)
                )
            )
        }
    }

    private fun setupSearchBar() {
        binding.searchBar.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                filterAppointments(s.toString())
            }

            override fun afterTextChanged(s: Editable?) {}
        })
    }

    private fun setupControls() {
        binding.filterButton.setOnClickListener {
            Toast.makeText(requireContext(), "Filtros en desarrollo", Toast.LENGTH_SHORT).show()
        }
        binding.createAppointmentButton.setOnClickListener {
            Toast.makeText(requireContext(), "Crear cita próximamente", Toast.LENGTH_SHORT).show()
        }
    }

    private fun loadAppointments() {
        val token = prefsHelper.getAccessToken()
        val userId = prefsHelper.getUserId()

        if (token == null || userId == null) {
            Toast.makeText(requireContext(), "No se encontró token de autenticación", Toast.LENGTH_SHORT).show()
            return
        }

        binding.progressBar.visibility = View.VISIBLE
        lifecycleScope.launch {
            try {
                val response = RetrofitClient.appointmentApiService.getAppointments(
                    token = "Bearer $token",
                    patientId = userId,
                    skip = 0,
                    limit = 200
                )

                if (response.isSuccessful && response.body() != null) {
                    allAppointments = response.body()!!
                        .sortedByDescending { appointment ->
                            parseDate(appointment.appointmentDateTime)?.time ?: 0L
                        }
                    filteredAppointments = allAppointments
                    currentPage = 1
                    updatePaginationState()
                } else {
                    Toast.makeText(requireContext(), "Error al cargar citas", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error loading appointments", e)
                Toast.makeText(requireContext(), "Error de conexión: ${e.message}", Toast.LENGTH_SHORT).show()
            } finally {
                binding.progressBar.visibility = View.GONE
                binding.paginationProgress.visibility = View.GONE
            }
        }
    }

    private fun filterAppointments(query: String) {
        filteredAppointments = if (query.isBlank()) {
            allAppointments
        } else {
            allAppointments.filter { appointment ->
                appointment.reason?.contains(query, ignoreCase = true) == true ||
                    appointment.doctorName?.contains(query, ignoreCase = true) == true ||
                    appointment.status?.contains(query, ignoreCase = true) == true ||
                    appointment.appointmentDateTime?.contains(query, ignoreCase = true) == true
            }
        }
        currentPage = 1
        updatePaginationState()
    }

    private fun updatePaginationState() {
        totalPages = if (filteredAppointments.isEmpty()) {
            1
        } else {
            (filteredAppointments.size + pageSize - 1) / pageSize
        }
        currentPage = currentPage.coerceIn(1, totalPages)
        renderCurrentPage()
        updatePaginationControls()
    }

    private fun renderCurrentPage() {
        if (filteredAppointments.isEmpty()) {
            appointmentAdapter.updateAppointments(emptyMap())
            binding.emptyState.visibility = View.VISIBLE
            binding.paginationContainer.visibility = View.GONE
            return
        }

        binding.emptyState.visibility = View.GONE
        val startIndex = (currentPage - 1) * pageSize
        val pageItems = filteredAppointments.drop(startIndex).take(pageSize)
        appointmentAdapter.updateAppointments(groupByDate(pageItems))
    }

    private fun updatePaginationControls() {
        val showControls = filteredAppointments.size > pageSize
        binding.paginationContainer.visibility = if (showControls) View.VISIBLE else View.GONE
        if (!showControls) return

        binding.prevPageButton.isEnabled = currentPage > 1
        binding.nextPageButton.isEnabled = currentPage < totalPages

        binding.prevPageButton.setOnClickListener { goToPage(currentPage - 1) }
        binding.nextPageButton.setOnClickListener { goToPage(currentPage + 1) }

        binding.pageButtonsContainer.removeAllViews()
        val startPage = ((currentPage - 1) / visibleButtons) * visibleButtons + 1
        val endPage = minOf(startPage + visibleButtons - 1, totalPages)

        for (page in startPage..endPage) {
            val button = MaterialButton(
                requireContext(),
                null,
                com.google.android.material.R.attr.materialButtonOutlinedStyle
            ).apply {
                text = page.toString()
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply {
                    val margin = resources.getDimensionPixelSize(R.dimen.spacing_small) / 2
                    marginStart = margin
                    marginEnd = margin
                }
                if (page == currentPage) {
                    backgroundTintList =
                        ContextCompat.getColorStateList(requireContext(), R.color.button_primary_bg)
                    setTextColor(ContextCompat.getColor(requireContext(), android.R.color.white))
                } else {
                    backgroundTintList =
                        ContextCompat.getColorStateList(requireContext(), android.R.color.white)
                    setTextColor(ContextCompat.getColor(requireContext(), R.color.text_dark))
                }
                setOnClickListener { goToPage(page) }
            }
            binding.pageButtonsContainer.addView(button)
        }
    }

    private fun goToPage(page: Int) {
        if (page in 1..totalPages) {
            currentPage = page
            renderCurrentPage()
            updatePaginationControls()
        }
    }

    private fun groupByDate(list: List<Appointment>): Map<String, List<Appointment>> {
        return list.groupBy { appointment ->
            appointment.appointmentDateTime?.let { dateStr ->
                val parsed = parseDate(dateStr)
                parsed?.let { GROUP_FORMAT.format(it) } ?: "Fecha desconocida"
            } ?: "Fecha desconocida"
        }
    }

    private fun parseDate(dateStr: String?): Date? {
        if (dateStr.isNullOrBlank()) return null
        INPUT_FORMATS.forEach { pattern ->
            try {
                val formatter = SimpleDateFormat(pattern, Locale.getDefault())
                return formatter.parse(dateStr)
            } catch (_: Exception) {
            }
        }
        return null
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

