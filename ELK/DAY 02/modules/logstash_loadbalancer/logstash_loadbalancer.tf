data "google_compute_region_instance_group" "public" {
  name                      = var.instance_group_name_public 
}

#----------------------------------------------------------------#
# Create compute global forwarding rules for logstash instances  #
#----------------------------------------------------------------#

resource "google_compute_global_forwarding_rule" "logstash" {
  name                      = var.forwarding_rule
  target                    = google_compute_target_http_proxy.logstash.id
  port_range                = var.port_range
}

#--------------------------------------------------------------------------------#
# Create global forwarding rule to route incoming HTTP requests to a URL map     #
#--------------------------------------------------------------------------------#

resource "google_compute_target_http_proxy" "logstash" {
  name                      = var.target_proxy
  url_map                   = google_compute_url_map.logstash.id
}

#-------------------------------------------------------------#
# Create compute url map of logstash instances                #
#-------------------------------------------------------------#

resource "google_compute_url_map" "logstash" {
  name                      = var.proxy_url_map
  default_service           = google_compute_backend_service.logstash-backend.id
}

#-------------------------------------------------------------#
# Create compute backend-service for logstash loadbalancer    #
#-------------------------------------------------------------#

resource "google_compute_backend_service" "logstash-backend" {
  name                      = var.name_backend
  project                   = var.project
  backend {
    #balancing_mode          = "UTILIZATION"
    #capacity_scaler         = 1.0
    group                   = data.google_compute_region_instance_group.public.self_link
  }
  health_checks             = [google_compute_health_check.ppublic-autohealing.id]
}

#-----------------------------------------------------------#
# Create compute autohealing policy for logstash instances  #
#-----------------------------------------------------------#

resource "google_compute_health_check" "ppublic-autohealing" {
  name                          = "ppublic-autohealing"
  check_interval_sec            = "5"
  timeout_sec                   = "5"
  healthy_threshold             = "2"
  unhealthy_threshold           = "2"

  tcp_health_check {
    port                        = "80"
  }
}
