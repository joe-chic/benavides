package jonathan.humphreys.benavidesapp.ui.patient.fragments

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
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
import jonathan.humphreys.benavidesapp.data.model.AllergyEntry
import jonathan.humphreys.benavidesapp.data.model.ClinicalHistoryResponse
import jonathan.humphreys.benavidesapp.data.model.ConditionEntry
import jonathan.humphreys.benavidesapp.data.model.FamilyHistoryEntry
import jonathan.humphreys.benavidesapp.data.model.ProcedureEntry
import jonathan.humphreys.benavidesapp.databinding.FragmentHistoryDetailBinding
import jonathan.humphreys.benavidesapp.ui.patient.adapters.HistoryDetailAdapter
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import jonathan.humphreys.benavidesapp.data.repository.AuthRepository
import kotlinx.coroutines.launch

class HistoryDetailFragment : Fragment() {

    companion object {
        private const val ARG_TYPE = "arg_type"

        fun newInstance(type: HistoryDetailType): HistoryDetailFragment {
            val fragment = HistoryDetailFragment()
            fragment.arguments = Bundle().apply {
                putString(ARG_TYPE, type.name)
            }
            return fragment
        }
    }

    private var _binding: FragmentHistoryDetailBinding? = null
    private val binding get() = _binding!!

    private lateinit var prefsHelper: SharedPreferencesHelper
    private lateinit var adapter: HistoryDetailAdapter
    private lateinit var historyType: HistoryDetailType

    private var allConditions: List<ConditionEntry> = emptyList()
    private var filteredConditions: List<ConditionEntry> = emptyList()

    private var allAllergies: List<AllergyEntry> = emptyList()
    private var filteredAllergies: List<AllergyEntry> = emptyList()

    private var allProcedures: List<ProcedureEntry> = emptyList()
    private var filteredProcedures: List<ProcedureEntry> = emptyList()

    private var allFamilyEntries: List<FamilyHistoryEntry> = emptyList()
    private var filteredFamilyEntries: List<FamilyHistoryEntry> = emptyList()

