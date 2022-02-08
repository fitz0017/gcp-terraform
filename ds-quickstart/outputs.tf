/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "network_name" {
  description = "Network name"
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "Subnet name"
  value       = module.vpc.subnets_self_links[0]
}


output "firewall_name" {
  description = "The name of the firewall rule"
  value       = module.datalab.firewall_name
}

output "disk_name" {
  description = "The name of the persistent disk"
  value       = module.datalab.disk_name
}

output "disk_size" {
  description = "The size of the persistent disk"
  value       = module.datalab.disk_size
}

output "instance_name" {
  description = "The instance name"
  value       = module.datalab.instance_name
}

output "labels" {
  description = "A map of key/value label pairs to assigned to the instance."
  value       = module.datalab.labels
}

output "buckets" {
    value = module.bucket
}
