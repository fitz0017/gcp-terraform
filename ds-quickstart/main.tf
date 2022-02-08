
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"
  name                 = "ds-demo"
  random_project_id    = true
  org_id               = "284623056809"
  billing_account      = "012F6C-5E9540-B1ECBD"
  activate_apis        = ["compute.googleapis.com", "cloudbilling.googleapis.com", "bigquery.googleapis.com", "sourcerepo.googleapis.com", "iam.googleapis.com", "cloudresourcemanager.googleapis.com"]
  # svpc_host_project_id = "shared_vpc_host_name"
  # shared_vpc_subnets = [
  #   "projects/base-project-196723/regions/us-east1/subnetworks/default",
  #   "projects/base-project-196723/regions/us-central1/subnetworks/default",
  #   "projects/base-project-196723/regions/us-central1/subnetworks/subnet-1",
  # ]
}

/*Org Policies*/
module "org-policy1" {
	source = "terraform-google-modules/org-policy/google"
	constraint = "compute.requireShieldedVm"
	policy_type = "boolean"
	policy_for = "project"
  project_id = module.project-factory.project_id
	organization_id = "284623056809"
	enforce = false
}

module "org-policy2" {
	source = "terraform-google-modules/org-policy/google" 
	policy_for = "project"
	project_id = module.project-factory.project_id
	constraint = "compute.vmExternalIpAccess"
	policy_type = "list"
	deny = [""]
  enforce = false 
}

module "cloud-nat" {
  source = "terraform-google-modules/cloud-nat/google"
  version = "~> 1.2"
  project_id = module.project-factory.project_id
  region = var.region
  create_router = true
  router = "us-east1-router" 
  name = "cloud-nat"
  network = module.vpc.network_name
}

module "datalab" {
  source             = "terraform-google-modules/datalab/google//modules/instance"
  project_id         = module.project-factory.project_id 
  name               = var.name
  zone               = var.zone
  datalab_user_email = var.datalab_user_email
  network_name       = module.vpc.network_name
  subnet_name        = module.vpc.subnets_self_links[0]
  create_fw_rule     = var.create_fw_rule
  enable_secure_boot = false 
} 

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 4.4"

  dataset_id                  = "us_census"
  dataset_name                = "us_census"
  description                 = "US Census data"
  project_id                  = module.project-factory.project_id
  location                    = "US"
  default_table_expiration_ms = 3600000
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.3"
  name       = "${module.project-factory.project_id}-ds-quickstart"
  project_id = module.project-factory.project_id
  location   = "us-east1"
  # iam_members = [{
  #   role   = "roles/storage.objectViewer"
  #   member = "user:example-user@example.com"
  # }]
}