    private var currentPage = 1
    private var totalPages = 1
    private val pageSize = 5
    private val visibleButtons = 3

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val typeString = arguments?.getString(ARG_TYPE) ?: HistoryDetailType.CONDITIONS.name
        historyType = HistoryDetailType.valueOf(typeString)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHistoryDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prefsHelper = SharedPreferencesHelper(requireContext())
        setupUI()
        fetchHistory()
    }

    private fun setupUI() {
        val sectionText = when (historyType) {
            HistoryDetailType.CONDITIONS -> "Antecedentes y Condiciones"
            HistoryDetailType.ALLERGIES -> "Alergias"
            HistoryDetailType.PROCEDURES -> "Procedimientos"
            HistoryDetailType.FAMILY -> "Historial familiar"
        }
        binding.sectionTitle.text = sectionText
        binding.detailSectionHeader.text = sectionText

        binding.backButton.setOnClickListener {
            parentFragmentManager.popBackStack()
        }

        binding.detailFilterButton.setOnClickListener {
            Toast.makeText(requireContext(), "Filtros disponibles próximamente", Toast.LENGTH_SHORT).show()
        }

        adapter = HistoryDetailAdapter(historyType)
        binding.detailRecyclerView.layoutManager = LinearLayoutManager(requireContext())
        binding.detailRecyclerView.adapter = adapter

        binding.detailSearchInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                filterList(s?.toString().orEmpty())
            }
            override fun afterTextChanged(s: Editable?) {}
        })
    }

    private fun fetchHistory() {
        val patientId = prefsHelper.getUserId()

        if (patientId.isNullOrBlank()) {
            Toast.makeText(requireContext(), "Sesión inválida, vuelve a iniciar sesión", Toast.LENGTH_SHORT).show()
            return
        }

        binding.detailRecyclerView.visibility = View.GONE
        binding.detailEmptyState.visibility = View.GONE

        lifecycleScope.launch {
            try {
                val response = AuthRepository.authenticatedRequest(prefsHelper) { authHeader ->
                    RetrofitClient.patientApiService.getClinicalHistory(
                        token = authHeader,
                        patientId = patientId
                    )
                }
                if (response == null) {
                    Toast.makeText(requireContext(), "Sesión inválida", Toast.LENGTH_SHORT).show()
                } else if (response.isSuccessful && response.body() != null) {
                    bindHistory(response.body()!!)
                } else if (response.code() == 401) {
                    Toast.makeText(requireContext(), "Sesión expirada, vuelve a iniciar sesión", Toast.LENGTH_SHORT).show()
                } else {
                    binding.detailEmptyState.visibility = View.VISIBLE
                }
            } catch (e: Exception) {
                binding.detailEmptyState.visibility = View.VISIBLE
                Toast.makeText(requireContext(), "No fue posible cargar los registros", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun bindHistory(history: ClinicalHistoryResponse) {
        when (historyType) {
            HistoryDetailType.CONDITIONS -> {
                allConditions = history.conditions
                filteredConditions = allConditions
                adapter.submitConditions(allConditions)
            }
            HistoryDetailType.ALLERGIES -> {
                allAllergies = history.allergies
                filteredAllergies = allAllergies
                adapter.submitAllergies(allAllergies)
            }
            HistoryDetailType.PROCEDURES -> {
                allProcedures = history.procedures
                filteredProcedures = allProcedures
                adapter.submitProcedures(allProcedures)
            }
            HistoryDetailType.FAMILY -> {
                allFamilyEntries = history.familyHistory
                filteredFamilyEntries = allFamilyEntries
                adapter.submitFamily(allFamilyEntries)
            }
        }
        currentPage = 1
        updatePaginationState()
    }

    private fun filterList(query: String) {
        when (historyType) {
            HistoryDetailType.CONDITIONS -> {
                filteredConditions = if (query.isBlank()) allConditions else {
                    allConditions.filter {
                        it.codeDisplay?.contains(query, true) == true ||
                            it.verificationStatus?.contains(query, true) == true ||
                            it.codeId?.contains(query, true) == true
                    }
                }
            }
            HistoryDetailType.ALLERGIES -> {
                filteredAllergies = if (query.isBlank()) allAllergies else {
                    allAllergies.filter {
                        it.substanceDisplay?.contains(query, true) == true ||
                            it.reaction?.contains(query, true) == true
                    }
                }
            }
            HistoryDetailType.PROCEDURES -> {
                filteredProcedures = if (query.isBlank()) allProcedures else {
                    allProcedures.filter {
                        it.procedureDisplay?.contains(query, true) == true ||
                            it.facility?.contains(query, true) == true ||
                            it.note?.contains(query, true) == true
                    }
                }
            }
            HistoryDetailType.FAMILY -> {
                filteredFamilyEntries = if (query.isBlank()) allFamilyEntries else {
                    allFamilyEntries.filter {
                        it.relationshipType?.contains(query, true) == true ||
                            it.conditionDisplay?.contains(query, true) == true ||
                            it.note?.contains(query, true) == true
                    }
                }
            }
        }
        currentPage = 1
        updatePaginationState()
    }

    private fun updatePaginationState() {
        val dataSize = when (historyType) {
            HistoryDetailType.CONDITIONS -> filteredConditions.size
            HistoryDetailType.ALLERGIES -> filteredAllergies.size
            HistoryDetailType.PROCEDURES -> filteredProcedures.size
            HistoryDetailType.FAMILY -> filteredFamilyEntries.size
        }

        totalPages = if (dataSize == 0) 1 else ((dataSize + pageSize - 1) / pageSize)
        currentPage = currentPage.coerceIn(1, totalPages)
        renderCurrentPage()
        updatePaginationControls(dataSize > pageSize)
    }

    private fun renderCurrentPage() {
        val list = when (historyType) {
            HistoryDetailType.CONDITIONS -> filteredConditions
            HistoryDetailType.ALLERGIES -> filteredAllergies
            HistoryDetailType.PROCEDURES -> filteredProcedures
            HistoryDetailType.FAMILY -> filteredFamilyEntries
        }

        if (list.isEmpty()) {
            binding.detailRecyclerView.visibility = View.GONE
            binding.detailEmptyState.visibility = View.VISIBLE
            adapter.submitConditions(emptyList())
            adapter.submitAllergies(emptyList())
            adapter.submitProcedures(emptyList())
            adapter.submitFamily(emptyList())
            return
        } else {
            binding.detailRecyclerView.visibility = View.VISIBLE
            binding.detailEmptyState.visibility = View.GONE
        }

        val pageItems = list.drop((currentPage - 1) * pageSize).take(pageSize)
        when (historyType) {
            HistoryDetailType.CONDITIONS -> adapter.submitConditions(pageItems as List<ConditionEntry>)
            HistoryDetailType.ALLERGIES -> adapter.submitAllergies(pageItems as List<AllergyEntry>)
            HistoryDetailType.PROCEDURES -> adapter.submitProcedures(pageItems as List<ProcedureEntry>)
            HistoryDetailType.FAMILY -> adapter.submitFamily(pageItems as List<FamilyHistoryEntry>)
        }
    }

    private fun updatePaginationControls(show: Boolean) {
        binding.detailPaginationContainer.visibility = if (show) View.VISIBLE else View.GONE
        if (!show) return

        binding.detailPrevButton.isEnabled = currentPage > 1
        binding.detailNextButton.isEnabled = currentPage < totalPages

        binding.detailPrevButton.setOnClickListener { goToPage(currentPage - 1) }
        binding.detailNextButton.setOnClickListener { goToPage(currentPage + 1) }

        binding.detailPageButtons.removeAllViews()

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
                    backgroundTintList = ContextCompat.getColorStateList(requireContext(), R.color.button_primary_bg)
                    setTextColor(ContextCompat.getColor(requireContext(), android.R.color.white))
                } else {
                    backgroundTintList = ContextCompat.getColorStateList(requireContext(), android.R.color.white)
                    setTextColor(ContextCompat.getColor(requireContext(), R.color.text_dark))
                }

                setOnClickListener { goToPage(page) }
            }
            binding.detailPageButtons.addView(button)
        }
    }

    private fun goToPage(page: Int) {
        if (page in 1..totalPages) {
            currentPage = page
            renderCurrentPage()
            updatePaginationControls(true)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

