variable "ms_run_mode" {
  type        = string
  default     = "production"
  description = "Whether the ms.ms containers will run in development or production mode"
}

variable "ms_image_tag" {
  type        = string
  default     = null
  description = "App image version overrride for helm chart"
}
