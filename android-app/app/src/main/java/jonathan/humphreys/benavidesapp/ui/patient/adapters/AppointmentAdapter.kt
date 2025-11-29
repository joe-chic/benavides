package jonathan.humphreys.benavidesapp.ui.patient.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.data.model.Appointment
import jonathan.humphreys.benavidesapp.databinding.ItemAppointmentCardBinding
import jonathan.humphreys.benavidesapp.databinding.ItemAppointmentDateHeaderBinding
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AppointmentAdapter(
    private var groupedAppointments: Map<String, List<Appointment>>,
    private val onAppointmentClick: (Appointment) -> Unit
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    companion object {
        private const val TYPE_DATE_HEADER = 0
        private const val TYPE_APPOINTMENT = 1
        private val INPUT_FORMATS = listOf(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ssXXX",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ssXXX",
            "yyyy-MM-dd HH:mm:ss"
        )
        private val OUTPUT_FORMAT = SimpleDateFormat("dd MMM yyyy · hh:mm a", Locale.getDefault())
    }

    private val items = mutableListOf<Any>()

    init {
        updateItems()
    }

    fun updateAppointments(grouped: Map<String, List<Appointment>>) {
        groupedAppointments = grouped
        updateItems()
        notifyDataSetChanged()
    }

    private fun updateItems() {
        items.clear()
        groupedAppointments.entries.sortedByDescending { it.key }.forEach { (date, appointments) ->
            items.add(date)
            items.addAll(appointments)
        }
    }

    override fun getItemViewType(position: Int): Int {
        return when (items[position]) {
            is String -> TYPE_DATE_HEADER
            is Appointment -> TYPE_APPOINTMENT
            else -> TYPE_APPOINTMENT
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            TYPE_DATE_HEADER -> {
                val binding = ItemAppointmentDateHeaderBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                DateHeaderViewHolder(binding)
            }
            else -> {
                val binding = ItemAppointmentCardBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                AppointmentViewHolder(binding, onAppointmentClick)
            }
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is DateHeaderViewHolder -> holder.bind(items[position] as String)
            is AppointmentViewHolder -> holder.bind(items[position] as Appointment)
        }
    }

    override fun getItemCount(): Int = items.size

    class DateHeaderViewHolder(
        private val binding: ItemAppointmentDateHeaderBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(date: String) {
            binding.dateText.text = date
        }
    }

    inner class AppointmentViewHolder(
        private val binding: ItemAppointmentCardBinding,
        private val onAppointmentClick: (Appointment) -> Unit
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(appointment: Appointment) {
            binding.appointmentReason.text = appointment.reason ?: "Consulta general"
            binding.doctorName.text = "Médico: ${appointment.doctorName ?: "Por definir"}"
            binding.locationInfo.text = "Modalidad: Presencial"

            binding.appointmentDate.text =
                formatDate(appointment.appointmentDateTime) ?: "Fecha por definir"

            val normalizedStatus = normalizeStatus(appointment.status?.lowercase(Locale.getDefault()) ?: "scheduled")
            binding.statusBadge.text = getStatusDisplay(normalizedStatus)
            binding.statusBadge.setBackgroundResource(getStatusBackground(normalizedStatus))

            binding.rescheduleButton.setOnClickListener {
                onAppointmentClick(appointment)
            }
            binding.cancelButton.setOnClickListener {
                onAppointmentClick(appointment)
            }
            binding.root.setOnClickListener {
                onAppointmentClick(appointment)
            }
        }

        private fun formatDate(dateStr: String?): String? {
            if (dateStr.isNullOrBlank()) return null
            val parsed = parseDate(dateStr) ?: return null
            return OUTPUT_FORMAT.format(parsed)
        }

        private fun getStatusBackground(status: String): Int {
            return when (status) {
                "scheduled", "programada" -> R.drawable.bg_status_scheduled
                "completed", "finalizada" -> R.drawable.bg_status_completed
                "cancelled", "cancelada" -> R.drawable.bg_status_cancelada
                "missed", "no asistió" -> R.drawable.bg_status_missed
                else -> R.drawable.bg_status_scheduled
            }
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

    private fun normalizeStatus(status: String): String {
        return when (status) {
            "programada", "scheduled" -> "scheduled"
            "finalizada", "completed" -> "completed"
            "cancelada", "cancelled" -> "cancelled"
            "no asistió", "no asistio", "missed" -> "missed"
            else -> status
        }
    }

    private fun getStatusDisplay(status: String): String {
        return when (status) {
            "scheduled" -> "Programada"
            "completed" -> "Finalizada"
            "cancelled" -> "Cancelada"
            "missed" -> "No asistió"
            else -> status.replaceFirstChar {
                if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
            }
        }
    }
}


