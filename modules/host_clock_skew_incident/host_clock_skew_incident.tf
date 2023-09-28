resource "shoreline_notebook" "host_clock_skew_incident" {
  name       = "host_clock_skew_incident"
  data       = file("${path.module}/data/host_clock_skew_incident.json")
  depends_on = [shoreline_action.invoke_ntp_status_and_config,shoreline_action.invoke_ntp_stop_and_start,shoreline_action.invoke_ntp_check,shoreline_action.invoke_time_zone_checker,shoreline_action.invoke_ntp_service_check,shoreline_action.invoke_set_timezone]
}

resource "shoreline_file" "ntp_status_and_config" {
  name             = "ntp_status_and_config"
  input_file       = "${path.module}/data/ntp_status_and_config.sh"
  md5              = filemd5("${path.module}/data/ntp_status_and_config.sh")
  description      = "Check the NTP status and configuration"
  destination_path = "/agent/scripts/ntp_status_and_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ntp_stop_and_start" {
  name             = "ntp_stop_and_start"
  input_file       = "${path.module}/data/ntp_stop_and_start.sh"
  md5              = filemd5("${path.module}/data/ntp_stop_and_start.sh")
  description      = "Force NTP time synchronization"
  destination_path = "/agent/scripts/ntp_stop_and_start.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ntp_check" {
  name             = "ntp_check"
  input_file       = "${path.module}/data/ntp_check.sh"
  md5              = filemd5("${path.module}/data/ntp_check.sh")
  description      = "Misconfigured Network Time Protocol (NTP) server on the host, leading to incorrect synchronization of time."
  destination_path = "/agent/scripts/ntp_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "time_zone_checker" {
  name             = "time_zone_checker"
  input_file       = "${path.module}/data/time_zone_checker.sh"
  md5              = filemd5("${path.module}/data/time_zone_checker.sh")
  description      = "Incorrect system time zone settings on the host."
  destination_path = "/agent/scripts/time_zone_checker.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ntp_service_check" {
  name             = "ntp_service_check"
  input_file       = "${path.module}/data/ntp_service_check.sh"
  md5              = filemd5("${path.module}/data/ntp_service_check.sh")
  description      = "Verify that the Network Time Protocol (NTP) service is running and properly configured on the affected host(s). If NTP is not installed, install and configure it."
  destination_path = "/agent/scripts/ntp_service_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_timezone" {
  name             = "set_timezone"
  input_file       = "${path.module}/data/set_timezone.sh"
  md5              = filemd5("${path.module}/data/set_timezone.sh")
  description      = "Set server to the correct time zone"
  destination_path = "/agent/scripts/set_timezone.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ntp_status_and_config" {
  name        = "invoke_ntp_status_and_config"
  description = "Check the NTP status and configuration"
  command     = "`chmod +x /agent/scripts/ntp_status_and_config.sh && /agent/scripts/ntp_status_and_config.sh`"
  params      = []
  file_deps   = ["ntp_status_and_config"]
  enabled     = true
  depends_on  = [shoreline_file.ntp_status_and_config]
}

resource "shoreline_action" "invoke_ntp_stop_and_start" {
  name        = "invoke_ntp_stop_and_start"
  description = "Force NTP time synchronization"
  command     = "`chmod +x /agent/scripts/ntp_stop_and_start.sh && /agent/scripts/ntp_stop_and_start.sh`"
  params      = []
  file_deps   = ["ntp_stop_and_start"]
  enabled     = true
  depends_on  = [shoreline_file.ntp_stop_and_start]
}

resource "shoreline_action" "invoke_ntp_check" {
  name        = "invoke_ntp_check"
  description = "Misconfigured Network Time Protocol (NTP) server on the host, leading to incorrect synchronization of time."
  command     = "`chmod +x /agent/scripts/ntp_check.sh && /agent/scripts/ntp_check.sh`"
  params      = ["NTP_SERVER_IP_ADDRESS"]
  file_deps   = ["ntp_check"]
  enabled     = true
  depends_on  = [shoreline_file.ntp_check]
}

resource "shoreline_action" "invoke_time_zone_checker" {
  name        = "invoke_time_zone_checker"
  description = "Incorrect system time zone settings on the host."
  command     = "`chmod +x /agent/scripts/time_zone_checker.sh && /agent/scripts/time_zone_checker.sh`"
  params      = ["EXPECTED_TIMEZONE"]
  file_deps   = ["time_zone_checker"]
  enabled     = true
  depends_on  = [shoreline_file.time_zone_checker]
}

resource "shoreline_action" "invoke_ntp_service_check" {
  name        = "invoke_ntp_service_check"
  description = "Verify that the Network Time Protocol (NTP) service is running and properly configured on the affected host(s). If NTP is not installed, install and configure it."
  command     = "`chmod +x /agent/scripts/ntp_service_check.sh && /agent/scripts/ntp_service_check.sh`"
  params      = ["NTP_SERVER_IP"]
  file_deps   = ["ntp_service_check"]
  enabled     = true
  depends_on  = [shoreline_file.ntp_service_check]
}

resource "shoreline_action" "invoke_set_timezone" {
  name        = "invoke_set_timezone"
  description = "Set server to the correct time zone"
  command     = "`chmod +x /agent/scripts/set_timezone.sh && /agent/scripts/set_timezone.sh`"
  params      = []
  file_deps   = ["set_timezone"]
  enabled     = true
  depends_on  = [shoreline_file.set_timezone]
}

