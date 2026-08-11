variable "project_name" {
  description = "Used for naming and tagging all RDS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS security group will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (must span 2+ AZs)"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "RDS DB subnet groups require subnets in at least 2 different Availability Zones."
  }
}

variable "app_security_group_id" {
  description = "Security group ID of the app tier — the ONLY thing allowed to reach port 5432"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.", var.instance_class))
    error_message = "instance_class must start with 'db.' (e.g. db.t3.micro)."
  }
}

variable "allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Storage autoscaling ceiling in GB (0 disables autoscaling)"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Initial database name created inside the instance"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username (NOT the password — that's generated)"
  type        = string
  default     = "dbadmin"
}

variable "multi_az" {
  description = "Enable synchronous standby in a second AZ (roughly doubles cost)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Days to retain automated backups (0 disables them — never do this in prod)"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "true = destroy leaves no trace (fine for learning). false = production default"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "When true, AWS refuses terraform destroy at the API level until you disable this"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
