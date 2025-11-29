package jonathan.humphreys.benavidesapp.ui.patient.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import jonathan.humphreys.benavidesapp.data.model.AllergyEntry
import jonathan.humphreys.benavidesapp.data.model.ConditionEntry
import jonathan.humphreys.benavidesapp.data.model.FamilyHistoryEntry
import jonathan.humphreys.benavidesapp.data.model.ProcedureEntry
import jonathan.humphreys.benavidesapp.databinding.ItemAllergyDetailBinding
import jonathan.humphreys.benavidesapp.databinding.ItemConditionDetailBinding
import jonathan.humphreys.benavidesapp.databinding.ItemFamilyDetailBinding
import jonathan.humphreys.benavidesapp.databinding.ItemProcedureDetailBinding
import jonathan.humphreys.benavidesapp.ui.patient.fragments.HistoryDetailType
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class HistoryDetailAdapter(
    private val type: HistoryDetailType
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private var conditionItems: List<ConditionEntry> = emptyList()
    private var allergyItems: List<AllergyEntry> = emptyList()
    private var procedureItems: List<ProcedureEntry> = emptyList()
    private var familyItems: List<FamilyHistoryEntry> = emptyList()

    private val parserPatterns = listOf(
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
        "yyyy-MM-dd'T'HH:mm:ss.SSSX",
        "yyyy-MM-dd'T'HH:mm:ssXXX",
        "yyyy-MM-dd'T'HH:mm:ssX",
        "yyyy-MM-dd HH:mm:ssXXX",
        "yyyy-MM-dd HH:mm:ssX",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd"
    )

    private val shortFormatter = SimpleDateFormat("dd MMM yyyy", Locale("es", "MX"))

    override fun getItemCount(): Int = when (type) {
        HistoryDetailType.CONDITIONS -> conditionItems.size
        HistoryDetailType.ALLERGIES -> allergyItems.size
        HistoryDetailType.PROCEDURES -> procedureItems.size
        HistoryDetailType.FAMILY -> familyItems.size
    }

    override fun getItemViewType(position: Int): Int = type.ordinal

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        return when (type) {
            HistoryDetailType.CONDITIONS -> ConditionViewHolder(
                ItemConditionDetailBinding.inflate(inflater, parent, false)
            )
            HistoryDetailType.ALLERGIES -> AllergyViewHolder(
                ItemAllergyDetailBinding.inflate(inflater, parent, false)
            )
            HistoryDetailType.PROCEDURES -> ProcedureViewHolder(
                ItemProcedureDetailBinding.inflate(inflater, parent, false)
            )
            HistoryDetailType.FAMILY -> FamilyViewHolder(
                ItemFamilyDetailBinding.inflate(inflater, parent, false)
            )
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (type) {
            HistoryDetailType.CONDITIONS -> (holder as ConditionViewHolder).bind(conditionItems[position])
            HistoryDetailType.ALLERGIES -> (holder as AllergyViewHolder).bind(allergyItems[position])
            HistoryDetailType.PROCEDURES -> (holder as ProcedureViewHolder).bind(procedureItems[position])
            HistoryDetailType.FAMILY -> (holder as FamilyViewHolder).bind(familyItems[position])
        }
    }

    fun submitConditions(items: List<ConditionEntry>) {
        conditionItems = items
        notifyDataSetChanged()
    }

    fun submitAllergies(items: List<AllergyEntry>) {
        allergyItems = items
        notifyDataSetChanged()
    }

    fun submitProcedures(items: List<ProcedureEntry>) {
        procedureItems = items
        notifyDataSetChanged()
    }

    fun submitFamily(items: List<FamilyHistoryEntry>) {
        familyItems = items
        notifyDataSetChanged()
    }

    private inner class ConditionViewHolder(
        private val binding: ItemConditionDetailBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: ConditionEntry) {
            binding.conditionTitle.text = item.codeDisplay ?: "Condición sin nombre"
            binding.conditionStatusChip.text = when (item.verificationStatus?.lowercase(Locale.getDefault())) {
                "confirmed" -> "Confirmada"
                "resolved" -> "Resuelta"
                "provisional" -> "Provisional"
                else -> item.verificationStatus ?: "Sin estado"
            }
            val onset = formatDate(item.onsetDate)
            val recorded = formatDate(item.recordedAt)
            binding.conditionDates.text = "Inicio: $onset · Registrado: $recorded"
            val detailText = listOfNotNull(
                item.verificationStatus?.let { "Estado: ${translateStatus(it)}" },
                item.codeId?.let { "Código: $it" }
            ).joinToString(" · ")
            binding.conditionNote.text = detailText.ifBlank { "Sin notas adicionales" }
        }
    }

    private inner class AllergyViewHolder(
        private val binding: ItemAllergyDetailBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: AllergyEntry) {
            binding.allergyTitle.text = item.substanceDisplay ?: "Alergia sin nombre"
            binding.allergySeverityChip.text = translateSeverity(item.severity)
            binding.allergyStatusChip.text = translateStatus(item.status)
            binding.allergyReaction.text = item.reaction ?: "Sin reacción documentada"
            binding.allergyDates.text = "Último evento: ${formatDate(item.recordedAt ?: item.recordedAt)}"
        }
    }

    private inner class ProcedureViewHolder(
        private val binding: ItemProcedureDetailBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: ProcedureEntry) {
            binding.procedureTitle.text = item.procedureDisplay ?: "Procedimiento sin nombre"
            binding.procedureDate.text = "Realizado: ${formatDate(item.performedOn ?: item.recordedAt)}"
            binding.procedureFacility.text = item.facility ?: "Centro no especificado"
            binding.procedureNote.text = item.note ?: "Sin notas adicionales"
        }
    }

    private inner class FamilyViewHolder(
        private val binding: ItemFamilyDetailBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: FamilyHistoryEntry) {
            binding.familyTitle.text = translateRelationship(item.relationshipType)
            binding.familyStatusChip.text = if (item.relativeIsDeceased == true) "Fallecido" else "Vivo"
            binding.familyCondition.text = item.conditionDisplay ?: "Condición no especificada"
            binding.familyNote.text = item.note ?: "Sin notas adicionales"
        }
    }

    private fun formatDate(value: String?): String {
        if (value.isNullOrBlank()) return "--"
        parserPatterns.forEach { pattern ->
            try {
                val parsed = SimpleDateFormat(pattern, Locale.US).parse(value)
                if (parsed != null) return shortFormatter.format(parsed)
            } catch (_: Exception) {
            }
        }
        return value
    }

    private fun translateSeverity(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "severe" -> "Severa"
            "moderate" -> "Moderada"
            "mild" -> "Leve"
            else -> value ?: "Sin datos"
        }
    }

    private fun translateStatus(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "active" -> "Activa"
            "inactive" -> "Inactiva"
            "resolved" -> "Resuelta"
            else -> value ?: "Sin estado"
        }
    }

    private fun translateRelationship(value: String?): String {
        return when (value?.lowercase(Locale.getDefault())) {
            "mother" -> "Madre"
            "father" -> "Padre"
            "sibling" -> "Hermano"
            "grandparent" -> "Abuelo"
            else -> value?.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
                ?: "Familiar"
        }
    }
}

