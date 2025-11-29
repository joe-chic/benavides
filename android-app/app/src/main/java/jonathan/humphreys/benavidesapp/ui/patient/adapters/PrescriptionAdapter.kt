package jonathan.humphreys.benavidesapp.ui.patient.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.data.model.Prescription
import jonathan.humphreys.benavidesapp.databinding.ItemPrescriptionCardBinding
import jonathan.humphreys.benavidesapp.databinding.ItemPrescriptionDateHeaderBinding

class PrescriptionAdapter(
    private var groupedPrescriptions: Map<String, List<Prescription>>,
    private val onPrescriptionClick: (Prescription) -> Unit
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    
    companion object {
        private const val TYPE_DATE_HEADER = 0
        private const val TYPE_PRESCRIPTION = 1
    }
    
    private val items = mutableListOf<Any>()
    
    init {
        updateItems()
    }
    
    fun updatePrescriptions(grouped: Map<String, List<Prescription>>) {
        groupedPrescriptions = grouped
        updateItems()
        notifyDataSetChanged()
    }
    
    private fun updateItems() {
        items.clear()
        groupedPrescriptions.entries.sortedByDescending { it.key }.forEach { (date, prescriptions) ->
            items.add(date) // Date header
            items.addAll(prescriptions) // Prescriptions for that date
        }
    }
    
    override fun getItemViewType(position: Int): Int {
        return when (items[position]) {
            is String -> TYPE_DATE_HEADER
            is Prescription -> TYPE_PRESCRIPTION
            else -> TYPE_PRESCRIPTION
        }
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            TYPE_DATE_HEADER -> {
                val binding = ItemPrescriptionDateHeaderBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                DateHeaderViewHolder(binding)
            }
            else -> {
                val binding = ItemPrescriptionCardBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                PrescriptionViewHolder(binding, onPrescriptionClick)
            }
        }
    }
    
    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is DateHeaderViewHolder -> {
                holder.bind(items[position] as String)
            }
            is PrescriptionViewHolder -> {
                holder.bind(items[position] as Prescription)
            }
        }
    }
    
    override fun getItemCount(): Int = items.size
    
    class DateHeaderViewHolder(
        private val binding: ItemPrescriptionDateHeaderBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(date: String) {
            binding.dateText.text = date
        }
    }
    
    class PrescriptionViewHolder(
        private val binding: ItemPrescriptionCardBinding,
        private val onPrescriptionClick: (Prescription) -> Unit
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(prescription: Prescription) {
            binding.prescriptionCode.text = prescription.prescriptionCode
            
            // Set medic name
            binding.medicoText.text = "Médico: ${prescription.medicName ?: "No disponible"}"
            
            // Set expiration date
            binding.expirationDateText.text = "Fecha de vencimiento: ${prescription.expirationDate ?: "No disponible"}"
            
            // Set total medicamentos
            val itemCount = prescription.itemCount ?: (prescription.items?.size ?: 0)
            binding.totalMedicamentosText.text = "Total medicamentos: $itemCount"
            
            // Set status badge
            val status = prescription.status ?: "vigente"
            binding.statusBadge.text = status
            when (status.lowercase()) {
                "vigente" -> binding.statusBadge.setBackgroundResource(R.drawable.bg_status_vigente)
                "dispensada" -> binding.statusBadge.setBackgroundResource(R.drawable.bg_status_dispensada)
                "vencida" -> binding.statusBadge.setBackgroundResource(R.drawable.bg_status_vencida)
                "cancelada" -> binding.statusBadge.setBackgroundResource(R.drawable.bg_status_cancelada)
                else -> binding.statusBadge.setBackgroundResource(R.drawable.bg_status_vigente)
            }
            
            binding.root.setOnClickListener {
                onPrescriptionClick(prescription)
            }
        }
    }
}

