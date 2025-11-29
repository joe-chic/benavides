package jonathan.humphreys.benavidesapp.ui.patient.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.AllergyEntry
import jonathan.humphreys.benavidesapp.data.model.ClinicalHistoryResponse
import jonathan.humphreys.benavidesapp.data.model.ConditionEntry
import jonathan.humphreys.benavidesapp.data.model.FamilyHistoryEntry
import jonathan.humphreys.benavidesapp.data.model.PersonalInfoResponse
import jonathan.humphreys.benavidesapp.data.model.ProcedureEntry
import jonathan.humphreys.benavidesapp.databinding.FragmentMedicalHistoryBinding
import jonathan.humphreys.benavidesapp.databinding.ViewHistoryEntryBinding
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import jonathan.humphreys.benavidesapp.ui.patient.fragments.HistoryDetailType
import jonathan.humphreys.benavidesapp.ui.patient.fragments.HistoryDetailFragment
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MedicalHistoryFragment : Fragment() {

    private var _binding: FragmentMedicalHistoryBinding? = null
    private val binding get() = _binding!!

    private lateinit var prefsHelper: SharedPreferencesHelper

    private val datePatterns = listOf(
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
        "yyyy-MM-dd'T'HH:mm:ss.SSSX",
        "yyyy-MM-dd'T'HH:mm:ssXXX",
        "yyyy-MM-dd'T'HH:mm:ssX",
        "yyyy-MM-dd HH:mm:ssXXX",
        "yyyy-MM-dd HH:mm:ssX",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd"
    )

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMedicalHistoryBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prefsHelper = SharedPreferencesHelper(requireContext())

        binding.filterButton.setOnClickListener {
            Toast.makeText(requireContext(), "Filtros disponibles próximamente", Toast.LENGTH_SHORT).show()
        }

        binding.conditionsViewAllButton.setOnClickListener {
            openDetail(HistoryDetailType.CONDITIONS)
        }
        binding.allergiesViewAllButton.setOnClickListener {
            openDetail(HistoryDetailType.ALLERGIES)
        }
        binding.proceduresViewAllButton.setOnClickListener {
            openDetail(HistoryDetailType.PROCEDURES)
        }
        binding.familyViewAllButton.setOnClickListener {
            openDetail(HistoryDetailType.FAMILY)
        }

        loadPersonalInfo()
        loadClinicalHistory()
    }

    private fun openDetail(type: HistoryDetailType) {
        parentFragmentManager.beginTransaction()
            .replace(R.id.mainContent, HistoryDetailFragment.newInstance(type))
            .addToBackStack("HistoryDetail")
            .commit()
    }

    private fun loadPersonalInfo() {
        val token = prefsHelper.getAccessToken()
        val patientId = prefsHelper.getUserId()

        if (token.isNullOrBlank() || patientId.isNullOrBlank()) {
            Toast.makeText(requireContext(), "No se encontró la sesión del paciente", Toast.LENGTH_SHORT).show()
            return
        }

        lifecycleScope.launch {
            try {
                val response = RetrofitClient.patientApiService.getPersonalInfo(
                    token = "Bearer $token",
                    patientId = patientId
                )
                if (response.isSuccessful && response.body() != null) {
                    bindPersonalInfo(response.body()!!)
                } else {
                    Toast.makeText(requireContext(), "No se pudo cargar la información personal", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "Error de conexión al cargar expediente", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun loadClinicalHistory() {
        val token = prefsHelper.getAccessToken()
        val patientId = prefsHelper.getUserId()

        if (token.isNullOrBlank() || patientId.isNullOrBlank()) {
            Toast.makeText(requireContext(), "No se encontró la sesión del paciente", Toast.LENGTH_SHORT).show()
            return
        }

        lifecycleScope.launch {
            try {
                val response = RetrofitClient.patientApiService.getClinicalHistory(
                    token = "Bearer $token",
                    patientId = patientId
                )
                if (response.isSuccessful && response.body() != null) {
                    bindClinicalHistory(response.body()!!)
                } else {
                    Toast.makeText(requireContext(), "No se pudo cargar el historial clínico", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                Toast.makeText(requireContext(), "Error al obtener el historial clínico", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun bindPersonalInfo(info: PersonalInfoResponse) {
        binding.patientName.text = info.fullName ?: "Paciente sin nombre"
        binding.patientId.text = "ID paciente: ${info.patientId}"
        binding.birthDateValue.text = "Nacimiento: ${formatLongDate(info.dateOfBirth)}"
        binding.genderValue.text = "Sexo: ${info.gender ?: "--"}"
        binding.phoneValue.text = "Teléfono: ${info.phone ?: "--"}"
        binding.emailValue.text = "Correo: ${info.email ?: "--"}"
        binding.addressValue.text = "Dirección: ${formatAddress(info)}"
    }

    private fun bindClinicalHistory(data: ClinicalHistoryResponse) {
        bindConditions(data.conditions)
        bindAllergies(data.allergies)
        bindProcedures(data.procedures)
        bindFamilyHistory(data.familyHistory)
    }

    private fun bindConditions(conditions: List<ConditionEntry>) {
        val sorted = conditions.sortedByDescending { it.recordedAt ?: it.onsetDate }
        val activeCount = conditions.count { it.verificationStatus.equals("confirmed", true) }
        binding.conditionsChipCount.text = "${conditions.size} registradas"
        binding.conditionsChipUpdated.text = if (sorted.isNotEmpty()) {
            "Última: ${formatShortDate(sorted.first().recordedAt ?: sorted.first().onsetDate)}"
        } else {
            "Última: --"
        }
        binding.conditionsListContainer.removeAllViews()

        if (sorted.isEmpty()) {
            addEmptyState(binding.conditionsListContainer, "Sin antecedentes registrados")
        } else {
            sorted.take(2).forEach { condition ->
                val title = condition.codeDisplay ?: "Condición sin nombre"
                val details = buildList {
                    condition.verificationStatus?.let { add("Estado: ${translateStatus(it)}") }
                    condition.onsetDate?.let { add("Inicio: ${formatShortDate(it)}") }
                    add("Activa: ${if (condition.verificationStatus?.equals("confirmed", true) == true) "Sí" else "No"}")
                }.joinToString(" · ")
                addEntry(binding.conditionsListContainer, title, details)
            }
        }

        binding.conditionsViewAllButton.setOnClickListener { openDetail(HistoryDetailType.CONDITIONS) }
    }

    private fun bindAllergies(allergies: List<AllergyEntry>) {
        val sorted = allergies.sortedByDescending { it.recordedAt }
        val severeCount = allergies.count { it.severity.equals("severe", true) }
        binding.allergiesChipCount.text = "${allergies.size} alergias"
        binding.allergiesChipCritical.text = "$severeCount severas"
        binding.allergiesListContainer.removeAllViews()

        if (sorted.isEmpty()) {
            addEmptyState(binding.allergiesListContainer, "Sin alergias registradas")
        } else {
            sorted.take(2).forEach { allergy ->
                val title = allergy.substanceDisplay ?: "Alergia sin nombre"
                val details = buildList {
                    allergy.severity?.let { add("Severidad: ${translateSeverity(it)}") }
                    allergy.reaction?.let { add(it) }
                    allergy.status?.let { add("Estado: ${translateStatus(it)}") }
                }.joinToString(" · ").ifBlank { "Sin detalles adicionales" }
                addEntry(binding.allergiesListContainer, title, details)
            }
        }

    }

    private fun bindProcedures(procedures: List<ProcedureEntry>) {
        val sorted = procedures.sortedByDescending { it.performedOn ?: it.recordedAt }
        binding.proceduresChipCount.text = "${procedures.size} estudios"
        binding.proceduresChipRecent.text = if (sorted.isNotEmpty()) {
            "Último: ${formatShortDate(sorted.first().performedOn ?: sorted.first().recordedAt)}"
        } else {
            "Último: --"
        }
        binding.proceduresListContainer.removeAllViews()

        if (sorted.isEmpty()) {
            addEmptyState(binding.proceduresListContainer, "Sin procedimientos registrados")
        } else {
            sorted.take(2).forEach { procedure ->
                val title = procedure.procedureDisplay ?: "Procedimiento sin nombre"
                val details = buildList {
                    procedure.performedOn?.let { add(formatShortDate(it)) }
                    procedure.facility?.let { add(it) }
                    procedure.note?.let { add(it) }
                }.joinToString(" · ").ifBlank { "Sin detalles adicionales" }
                addEntry(binding.proceduresListContainer, title, details)
            }
        }

    }

    private fun bindFamilyHistory(familyHistory: List<FamilyHistoryEntry>) {
        val sorted = familyHistory.sortedByDescending { it.recordedAt }
        val deceasedCount = familyHistory.count { it.relativeIsDeceased == true }
        binding.familyChipCount.text = "${familyHistory.size} registros"
        binding.familyChipDeceased.text = "Fallecidos: $deceasedCount"
        binding.familyListContainer.removeAllViews()

        if (sorted.isEmpty()) {
            addEmptyState(binding.familyListContainer, "Sin historial familiar registrado")
        } else {
            sorted.take(2).forEach { fam ->
                val title = buildString {
                    append(translateRelationship(fam.relationshipType))
                    fam.conditionDisplay?.let { append(" — $it") }
                }
                val details = buildList {
                    fam.verificationStatus?.let { add("Estado: ${translateStatus(it)}") }
                    fam.relativeAgeOfConsent?.let { add("Edad: $it") }
                    fam.relativeIsDeceased?.let { add("Fallecido: ${if (it) "Sí" else "No"}") }
                    fam.note?.let { add(it) }
                }.joinToString(" · ").ifBlank { "Sin detalles adicionales" }
                addEntry(binding.familyListContainer, title, details)
            }
        }

    }

    private fun addEntry(container: LinearLayout, title: String, subtitle: String) {
        val entryBinding = ViewHistoryEntryBinding.inflate(LayoutInflater.from(container.context), container, false)
        entryBinding.titleText.text = title
        entryBinding.subtitleText.text = subtitle
        container.addView(entryBinding.root)
    }

    private fun addEmptyState(container: LinearLayout, message: String) {
        val emptyView = TextView(container.context).apply {
            text = message
            setTextColor(resources.getColor(android.R.color.darker_gray, context.theme))
            textSize = 14f
        }
        container.addView(emptyView)
    }

    private fun formatAddress(info: PersonalInfoResponse): String {
        val addressParts = listOfNotNull(
            info.addressLine,
            listOfNotNull(info.city, info.state).filter { it.isNotBlank() }.joinToString(separator = ", ").takeIf { it.isNotBlank() },
            info.postalCode,
            info.country
        ).filter { it.isNotBlank() }

        return if (addressParts.isEmpty()) "--" else addressParts.joinToString(", ")
    }

    private fun formatLongDate(date: String?): String {
        val parsed = parseDateFlexible(date) ?: return "--"
        return SimpleDateFormat("dd 'de' MMMM yyyy", Locale("es", "MX")).format(parsed)
    }

    private fun formatShortDate(date: String?): String {
        val parsed = parseDateFlexible(date) ?: return "--"
        return SimpleDateFormat("dd MMM yyyy", Locale("es", "MX")).format(parsed)
    }

    private fun parseDateFlexible(value: String?): Date? {
        if (value.isNullOrBlank()) return null
        datePatterns.forEach { pattern ->
            try {
                val parser = SimpleDateFormat(pattern, Locale.US)
                return parser.parse(value)
            } catch (_: Exception) {
            }
        }
        return null
    }

    private fun translateStatus(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "confirmed" -> "Confirmada"
            "active" -> "Activa"
            "resolved" -> "Resuelta"
            "inactive" -> "Inactiva"
            "provisional" -> "Provisional"
            else -> value ?: "--"
        }
    }

    private fun translateSeverity(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "severe" -> "Severa"
            "moderate" -> "Moderada"
            "mild" -> "Leve"
            else -> value ?: "--"
        }
    }

    private fun translateRelationship(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "mother", "madre" -> "Madre"
            "father", "padre" -> "Padre"
            "sibling", "hermano", "hermana" -> "Hermano"
            "grandparent", "abuelo", "abuela" -> "Abuelo"
            else -> value?.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
                ?: "Familiar"
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

