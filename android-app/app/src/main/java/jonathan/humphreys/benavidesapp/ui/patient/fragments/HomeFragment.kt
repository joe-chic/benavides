package jonathan.humphreys.benavidesapp.ui.patient.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import jonathan.humphreys.benavidesapp.R
import jonathan.humphreys.benavidesapp.data.api.RetrofitClient
import jonathan.humphreys.benavidesapp.data.model.Appointment
import jonathan.humphreys.benavidesapp.data.model.PersonalInfoResponse
import jonathan.humphreys.benavidesapp.data.model.Prescription
import jonathan.humphreys.benavidesapp.databinding.FragmentHomeBinding
import jonathan.humphreys.benavidesapp.util.SharedPreferencesHelper
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class HomeFragment : Fragment() {

    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!
    private lateinit var prefsHelper: SharedPreferencesHelper
    private val locale = Locale("es", "MX")

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        prefsHelper = SharedPreferencesHelper(requireContext())
        loadDashboard()
    }

    private fun loadDashboard() {
        val token = prefsHelper.getAccessToken()
        val patientId = prefsHelper.getUserId()

        if (token.isNullOrBlank() || patientId.isNullOrBlank()) {
            Toast.makeText(requireContext(), getString(R.string.error_network), Toast.LENGTH_SHORT).show()
            binding.homeProgress.isVisible = false
            binding.homeContent.isVisible = false
            return
        }

        binding.homeProgress.isVisible = true
        binding.homeContent.isVisible = false

        lifecycleScope.launch {
            try {
                val authHeader = "Bearer $token"
                val personalDeferred = async {
                    RetrofitClient.patientApiService.getPersonalInfo(authHeader, patientId)
                }
                val appointmentsDeferred = async {
                    RetrofitClient.appointmentApiService.getAppointments(authHeader, patientId, limit = 50)
                }
                val prescriptionsDeferred = async {
                    RetrofitClient.prescriptionApiService.getPrescriptions(authHeader, patientId, skip = 0, limit = 50)
                }

                val personalInfo = personalDeferred.await().body()
                val appointmentsResponse = appointmentsDeferred.await()
                val prescriptionsResponse = prescriptionsDeferred.await()

                if (!appointmentsResponse.isSuccessful || !prescriptionsResponse.isSuccessful) {
                    Toast.makeText(requireContext(), R.string.error_network, Toast.LENGTH_SHORT).show()
                }

                bindPersonalInfo(personalInfo)
                bindAppointments(appointmentsResponse.body().orEmpty())
                bindPrescriptions(prescriptionsResponse.body().orEmpty())

                binding.homeContent.isVisible = true
            } catch (e: Exception) {
                e.printStackTrace()
                Toast.makeText(requireContext(), getString(R.string.error_network), Toast.LENGTH_SHORT).show()
                binding.homeContent.isVisible = true
            } finally {
                binding.homeProgress.isVisible = false
            }
        }
    }

    private fun bindPersonalInfo(info: PersonalInfoResponse?) {
        val displayName = info?.fullName?.split(" ")?.firstOrNull()?.replaceFirstChar {
            if (it.isLowerCase()) it.titlecase(locale) else it.toString()
        } ?: getString(R.string.welcome)
        binding.welcomeTitle.text = getString(R.string.home_welcome, displayName)

        val idText = info?.patientId?.take(8)?.uppercase(locale) ?: "--"
        val subtitle = listOf("ID: $idText", info?.email ?: "--").joinToString(" • ")
        binding.welcomeSubtitle.text = subtitle
    }

    private fun bindAppointments(appointments: List<Appointment>) {
        val scheduledCount = appointments.count {
            val status = it.status?.lowercase(locale)
            status == "scheduled" || status == "programada"
        }
        binding.quickStatAppointmentsValue.text = scheduledCount.toString()

        val now = Date()
        val upcoming = appointments
            .mapNotNull { appt ->
                val date = parseDate(appt.appointmentDateTime)
                date?.let { Pair(it, appt) }
            }
            .filter { it.first.after(now) }
            .sortedBy { it.first }
            .firstOrNull()

        if (upcoming != null) {
            val (date, appt) = upcoming
            binding.upcomingAppointmentEmpty.visibility = View.GONE
            binding.upcomingAppointmentStatus.text = formatAppointmentStatus(appt.status)
            binding.upcomingAppointmentDate.text = formatDate(date, includeTime = true)
            binding.upcomingAppointmentDoctor.text =
                appt.doctorName?.let { "Con ${it}" } ?: getString(R.string.home_status_placeholder)
            binding.upcomingAppointmentReason.text =
                appt.reason?.let { "Motivo: $it" } ?: ""
        } else {
            binding.upcomingAppointmentStatus.text = getString(R.string.home_status_placeholder)
            binding.upcomingAppointmentDate.text = ""
            binding.upcomingAppointmentDoctor.text = ""
            binding.upcomingAppointmentReason.text = ""
            binding.upcomingAppointmentEmpty.visibility = View.VISIBLE
        }
    }

    private fun bindPrescriptions(prescriptions: List<Prescription>) {
        binding.quickStatPrescriptionsValue.text = prescriptions.size.toString()

        val counts = prescriptions.groupBy { (it.status ?: "vigente").lowercase(locale) }
        val vigentes = counts["vigente"]?.size ?: 0
        val dispensadas = counts["dispensada"]?.size ?: 0
        val other = prescriptions.size - vigentes - dispensadas

        binding.prescriptionsVigente.text = getString(R.string.prescriptions_vigente_label, vigentes)
        binding.prescriptionsDispensada.text = getString(R.string.prescriptions_dispensada_label, dispensadas)
        binding.prescriptionsOther.text = getString(R.string.prescriptions_otras_label, other.coerceAtLeast(0))

        binding.recentPrescriptionsContainer.removeAllViews()
        if (prescriptions.isEmpty()) {
            binding.prescriptionsEmpty.visibility = View.VISIBLE
            return
        }
        binding.prescriptionsEmpty.visibility = View.GONE

        prescriptions
            .sortedByDescending { parseDate(it.createdAt) ?: Date(0L) }
            .take(3)
            .forEach { prescription ->
                binding.recentPrescriptionsContainer.addView(buildPrescriptionRow(prescription))
            }
    }

    private fun buildPrescriptionRow(prescription: Prescription): View {
        val context = requireContext()
        val container = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(0, 8, 0, 8)
        }

        val codeView = TextView(context).apply {
            text = prescription.prescriptionCode
            setTextColor(ContextCompat.getColor(context, R.color.text_dark))
            textSize = 16f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
        }

        val meta = TextView(context).apply {
            val created = formatDate(parseDate(prescription.createdAt), includeTime = false)
            text = "${formatPrescriptionStatus(prescription.status)} • $created"
            setTextColor(ContextCompat.getColor(context, R.color.text_secondary))
            textSize = 14f
        }

        container.addView(codeView)
        container.addView(meta)
        return container
    }

    private fun parseDate(raw: String?): Date? {
        if (raw.isNullOrBlank()) return null
        val normalized = raw.replace("Z", "+00:00")
        val patterns = listOf(
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXX",
            "yyyy-MM-dd HH:mm:ssXXX",
            "yyyy-MM-dd HH:mm:ss"
        )
        for (pattern in patterns) {
            try {
                return SimpleDateFormat(pattern, Locale.US).parse(normalized)
            } catch (_: Exception) {
            }
        }
        return null
    }

    private fun formatDate(date: Date?, includeTime: Boolean): String {
        if (date == null) return "--"
        val pattern = if (includeTime) "dd 'de' MMM yyyy • HH:mm" else "dd 'de' MMM yyyy"
        return SimpleDateFormat(pattern, locale).format(date)
    }

    private fun formatAppointmentStatus(status: String?): String {
        return when (status?.lowercase(locale)) {
            "scheduled", "programada" -> "Programada"
            "completed", "completada" -> "Completada"
            "cancelled", "cancelada" -> "Cancelada"
            "missed", "perdida" -> "Perdida"
            else -> status?.replaceFirstChar {
                if (it.isLowerCase()) it.titlecase(locale) else it.toString()
            } ?: getString(R.string.home_status_placeholder)
        }
    }

    private fun formatPrescriptionStatus(status: String?): String {
        return when (status?.lowercase(locale)) {
            "vigente" -> "Vigente"
            "dispensada" -> "Dispensada"
            "vencida" -> "Vencida"
            "cancelada" -> "Cancelada"
            else -> status?.replaceFirstChar {
                if (it.isLowerCase()) it.titlecase(locale) else it.toString()
            } ?: getString(R.string.home_status_placeholder)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

