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
import jonathan.humphreys.benavidesapp.data.model.Prescription
import jonathan.humphreys.benavidesapp.data.repository.AuthRepository
import jonathan.humphreys.benavidesapp.databinding.FragmentPrescriptionsBinding
import jonathan.humphreys.benavidesapp.ui.patient.adapters.PrescriptionAdapter
import jonathan.humphreys.benavidesapp.ui.patient.decorations.VerticalSpacingItemDecoration
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PrescriptionsFragment : Fragment() {
    private var _binding: FragmentPrescriptionsBinding? = null
    private val binding get() = _binding!!
    private lateinit var prefsHelper: SharedPreferencesHelper
    private lateinit var prescriptionAdapter: PrescriptionAdapter

    private var allPrescriptions: List<Prescription> = emptyList()
    private var filteredPrescriptions: List<Prescription> = emptyList()
    private var currentPage = 1
    private var totalPages = 1
    private val pageSize = 5
    private val visibleButtons = 3

    companion object {
        private const val TAG = "PrescriptionsFragment"
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentPrescriptionsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prefsHelper = SharedPreferencesHelper(requireContext())
        setupRecyclerView()
        setupSearchBar()
        setupFilters()
        loadPrescriptions()
    }

    private fun setupRecyclerView() {
        prescriptionAdapter = PrescriptionAdapter(emptyMap()) { prescription ->
            Toast.makeText(requireContext(), "Prescription: ${prescription.prescriptionCode}", Toast.LENGTH_SHORT).show()
        }

        binding.prescriptionsRecyclerView.apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = prescriptionAdapter
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
                filterPrescriptions(s.toString())
            }

            override fun afterTextChanged(s: Editable?) {}
        })
    }

    private fun setupFilters() {
        binding.filterButton.setOnClickListener {
            // TODO: Show real filter dialog
            Toast.makeText(requireContext(), "Filtros", Toast.LENGTH_SHORT).show()
        }
    }

    private fun loadPrescriptions() {
        val userId = prefsHelper.getUserId()

        if (userId == null) {
            Toast.makeText(requireContext(), "Error: sesión inválida", Toast.LENGTH_SHORT).show()
            return
        }

        binding.progressBar.visibility = View.VISIBLE
        lifecycleScope.launch {
            try {
                val response = AuthRepository.authenticatedRequest(prefsHelper) { authHeader ->
                    RetrofitClient.prescriptionApiService.getPrescriptions(
                        authHeader,
                        patientId = userId,
                        skip = 0,
                        limit = 100
                    )
                }

                if (response == null) {
                    Toast.makeText(requireContext(), "Error: sesión inválida", Toast.LENGTH_SHORT).show()
                } else if (response.isSuccessful && response.body() != null) {
                    allPrescriptions = response.body()!!.sortedByDescending { prescription ->
                        prescription.createdAt?.let { dateStr ->
                            try {
                                SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).parse(dateStr)?.time
                            } catch (e: Exception) {
                                null
                            }
                        } ?: 0L
                    }
                    filteredPrescriptions = allPrescriptions
                    currentPage = 1
                    updatePaginationState()
                } else if (response.code() == 401) {
                    Toast.makeText(requireContext(), "Sesión expirada. Inicia sesión nuevamente.", Toast.LENGTH_SHORT).show()
                } else {
                    Toast.makeText(requireContext(), "Error al cargar prescripciones", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error loading prescriptions", e)
                Toast.makeText(requireContext(), "Error de conexión: ${e.message}", Toast.LENGTH_SHORT).show()
            } finally {
                binding.progressBar.visibility = View.GONE
                binding.paginationProgress.visibility = View.GONE
            }
        }
    }

    private fun filterPrescriptions(query: String) {
        filteredPrescriptions = if (query.isBlank()) {
            allPrescriptions
        } else {
            allPrescriptions.filter {
                it.prescriptionCode.contains(query, ignoreCase = true) ||
                    it.createdAt?.contains(query, ignoreCase = true) == true
            }
        }
        currentPage = 1
        updatePaginationState()
    }

    private fun updatePaginationState() {
        totalPages =
            if (filteredPrescriptions.isEmpty()) 1 else ((filteredPrescriptions.size + pageSize - 1) / pageSize)
        currentPage = currentPage.coerceIn(1, totalPages)
        renderCurrentPage()
        updatePaginationControls()
    }

    private fun renderCurrentPage() {
        if (filteredPrescriptions.isEmpty()) {
            prescriptionAdapter.updatePrescriptions(emptyMap())
            binding.emptyState.visibility = View.VISIBLE
            binding.paginationContainer.visibility = View.GONE
            return
        }
        binding.emptyState.visibility = View.GONE
        val startIndex = (currentPage - 1) * pageSize
        val pageItems = filteredPrescriptions.drop(startIndex).take(pageSize)
        val groupedPrescriptions = groupByDate(pageItems)
        prescriptionAdapter.updatePrescriptions(groupedPrescriptions)
    }

    private fun updatePaginationControls() {
        val showControls = filteredPrescriptions.size > pageSize
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

    private fun groupByDate(list: List<Prescription>): Map<String, List<Prescription>> {
        return list.groupBy { prescription ->
            prescription.createdAt?.let { dateStr ->
                val normalized = dateStr.replace('T', ' ')
                val datePart = normalized.substringBefore(' ')
                try {
                    val parsed = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).parse(datePart)
                    SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(parsed ?: Date())
                } catch (e: Exception) {
                    "Fecha desconocida"
                }
            } ?: "Fecha desconocida"
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

