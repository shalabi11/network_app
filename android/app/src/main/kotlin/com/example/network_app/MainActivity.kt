package com.example.network_app

import android.content.Context
import android.os.Build
import android.telephony.TelephonyManager
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoWcdma
import android.telephony.CellInfoNr
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.network_app/cell_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getConnectedCell" -> {
                    try {
                        val cellInfo = getConnectedCellInfo()
                        result.success(cellInfo)
                    } catch (e: SecurityException) {
                        result.error("PERMISSION_DENIED", "Phone state permission denied", null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get cell info: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getConnectedCellInfo(): Map<String, Any?> {
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val cellInfo = telephonyManager.allCellInfo?.firstOrNull { it.isRegistered } ?: return emptyMap()

        return when (cellInfo) {
            is CellInfoGsm -> {
                val identity = cellInfo.cellIdentity
                mapOf(
                    "mcc" to identity.mcc,
                    "mnc" to identity.mnc,
                    "lac" to identity.lac,
                    "cellId" to identity.cid,
                    "networkType" to "GSM",
                    "signalStrength" to cellInfo.cellSignalStrength.dbm
                )
            }
            is CellInfoLte -> {
                val identity = cellInfo.cellIdentity
                mapOf(
                    "mcc" to identity.mcc,
                    "mnc" to identity.mnc,
                    "lac" to identity.tac,
                    "cellId" to identity.ci,
                    "networkType" to "LTE",
                    "signalStrength" to cellInfo.cellSignalStrength.dbm
                )
            }
            is CellInfoWcdma -> {
                val identity = cellInfo.cellIdentity
                mapOf(
                    "mcc" to identity.mcc,
                    "mnc" to identity.mnc,
                    "lac" to identity.lac,
                    "cellId" to identity.cid,
                    "networkType" to "WCDMA",
                    "signalStrength" to cellInfo.cellSignalStrength.dbm
                )
            }
            is CellInfoNr -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val identity = cellInfo.cellIdentity as android.telephony.CellIdentityNr
                    mapOf(
                        "mcc" to identity.mccString?.toIntOrNull(),
                        "mnc" to identity.mncString?.toIntOrNull(),
                        "lac" to identity.tac,
                        "cellId" to identity.nci,
                        "networkType" to "NR",
                        "signalStrength" to cellInfo.cellSignalStrength.dbm
                    )
                } else {
                    emptyMap()
                }
            }
            else -> emptyMap()
        }
    }
}
